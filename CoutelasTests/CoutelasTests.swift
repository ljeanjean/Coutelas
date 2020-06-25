//
//  CoutelasTests.swift
//  CoutelasTests
//
//  Created by Laurent on 24/06/2020.
//  Copyright © 2020 ljeanjean. All rights reserved.
//

import XCTest
@testable import Coutelas

private class TestContainer {
    @Inject var injected: TestClassProtocol
}

private class TestContainerWithContext {
    @Inject(context: "Rahan") var injected: TestClassProtocol
}

class CoutelasTests: XCTestCase {
    var coutelas = Coutelas()
    
    override func setUpWithError() throws {
        coutelas = Coutelas()
    }

    override func tearDownWithError() throws {
    }

    func testRetreiveWithInstance() throws {
        coutelas.load { TestClassImpA() as TestClassProtocol }
        
        XCTAssert(coutelas.retrieve(TestClassProtocol.self) is TestClassImpA)
    }
    
    func testRetreiveContextWithInstance() throws {
        coutelas.load("Rahan") { TestClassImpA() as TestClassProtocol }
        
        XCTAssert(coutelas.retrieve(TestClassProtocol.self, "Rahan") is TestClassImpA)
    }
    
    func testRetreiveWithoutInstance() throws {
        XCTAssertNil(coutelas.retrieve(TestClassProtocol.self))
    }
    
    func testRetreiveContextWithoutInstance() throws {
        XCTAssertNil(coutelas.retrieve(TestClassProtocol.self, "Rahan"))
    }
}
