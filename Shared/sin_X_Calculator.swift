//
//  sin_X_Calculator.swift
//  HW 2 Sin (iOS)
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

class Sin_X_Calculator: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var plotError: Bool = false
    
    
    
    /// calculate_sin_x
    /// - Parameter x: values of x in sin(x)
    /// - Returns: sin(x)
    /// This function limits the range of x to the first period of -π to π
    ///
    ///                   oo                   2n-1
    ///                   __          n-1    x
    ///    sin (x)  =    \        (-1)     ------
    ///                  /__               (2n-1)!
    ///                  n = 1
    ///
    func calculate_sin_x(x: Double) -> Double{
        
        var sinXminusOne = 0.0
        var xInRange = x
        var sinX = 0.0
        
        if (xInRange > Double.pi) {
        
            repeat {
                      xInRange -= 2.0*Double.pi
            } while xInRange > Double.pi
        
        }
        else if (xInRange < -Double.pi){
        
            repeat {
                      xInRange += 2.0*Double.pi
            } while xInRange < -Double.pi
        
        }
        
        
        sinXminusOne = calculate_cos_xMinus1(x: xInRange)
        
        sinX = sinXminusOne + 1.0
        print(sinX)
        
        return (sinX)
    }
    
    /// calculate_cos_xMinus1
    /// - Parameter x: values of x in cos(x)
    /// - Returns: cos(x) - 1
    /// This function calculates the Taylor Series Expansion of cos(x) - 1
    ///
    //                      oo                   2n
    //                      __             n    x
    //    cos (x) - 1   =   \        ( - 1)   ------
    //                      /__               (2n)!
    //                     n = 1
    ///
    func calculate_cos_xMinus1(x: Double) -> Double{
        
        var cosXminusOne = 0.0
        let firstTerm = -1.0/2.0 * (x↑2.0)
        let zerothTerm = 1.0
        var zerothError = 0.0
        let actualcos_x = cos(x)
        
        //Print Header
        plotDataModel!.calculatedText = "x = \(x), \tcox(x) = \(actualcos_x)\n"
        plotDataModel!.calculatedText += "Point, \tcos(x), \tError\n"
        
        //Calculate Error of Zeroth Point
        
        if(actualcos_x != 0.0){
            var numerator = 1.0 - actualcos_x
            if(numerator == 0.0) { numerator = 1.0E-16 }
            zerothError = (log10(abs((numerator)/actualcos_x)))
            
        } else {
            zerothError = 0.0
        }
        
        //Print Zereoth Poin
        plotDataModel!.calculatedText += "0.0, \t\(zerothTerm), \t\(zerothError)\n"
        plotDataModel!.zeroData()
        
        if !plotError  {
            //set the Plot Parameters
            plotDataModel!.changingPlotParameters.yMax = 1.5
            plotDataModel!.changingPlotParameters.yMin = -1.5
            plotDataModel!.changingPlotParameters.xMax = 15.0
            plotDataModel!.changingPlotParameters.xMin = -1.0
            plotDataModel!.changingPlotParameters.xLabel = "n"
            plotDataModel!.changingPlotParameters.yLabel = "cos(x)"
            plotDataModel!.changingPlotParameters.lineColor = .red()
            plotDataModel!.changingPlotParameters.title = "cos(x) vs n"
            
            // Plot first point of cos
            let dataPoint: plotDataType = [.X: 0.0, .Y: (1.0)]
            plotDataModel!.appendData(dataPoint: [dataPoint])
        } else {
            //set the Plot Parameters
            plotDataModel!.changingPlotParameters.yMax = 18.0
            plotDataModel!.changingPlotParameters.yMin = -18.1
            plotDataModel!.changingPlotParameters.xMax = 15.0
            plotDataModel!.changingPlotParameters.xMin = -1.0
            plotDataModel!.changingPlotParameters.xLabel = "n"
            plotDataModel!.changingPlotParameters.yLabel = "Abs(log(Error))"
            plotDataModel!.changingPlotParameters.lineColor = .red()
            plotDataModel!.changingPlotParameters.title = "Error cos(x) vs n"
                
            
            // Plot first point of error
            let dataPoint: plotDataType = [.X: 0.0, .Y: (zerothError)]
            plotDataModel!.appendData(dataPoint: [dataPoint])
        }
        // Calculate the infinite sum using the function that calculates the multiplier of the nth term in the series.
        
        cosXminusOne = calculate1DInfiniteSum(function: cosnthTermMultiplier, x: x, minimum: 1, maximum: 100, firstTerm: firstTerm, isPlotError: plotError, errorType: cosErrorCalculator  )
        
        return (cosXminusOne)
    }
    
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
    func calculate1DInfiniteSum(function: nthTermMultiplierHandler, x: Double, minimum: Int, maximum: Int, firstTerm: Double, isPlotError: Bool, errorType: ErrorHandler ) -> Double {
        
        
        var plotData :[plotDataType] =  []

        var sum = 0.0
        var previousTerm = firstTerm
        var currentTerm = 0.0
        let lowerIndex = minimum + 1
        
        
        //Deal with the First Point in the Infinite Sum
        
        let errorParameters: [ErrorParameterTuple] = [(n: minimum, x: x, sum: previousTerm)]
        let error = errorType(errorParameters)
        
        plotDataModel!.calculatedText.append("\(minimum), \t\(previousTerm + 1.0), \t\(error)\n")
        
        
        if isPlotError {
            
            
            let dataPoint: plotDataType = [.X: Double(1), .Y: (error)]
            plotData.append(contentsOf: [dataPoint])
            
            
        }
        else{
            
            let dataPoint: plotDataType = [.X: Double(minimum), .Y: (previousTerm)]
            plotData.append(contentsOf: [dataPoint])
            
            print("n is \(minimum), x is \(x), currentTerm = \(previousTerm + 1.0)")
            
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
            
            plotDataModel!.calculatedText.append("\(n), \t\(sum + 1.0), \t\(error)\n")
            
            print("The current ulp of sum is \(sum.ulp)")
            
            previousTerm = currentTerm
            
            if !isPlotError{
                
                let dataPoint: plotDataType = [.X: Double(n), .Y: (sum + 1.0)]
                plotData.append(contentsOf: [dataPoint])
            }
            else{
                
                
                let dataPoint: plotDataType = [.X: Double(n), .Y: (error)]
                plotData.append(contentsOf: [dataPoint])
                
            }
            
            // Stop the summation when the current term is within machine precision of the total sum.
            
            if (abs(currentTerm) < sum.ulp){
                
                break
            }
        
        
        
    }

        plotDataModel!.appendData(dataPoint: plotData)
        return sum


    }
    
    /// sinnthTermMultiplier
    /// - Parameter parameters: Tuple containing the value of x and n
    /// - Returns: nth term multiplier (first term on the right side of the equation below)
    ///
    //                               2
    //      th                     x                     th
    //    n   term  =    ( - 1)  ---------    *   (n - 1)    term
    //                         (2n-1)*(2n-2)
    //
    ///
    func sinnthTermMultiplier(parameters: [nthTermParameterTuple])-> Double{
        
        var nthTermMultiplier = 0.0
        let n = Double(parameters[0].n)
        let x = parameters[0].x
        
        let denominator = (2.0 * n - 2) * (2.0 * n - 1)
        
        nthTermMultiplier =  -1.0 / (denominator) * (x↑2.0)
        
        return (nthTermMultiplier)
        
    }
    
    func sinErrorCalculator(parameters: [ErrorParameterTuple])-> Double{
        
        var error = 0.0
        _ = Double(parameters[0].n)
        let x = parameters[0].x
        let sum = parameters[0].sum + 1.0
        
        let actualsin_x = sin(x)
        
        if(actualsin_x != 0.0){
            
            var numerator = sum - actualsin_x
            
            if(numerator == 0.0) {numerator = sum.ulp}
            
            error = (log10(abs((numerator)/actualsin_x)))
            
            
        } else {
            error = 0.0
        }
        
        return (error)
        
    }

}
