//
//  CharacterDetailViewModelTests.swift
//  MarvelDemoTests
//
//  Created by Alessandro Martin on 23/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import XCTest
@testable import MarvelDemo

final class CharacterDetailViewModelTests: XCTestCase {
    func testSuccessfulFetchPopulatesDataCorrectly() {
        let provider: CharacterDetailsProvider = { _ in
            Result.success(Utilities.responseFromJSON.data!.results![0]).publisher.eraseToAnyPublisher()
        }
        let sut = CharacterDetailViewModel(characterId: 42, provider: provider)
        
        sut.fetchCharacterInfo()
        
        XCTAssertEqual(sut.state.status, .withData)
        XCTAssertEqual(sut.comicsText, "This character is featured in 12 comics")
        XCTAssertEqual(sut.description, "No Description Available")
        XCTAssertEqual(sut.eventsText, "This character has 1 upcoming events")
        XCTAssertEqual(sut.imageURL?.absoluteString, "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")
        XCTAssertEqual(sut.seriesText, "This character is a part of 3 series")
        XCTAssertEqual(sut.storiesText, "This character appears in 21 stories")
        XCTAssertEqual(sut.state.title, "3-D Man")
    }
    
    func testFetchErrorResultsInCorrectTitle() {
        let provider: CharacterDetailsProvider = { _ in
            Result.failure(.characterNotFound).publisher.eraseToAnyPublisher()
        }
        
        let sut = CharacterDetailViewModel(characterId: 42, provider: provider)
        
        sut.fetchCharacterInfo()
        
        XCTAssertEqual(sut.state.title, "Character not Found")
    }
}
