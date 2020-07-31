//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Archit Goel on 03/06/17.
//  Copyright © 2017 Archigoel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        brain.addUnaryOperation(named: "✅"){ [unowned self] in
            self.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInMiddleOfTyping = false
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func digitTouch(_ sender: UIButton) {
        let digit = sender.currentTitle!
         if userIsInMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else{
            display.text  = digit
            userIsInMiddleOfTyping = true
        }
    }
    var displayValue : Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain : CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
            
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        
    }
    
    
}

