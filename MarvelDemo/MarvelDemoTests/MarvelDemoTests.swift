//
//  MarvelDemoTests.swift
//  MarvelDemoTests
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import XCTest
@testable import MarvelDemo

final class MarvelDemoTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func testResponseIsWellFormed() {
        let sut = Utilities.responseFromJSON
        
        XCTAssertEqual(sut.code, 200)
        XCTAssertEqual(sut.data?.count, 20)
        XCTAssertEqual(sut.data?.limit, 20)
        XCTAssertEqual(sut.data?.offset, 0)
        XCTAssertEqual(sut.data?.results?.count, 20)
        XCTAssertEqual(sut.data?.total, 1493)
    }
}
