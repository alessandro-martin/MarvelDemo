//
//  CharacterListViewModelTests.swift
//  MarvelDemoTests
//
//  Created by Alessandro Martin on 23/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import XCTest
@testable import MarvelDemo

final class CharacterListViewModelTests: XCTestCase {
    let mockProvider: CharactersProvider = { _ in
        Result.success(Utilities.responseFromJSON.data!).publisher.eraseToAnyPublisher()
    }
    
    func testFetchingFirstPageYieldsCorrectNumberOfCharacters() {
        let sut = CharacterListViewModel(provider: mockProvider)
        
        sut.fetchFirstPage()
        
        XCTAssertEqual(sut.marvelCharactersCount, 20)
        XCTAssertEqual(sut.state.status, .withData)
    }
    
    func testFetchingFirstAndNextPageTowardsTheEndOfFirstPageYieldsCorrectNumberOfCharacters() {
        let sut = CharacterListViewModel(provider: mockProvider)
        
        sut.fetchFirstPage()
        sut.fetchNextPageIfNeeded(for: 18)
        
        XCTAssertEqual(sut.marvelCharactersCount, 40)
        XCTAssertEqual(sut.state.status, .withData)
    }
    
    func testFetchingFirstAndNextPageTowardsTheBeginningOfFirstPageYieldsCorrectNumberOfCharacters() {
        let sut = CharacterListViewModel(provider: mockProvider)
        
        sut.fetchFirstPage()
        sut.fetchNextPageIfNeeded(for: 8)
        
        XCTAssertEqual(sut.marvelCharactersCount, 20)
        XCTAssertEqual(sut.state.status, .withData)
    }
}
