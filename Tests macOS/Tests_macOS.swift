//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Jeff Terry on 1/23/21.
//

import XCTest

class Tests_macOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOperators() throws {
        
        let exponent = 5.2↑2.0
        
        XCTAssertEqual(exponent, pow(5.2,2.0), accuracy: 1E-15)
        
        let factorial = 5❗️
        
        XCTAssertEqual(factorial, (1*2*3*4*5))
        
        let factorialDouble = 5.0❗️
        
        XCTAssertEqual(factorialDouble, (1.0*2.0*3.0*4.0*5.0), accuracy: 1E-15)
        
        let trickyFactorial = Double.pi❗️
        
        XCTAssertEqual(trickyFactorial, (7.1880827289760327021), accuracy: 5E-15)
        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCos() throws {
        
        let plotDataModel = PlotDataClass(fromLine: true)
        
        let cosCalculate = Cos_X_Calculator()
        
        cosCalculate.plotDataModel = plotDataModel
        
        let cos45 = cosCalculate.calculate_cos_x(x: 45.0*Double.pi/180.0)
        
        XCTAssertEqual(cos45, cos(45.0*Double.pi/180.0), accuracy: 5E-15)
        
        let cosPlus2Pi = cosCalculate.calculate_cos_x(x: (45.0*Double.pi/180.0)+2.0*Double.pi)
        
        XCTAssertEqual(cosPlus2Pi, cos(45.0*Double.pi/180.0), accuracy: 5E-15)
        
        let cosMinus2Pi = cosCalculate.calculate_cos_x(x: (45.0*Double.pi/180.0)-2.0*Double.pi)
        
        XCTAssertEqual(cosMinus2Pi, cos(45.0*Double.pi/180.0), accuracy: 5E-15)
        
        
    }
    
    func testSin() throws {
        
        let plotDataModel = PlotDataClass(fromLine: true)
        
        let sinCalculate = Sin_X_Calculator()
        
        sinCalculate.plotDataModel = plotDataModel
        
        let sin45 = sinCalculate.calculate_sin_x(x: 45.0*Double.pi/180.0)
        
        XCTAssertEqual(sin45, sin(45.0*Double.pi/180.0), accuracy: 5E-15)
        
        let sinPlus2Pi = sinCalculate.calculate_sin_x(x: (45.0*Double.pi/180.0)+2.0*Double.pi)
        
        XCTAssertEqual(sinPlus2Pi, cos(45.0*Double.pi/180.0), accuracy: 5E-15)
        
        let sinMinus2Pi = sinCalculate.calculate_sin_x(x: (45.0*Double.pi/180.0)-2.0*Double.pi)
        
        XCTAssertEqual(sinMinus2Pi, cos(45.0*Double.pi/180.0), accuracy: 5E-15)
        
        
}
    
    func testNextTerm() throws {
        
        let plotDataModel = PlotDataClass(fromLine: true)
        
        let cosCalculate = Cos_X_Calculator()
        
        cosCalculate.plotDataModel = plotDataModel
        
        let nextTermTuple : nthTermParameterTuple = (n: 3, x: (45.0*Double.pi/180.0))
        
        let nextTerm = cosCalculate.cosnthTermMultiplier(parameters: [nextTermTuple])
        
        XCTAssertEqual(nextTerm, (-0.0003259918869273900136414318317506306623220545546064746825972073/0.0158543442438155008522852103985522642008020158972469761867623469), accuracy: 5E-15)
        
        
        
}
    
    func testError() throws {
        
        let plotDataModel = PlotDataClass(fromLine: true)
        
        let cosCalculate = Cos_X_Calculator()
        
        cosCalculate.plotDataModel = plotDataModel
        
        let errorTuple : ErrorParameterTuple = (n: 3, x: (45.0*Double.pi/180.0), sum: (0.7071032148228457-1.0))
        
        let error = cosCalculate.cosErrorCalculator(parameters: [errorTuple])
        
        XCTAssertEqual(error, (-5.297259371214497), accuracy: 5E-15)
        
        
        
}
    
    /// test1DSum
    /// Test the 1D Sum code with something other than the cos(x)
    /// This tests with an infinite sum of the following type:
    ///
    //     oo
    //     __         k        1
    //    \         x     =  -----   when |x|<1
    //    /__                1 - x
    //    k = 0
    ///
    func test1DSum() throws {
        
        let plotDataModel = PlotDataClass(fromLine: true)
        
        let cosCalculate = Cos_X_Calculator()
        
        cosCalculate.plotDataModel = plotDataModel
        
        let sum = cosCalculate.calculate1DInfiniteSum(function: infiniteSumTestMultiplier, x: 0.5, offset: 0.0, minimum: 1, maximum: 50, firstTerm: 1.0, isPlotError: false, errorType: cosCalculate.cosErrorCalculator )
        
        XCTAssertEqual(sum, (2.0), accuracy: 5E-15)
        
        let sum2 = cosCalculate.calculate1DInfiniteSum(function: infiniteSumTestMultiplier, x: 0.75, offset: 0.0, minimum: 1, maximum: 200, firstTerm: 1.0, isPlotError: false, errorType: cosCalculate.cosErrorCalculator )
        
        XCTAssertEqual(sum2, (4.0), accuracy: 5E-15)
        
}
    
    
    /// infiniteSumTestMultiplier
    /// - Parameter parameters: Tuple containing the value of x and n
    /// - Returns: nthTermMultiplier
    //
    ///
    //     oo
    //     __         k        1
    //    \         x     =  -----   when |x|<1
    //    /__                1 - x
    //    k = 0
    ///
    //
    //      th                           th
    //    n   term  =    x    *   (n - 1)    term
    //
    func infiniteSumTestMultiplier(parameters: [nthTermParameterTuple])-> Double{
        
        var nthTermMultiplier = 0.0
        let _ = Double(parameters[0].n)
        let x = parameters[0].x
        
        let numerator =  x
        
        nthTermMultiplier =  numerator
        
        return (nthTermMultiplier)
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
