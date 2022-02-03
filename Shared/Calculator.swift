//
//  Calculator.swift
//  HW 2 Sin
//
//  Created by Michael Cardiff on 2/3/22.
//

import Foundation
import SwiftUI
import CorePlot

typealias nthTermParameterTuple = (n: Int, x: Double)
typealias nthTermMultiplierHandler = (_ parameters: [nthTermParameterTuple]) -> Double
typealias ErrorHandler = (_ parameters: [ErrorParameterTuple]) -> Double
typealias ErrorParameterTuple = (n: Int, x: Double, sum: Double)

class Calculator: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var plotError: Bool = false
    
    /// calculate1DInfiniteSum
    /// - Parameters:
    ///   - function: function describing the nth term multiplier in the expansion
    ///   - x: value to be calculated
    ///   - minimum: minimum term in the sum usually 0 or 1
    ///   - maximum: maximum value of n in the expansion. Basically prevents an infinite loop
    ///   - firstTerm: First term in the expansion usually the value of the sum at the minimum
    ///   - isPlotError: boolean that describes whether to plot the value of the sum or the error with respect to a known value
    ///   - errorType: function used to calculate the log of the error when the exact value is known
    /// - Returns: the value of the infite sum
    func calculate1DInfiniteSum(function: nthTermMultiplierHandler, x: Double, offset: Double, minimum: Int, maximum: Int, firstTerm: Double, isPlotError: Bool, errorType: ErrorHandler) -> Double {
        
        var plotData :[plotDataType] =  []
        var sum = 0.0
        var previousTerm = firstTerm
        var currentTerm = 0.0
        let lowerIndex = minimum + 1
        
        //Deal with the First Point in the Infinite Sum
        
        let errorParameters: [ErrorParameterTuple] = [(n: minimum, x: x, sum: previousTerm)]
        let error = errorType(errorParameters)
        
        plotDataModel!.calculatedText.append("\(minimum), \t\(previousTerm + offset), \t\(error)\n")
        
        if isPlotError {
            let dataPoint: plotDataType = [.X: Double(1), .Y: (error)]
            plotData.append(contentsOf: [dataPoint])
        } else {
            let dataPoint: plotDataType = [.X: Double(minimum), .Y: (previousTerm)]
            plotData.append(contentsOf: [dataPoint])
            print("n is \(minimum), x is \(x), currentTerm = \(previousTerm + offset)")
            
        }
        
        sum += firstTerm
        
        for n in lowerIndex...maximum {
            
            let parameters: [nthTermParameterTuple] = [(n: n, x: x)]
            
            // Calculate the infinite sum using the function that calculates the multiplier of the nth them in the series from the (n-1)th term.
            
            currentTerm = function(parameters) * previousTerm
            
            print("n is \(n), x is \(x), currentTerm = \(currentTerm)")
            sum += currentTerm
            
            let errorParameters: [ErrorParameterTuple] = [(n: n, x: x, sum: sum)]
            let error = errorType(errorParameters)
            
            plotDataModel!.calculatedText.append("\(n), \t\(sum + offset), \t\(error)\n")
            
            print("The current ulp of sum is \(sum.ulp)")
            
            previousTerm = currentTerm
            
            if !isPlotError{
                let dataPoint: plotDataType = [.X: Double(n), .Y: (sum + offset)]
                plotData.append(contentsOf: [dataPoint])
            } else {
                let dataPoint: plotDataType = [.X: Double(n), .Y: (error)]
                plotData.append(contentsOf: [dataPoint])
            }
            
            // Stop the summation when the current term is within machine precision of the total sum.
            
            if (abs(currentTerm) < sum.ulp) { break }
        }
        plotDataModel!.appendData(dataPoint: plotData)
        return sum
    }
    
    /// clipToRange
    /// Limit the parameter xVal to the range -Pi, Pi
    func clipToRange(x: Double) -> Double {
        var xVal = x
        
        if (xVal > Double.pi) {
            repeat { xVal -= 2.0*Double.pi } while xVal > Double.pi
        } else if (xVal < -Double.pi){
            repeat { xVal += 2.0*Double.pi } while xVal < -Double.pi
        }
        return xVal
    }
}
