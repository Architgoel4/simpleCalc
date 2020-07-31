//
//  CalculatorBrain.swift
//  SimpleCalc
//
//  Created by Archit Goel on 16/07/17.
//  Copyright © 2017 Archigoel. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}
func multiple(op1:Double, op2: Double) ->Double{
    return op1 * op2
}

struct CalculatorBrain  {
    
    mutating func addUnaryOperation(named symbol: String,_ operation: @escaping (Double) -> Double){
        operations[symbol] = Operation.unaryOperation(operation)
        
    }
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> =  [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt), //sqrt
        "cos": Operation.unaryOperation(cos), //cos
        "±": Operation.unaryOperation({-$0}),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "=": Operation.equals
        
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value
                
            case .unaryOperation(let f):
                if accumulator != nil{
                    accumulator = f(accumulator!)
                }
            case .binaryOperation(let f):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
        
    }
    
    
    mutating private func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
        
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
        
    }
    
    var result: Double?{
        get{
            return accumulator
        }
        
    }
}
