//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Karki, Ganesh | Ganesh | OSPD on 3/22/17.
//  Copyright © 2017 Karki, Ganesh | Ganesh | OSPD. All rights reserved.
//

import Foundation

class CalculatorBrain {
    typealias PropertyList = AnyObject
    private var internalProgram = [AnyObject]()
    
    private var accumulator = 0.0
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand)
    }
    
    var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "=" : Operation.Equals
        ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
    }
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol) 
        if let operation = operations[symbol]{
            switch operation{
                case .Constant(let value):
                    accumulator = value
                case .UnaryOperation(let function):
                    accumulator = function(accumulator)
                case .BinaryOperation(let function):
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                case .Equals:
                    executePendingBinaryOperation()
            }
        }
        
    }
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand)
                    } else if let operation = op as? String{
                        performOperation(operation)
                    }
                }
            }
            
        }
    }
    
    private func clear(){
        internalProgram.removeAll()
        pending = nil
        accumulator = 0.0
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    var  result: Double{
        get {
            return accumulator
        }
    }
    
    func isDecimalNotPresent(value: String) -> Bool {
        return value.rangeOfString(String(".")) == nil
    }
}
