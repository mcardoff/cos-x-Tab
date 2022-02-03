//
//  cos_X_Calculator.swift
//  cos(x)
//
//  Created by Jeff Terry on 12/29/20.
//

import Foundation
import SwiftUI
import CorePlot

class Cos_X_Calculator: Calculator {
    
    /// calculate_cos_x
    /// - Parameter x: values of x in cos(x)
    /// - Returns: cos(x)
    /// This function limits the range of x to the first period of -π to π
    /// It calculates the value of the cosine using a Taylor Series Expansion of cos(x) - 1 and then adds 1
    ///
    ///                   oo                   2n
    ///                   __            n    x
    ///    cos (x)  =    \        ( - 1)   ------
    ///                  /__               (2n)!
    ///                  n = 0
    ///
    func calculate_cos_x(x: Double) -> Double{
        
        var cosXminusOne = 0.0
        var xInRange = clipToRange(x: x)
        var cosX = 0.0
        
        cosXminusOne = calculate_cos_xMinus1(x: xInRange)
        
        cosX = cosXminusOne + 1.0
        print(cosX)
        
        return (cosX)
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
        
        cosXminusOne = calculate1DInfiniteSum(function: cosnthTermMultiplier, x: x, offset: 1.0, minimum: 1, maximum: 100, firstTerm: firstTerm, isPlotError: plotError, errorType: cosErrorCalculator  )
        
        return (cosXminusOne)
    }
    
    /// cosnthTermMultiplier
    /// - Parameter parameters: Tuple containing the value of x and n
    /// - Returns: nth term multiplier (first term on the right side of the equation below)
    ///
    //                               2
    //      th                     x                     th
    //    n   term  =    ( - 1)  ---------    *   (n - 1)    term
    //                           2n * (2n-1)
    //
    ///
    func cosnthTermMultiplier(parameters: [nthTermParameterTuple])-> Double{
        
        var nthTermMultiplier = 0.0
        let n = Double(parameters[0].n)
        let x = parameters[0].x
        
        let denominator = 2.0 * n * (2.0 * n - 1)
        
        nthTermMultiplier =  -1.0 / (denominator) * (x↑2.0)
        
        return (nthTermMultiplier)
        
    }
    
    func cosErrorCalculator(parameters: [ErrorParameterTuple])-> Double{
        
        var error = 0.0
        _ = Double(parameters[0].n)
        let x = parameters[0].x
        let sum = parameters[0].sum + 1.0
        
        let actualcos_x = cos(x)
        
        if(actualcos_x != 0.0){
            
            var numerator = sum - actualcos_x
            
            if(numerator == 0.0) {numerator = sum.ulp}
            
            error = (log10(abs((numerator)/actualcos_x)))
            
            
        }
        else {
            error = 0.0
        }
        
        return (error)
        
    }

}
