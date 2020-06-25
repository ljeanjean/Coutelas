//
//  TestableClasses.swift
//  CoutelasTests
//
//  Created by Laurent on 24/06/2020.
//  Copyright © 2020 ljeanjean. All rights reserved.
//

import Foundation

protocol TestClassProtocol {
    var id: UUID { get }
}

class TestClassImpA: TestClassProtocol {
    var id = UUID()
}

class TestClassImpB: TestClassProtocol {
    var id = UUID()
}
