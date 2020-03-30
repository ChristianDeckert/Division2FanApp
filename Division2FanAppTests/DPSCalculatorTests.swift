//
//  Division2FanAppTests.swift
//  Division2FanAppTests
//
//  Created by Christian on 30.03.20.
//  Copyright © 2020 Christian Deckert. All rights reserved.
//

import XCTest

@testable import Division2FanApp

final class Division2FanAppTests: XCTestCase {

    var subject: DpsCalculator! 

    override func setUp() {
        super.setUp()
        subject = DpsCalculator()
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    func testEliteNPCOutOfCover() {
        XCTAssertTrue(true)
    }

}
