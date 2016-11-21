//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Taufiqur Rahman on 11/17/16.
//  Copyright © 2016 Taufiqur Rahman. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperation(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "∏" : Operation.Constant(M_PI), //M_PI,
        //"e" : Operation.Constant(M_E), //M_E
        "√" :Operation.UnaryOperation(sqrt),
        //"cos": Operation.UnaryOperation(cos),
        //"tan" : Operation.UnaryOperation(tan),
        //"±" : Operation.UnaryOperation({-$0}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "=" : Operation.Equals
    ]
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let value):
                    accumulator = value
                case .UnaryOperation(let function):
                    accumulator = function(accumulator)
                case . BinaryOperation(let function):
                    executePendingBinaryoperation()
                    pending = PendingBinaryOperationInfo(binaryFunction: function,firstOperand:accumulator)
                case .Equals:
                    executePendingBinaryoperation()
                
            }
        }
    }
    private func executePendingBinaryoperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperation(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                    
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
}