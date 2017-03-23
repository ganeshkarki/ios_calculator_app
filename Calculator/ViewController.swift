//
//  ViewController.swift
//  Calculator
//
//  Created by Karki, Ganesh | Ganesh | OSPD on 3/21/17.
//  Copyright © 2017 Karki, Ganesh | Ganesh | OSPD. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    let space = String(" ");
    
    var userInMiddleOfTyping = false
    var decimalEntered = false
    var expressionFinished = false
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    @IBAction func touchDigit(sender: UIButton) {
        if expressionFinished{ history.text = nil ; expressionFinished = false}
        let digit = sender.currentTitle!
        if userInMiddleOfTyping {
            let textCurrentlyInDisplay = display.text
            display.text = textCurrentlyInDisplay! + digit
        }else{
            display.text = digit
        }
        userInMiddleOfTyping = true
    }
    
    var displayValue: Double{
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    
    
    @IBAction func performOperation(sender: UIButton) {
        if userInMiddleOfTyping {
            brain.setOperand(displayValue)
            userInMiddleOfTyping = false
        }
        var mathematicalSymbol: String!
        mathematicalSymbol = sender.currentTitle
        brain.performOperation(mathematicalSymbol)
        
        
        if expressionFinished{ history.text = nil ; expressionFinished = false}
        if let hist = history.text {
            history.text = hist + space + String(displayValue) + space + mathematicalSymbol
        } else {
            history.text =  String(displayValue) + space + mathematicalSymbol
        }
        
        if mathematicalSymbol == String("=") {
            history.text = history.text! + space + String(brain.result)
            expressionFinished = true
        }
        
        displayValue = brain.result

    }
    
    @IBAction func touchDecimal(sender: UIButton) {
        
        if let textCurrentlyInDisplay = display.text {
            if brain.isDecimalNotPresent(textCurrentlyInDisplay){
                display.text = textCurrentlyInDisplay + String(".")
            }
        } else {
            display.text = String("0.")
        }
        decimalEntered = true
    }
    
    @IBAction func clearHistory(sender: UIButton) {
        history.text = String("")
        display.text = String("0")
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    @IBAction func save(sender: AnyObject) {
        savedProgram = brain.program
    }
    
    @IBAction func resore(sender: AnyObject) {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
}

