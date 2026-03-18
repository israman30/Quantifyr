//
//  QuantifyrTests.swift
//  QuantifyrTests
//
//  Created by Israel Manzo on 3/13/26.
//

import XCTest
@testable import Quantifyr

final class QuantifyrTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScientificCalculatorBasic() throws {
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "3 + 4 * 2"), 11)
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "(5 + 3)^2"), 64)
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "10 / 2"), 5)
    }
    
    func testScientificCalculatorFunctions() throws {
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "sin(0)"), 0, accuracy: 1e-10)
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "sin(pi/2)"), 1, accuracy: 1e-10)
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "log(100)"), 2, accuracy: 1e-10)
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "sqrt(16)"), 4, accuracy: 1e-10)
    }
    
    func testScientificCalculatorWithVariable() throws {
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "x^2", x: 3), 9, accuracy: 1e-10)
        XCTAssertEqual(ScientificCalculator.evaluate(expression: "2*x+1", x: 5), 11, accuracy: 1e-10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
