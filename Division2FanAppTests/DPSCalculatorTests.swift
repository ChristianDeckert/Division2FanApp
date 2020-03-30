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

    override func setUpWithError() throws {
        try super.setUpWithError()
        subject = DpsCalculator()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        subject = nil
    }

    func testEliteNPCOutOfCover() throws {
        XCTAssertTrue(true)
    }

}
