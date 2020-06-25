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

class CoutelasStaticTests: XCTestCase {
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        Coutelas.unloadAll()
    }

    func testInjectedClassMethod() throws {
        Coutelas.load { TestClassImpA() as TestClassProtocol }
        
        let testContainer = TestContainer()
        XCTAssert(testContainer.injected is TestClassImpA)
    }
    
    func testInjectedClassMethodAfterTwoLoading() throws {
        Coutelas.load { TestClassImpA() as TestClassProtocol }
        Coutelas.load { TestClassImpB() as TestClassProtocol }
        
        let testContainer = TestContainer()
        XCTAssert(testContainer.injected is TestClassImpB)
    }
    
    func testInjectedClassMethodWithContext() throws {
        Coutelas.load("Rahan") { TestClassImpA() as TestClassProtocol }
        
        let testContainer = TestContainerWithContext()
        XCTAssert(testContainer.injected is TestClassImpA)
    }
    
    func testInjectedClassMethodAfterTwoLoadingWithContext() throws {
        Coutelas.load("Rahan") { TestClassImpA() as TestClassProtocol }
        Coutelas.load("Rahan") { TestClassImpB() as TestClassProtocol }
        
        let testContainer = TestContainerWithContext()
        XCTAssert(testContainer.injected is TestClassImpB)
    }
    
}
