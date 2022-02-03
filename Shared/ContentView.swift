//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Terry on 1/23/21.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @EnvironmentObject var plotDataModel :PlotDataClass
    @ObservedObject private var cosCalculator = Cos_X_Calculator()
    @ObservedObject private var sinCalculator = Sin_X_Calculator()
    @State var xInput: String = "\(Double.pi/2.0)"
    @State var cosOutput: String = "0.0"
    @State var computerCos: String = "\(cos(Double.pi/2.0))"
    @State var sinOutput: String = "0.0"
    @State var computerSin: String = "\(sin(Double.pi/2.0))"
    @State var errorCos: String = "0.0"
    @State var errorSin: String = "0.0"
    @State var isChecked:Bool = false

    var body: some View {
        
        VStack{
      
            CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
            
            Divider()
            
            HStack{
                
                HStack(alignment: .center) {
                    Text("x:")
                        .font(.callout)
                        .bold()
                    TextField("xValue", text: $xInput)
                        .padding()
                }.padding()
                VStack {
                    HStack(alignment: .center) {
                        Text("cos(x):")
                            .font(.callout)
                            .bold()
                        TextField("cos(x)", text: $cosOutput)
                            .padding()
                    }
                    
                    HStack(alignment: .center) {
                        Text("sin(x):")
                            .font(.callout)
                            .bold()
                        TextField("sin(x)", text: $sinOutput)
                            .padding()
                    }
                }
                    Toggle(isOn: $isChecked) {
                        Text("Display Error")
                    }
                    .padding()
                    

            }
            
            HStack{
                VStack {
                    HStack(alignment: .center) {
                        Text("Expected Cos:")
                            .font(.callout)
                            .bold()
                        TextField("Expected:", text: $computerCos)
                            .padding()
                    }
                    
                    HStack(alignment: .center) {
                        Text("Expected Sin:")
                            .font(.callout)
                            .bold()
                        TextField("Expected:", text: $computerSin)
                            .padding()
                    }
                }
                VStack {
                    HStack(alignment: .center) {
                        Text("Error Cos:")
                            .font(.callout)
                            .bold()
                        TextField("Error", text: $errorCos)
                            .padding()
                    }
                    
                    HStack(alignment: .center) {
                        Text("Error Sin:")
                            .font(.callout)
                            .bold()
                        TextField("Error", text: $errorSin)
                            .padding()
                    }
                }
                
            }
            
            
            HStack{
                Button("Calculate Both", action: {self.calculateBoth()} )
                .padding()
            }
        }
    }
    
    func calculateBoth() {
        calculateCos_X()
        calculateSin_X()
    }
    
    
    /// calculateCos_X
    /// Function accepts the command to start the calculation from the GUI
    func calculateCos_X(){
        
        let x = Double(xInput)
        xInput = "\(x!)"
        
        var cos_x = 0.0
        let actualcos_x = cos(x!)
        var errorCalc = 0.0
        
        //pass the plotDataModel to the cosCalculator
        cosCalculator.plotDataModel = self.plotDataModel
        
        //tell the cosCalculator to plot Data or Error
        cosCalculator.plotError = self.isChecked
        
        
        //Calculate the new plotting data and place in the plotDataModel
        cos_x = cosCalculator.calculate_cos_x(x: x!)
        

        print("The cos(\(x!)) = \(cos_x)")
        print("computer calcuates \(actualcos_x)")
        
        cosOutput = "\(cos_x)"
        
        computerCos = "\(actualcos_x)"
        
        if(actualcos_x != 0.0){
            
            var numerator = cos_x - actualcos_x
            
            if(numerator == 0.0) {numerator = 1.0E-16}
            
            errorCalc = log10(abs((numerator)/actualcos_x))
            
        }
        else {
            errorCalc = 0.0
        }
        
        errorCos = "\(errorCalc)"
        
    }
    
    /// calculateSin_X
    /// Function accepts the command to start the calculation from the GUI
    func calculateSin_X(){
        
        let x = Double(xInput)
        xInput = "\(x!)"
        
        var sin_x = 0.0
        let actualsin_x = sin(x!)
        var errorCalc = 0.0
        
        //pass the plotDataModel to the cosCalculator
        sinCalculator.plotDataModel = self.plotDataModel
        
        //tell the cosCalculator to plot Data or Error
        sinCalculator.plotError = self.isChecked
        
        
        //Calculate the new plotting data and place in the plotDataModel
        sin_x = sinCalculator.calculate_sin_x(x: x!)
        

        print("The cos(\(x!)) = \(sin_x)")
        print("computer calcuates \(actualsin_x)")
        
        sinOutput = "\(sin_x)"
        
        computerSin = "\(actualsin_x)"
        
        if(actualsin_x != 0.0){
            var numerator = sin_x - actualsin_x
            if(numerator == 0.0) {numerator = 1.0E-16}
            errorCalc = log10(abs((numerator)/actualsin_x))
        } else {
            errorCalc = 0.0
        }
        errorSin = "\(errorCalc)"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
