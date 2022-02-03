//
//  sin_X_Calculator.swift
//  HW 2 Sin (iOS)
//
//  Created by Michael Cardiff on 2/3/22.
//

import Foundation
import SwiftUI
import CorePlot

// already done in cosine calculator
/*
typealias nthTermParameterTuple = (n: Int, x: Double)
typealias nthTermMultiplierHandler = (_ parameters: [nthTermParameterTuple]) -> Double
typealias ErrorHandler = (_ parameters: [ErrorParameterTuple]) -> Double
typealias ErrorParameterTuple = (n: Int, x: Double, sum: Double)
*/
class Sin_X_Calculator: Calculator {
    
    
    /// calculate_cos_xMinus1
    /// - Parameter x: values of x in cos(x)
    /// - Returns: cos(x) - 1
    /// This function calculates the Taylor Series Expansion of cos(x) - 1
    ///
    //                oo                      2n-1
    //                __             n-1     x
    //    sin (x) =   \        ( - 1)     --------
    //                /__                  (2n-1)!
    //               n = 1
    ///
    func calculate_sin_x(x: Double) -> Double{
        
        var sinX = 0.0
        let zerothTerm = 0.0
        var zerothError = 0.0
        let firstTerm = clipToRange(x: x)
        let actualsin_x = sin(x)
        
        //Print Header
        plotDataModel!.calculatedText = "x = \(x), \tsix(x) = \(actualsin_x)\n"
        plotDataModel!.calculatedText += "Point, \tsin(x), \tError\n"
        
        //Calculate Error of Zeroth Point
        if(actualsin_x != 0.0){
            var numerator = firstTerm - actualsin_x
            if(numerator == 0.0) { numerator = 1.0E-16 }
            zerothError = (log10(abs((numerator)/actualsin_x)))
            
        } else {
            zerothError = 0.0
        }
        
        //Print Zeroth Point
        plotDataModel!.calculatedText += "0.0, \t\(zerothTerm), \t\(zerothError)\n"
        plotDataModel!.zeroData()
        
        if !plotError  {
            //set the Plot Parameters
            plotDataModel!.changingPlotParameters.yMax = 1.5
            plotDataModel!.changingPlotParameters.yMin = -1.5
            plotDataModel!.changingPlotParameters.xMax = 15.0
            plotDataModel!.changingPlotParameters.xMin = -1.0
            plotDataModel!.changingPlotParameters.xLabel = "n"
            plotDataModel!.changingPlotParameters.yLabel = "sin(x)"
            plotDataModel!.changingPlotParameters.lineColor = .red()
            plotDataModel!.changingPlotParameters.title = "sin(x) vs n"
            
            // Plot first point of sin
            let dataPoint: plotDataType = [.X: 0.0, .Y: 0.0]
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
            plotDataModel!.changingPlotParameters.title = "Error sin(x) vs n"
                
            
            // Plot first point of error
            let dataPoint: plotDataType = [.X: 0.0, .Y: (zerothError)]
            plotDataModel!.appendData(dataPoint: [dataPoint])
        }
        // Calculate the infinite sum using the function that calculates the multiplier of the nth term in the series.
        
        sinX = calculate1DInfiniteSum(
            function: sinnthTermMultiplier,
            x: firstTerm, offset: zerothTerm, minimum: 1, maximum: 100,
            firstTerm: firstTerm, isPlotError: plotError,
            errorType: sinErrorCalculator  )
        
        return (sinX)
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
        } else { error = 0.0 }
        
        return (error)
        
    }

}
