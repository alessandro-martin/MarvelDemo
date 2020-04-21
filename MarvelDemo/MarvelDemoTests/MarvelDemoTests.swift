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

    func testResponseIsWellFormed() {
        let sut = Utilities.responseFromJSON
        
        XCTAssertEqual(sut.code, 200)
        XCTAssertEqual(sut.data?.count, 20)
        XCTAssertEqual(sut.data?.limit, 20)
        XCTAssertEqual(sut.data?.offset, 0)
        XCTAssertEqual(sut.data?.results?.count, 20)
        XCTAssertEqual(sut.data?.total, 1493)
    }
    
    func testMarvelCharacterFromCollectionResponseIsWellFormed() {
        let sut = Utilities.responseFromJSON.data!.results![0]
        
        XCTAssertEqual(sut.id, 1011334)
        XCTAssertEqual(sut.name, "3-D Man")
        XCTAssertEqual(sut.description, "")
        XCTAssertEqual(sut.comics?.available, 12)
        XCTAssertEqual(sut.events?.available, 1)
        XCTAssertEqual(sut.series?.available, 3)
        XCTAssertEqual(sut.stories?.available, 21)
        XCTAssertEqual(sut.thumbnail?.url?.absoluteString, "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")
    }
}
