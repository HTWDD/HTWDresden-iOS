//
//  EventDate_TestCase.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 05/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import XCTest
@testable import HTWDD

class EventDate_TestCase: XCTestCase {

    func test_init() throws {
        let raw = "2000-02-20"
        let date = try EventDate.value(from: raw)

        XCTAssertEqual(date.year, 2000)
        XCTAssertEqual(date.month, 2)
        XCTAssertEqual(date.day, 20)

        XCTAssertNil(try? EventDate.value(from: ""))
        XCTAssertNil(try? EventDate.value(from: "2000-13-10"))
        XCTAssertNil(try? EventDate.value(from: "2000-12-32"))
        XCTAssertNil(try? EventDate.value(from: "2000-0-12"))
        XCTAssertNil(try? EventDate.value(from: "2000-3-0"))
        XCTAssertNil(try? EventDate.value(from: "a-12-3"))
        XCTAssertNil(try? EventDate.value(from: "2000-a-3"))
        XCTAssertNil(try? EventDate.value(from: "2000-3-a"))
    }

}
