//
//  CharacterViewModel.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 22/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import Foundation

typealias CharacterDetailsProvider = (Int) -> AnyPublisher<MarvelCharacter?, Never>

final class CharacterViewModel {
    struct State: Equatable {
        enum Status: Equatable {
            case initial
            case loading
            case withData
        }
        
        fileprivate(set) var marvelCharacter: MarvelCharacter?
        fileprivate(set) var status: Status = .initial
        
        var title: String {
            switch status {
            case .withData:
                return marvelCharacter?.name ?? "Unknown Name"
            case .initial, .loading:
                return "Loading..."
            }
        }
    }
    
    @Published private(set) var state = State(marvelCharacter: nil, status: .initial)
    
    private let characterId: Int
    private let provider: CharacterDetailsProvider
    
    private var cancellables = Set<AnyCancellable>()
    
    init(characterId: Int, provider: @escaping CharacterDetailsProvider) {
        self.characterId = characterId
        self.provider = provider
    }
    
    var description: String {
        state.marvelCharacter?.description ?? "No Description Available"
    }
    
    var imageURL: URL? {
        state.marvelCharacter?.thumbnail?.url
    }
    
    var comicsText: String {
        switch state.marvelCharacter?.comics?.available {
        case let .some(comics):
            return "This character is featured in \(comics) comics"
        case .none:
            return "This character is not featured in any comic"
        }
    }
    
    var eventsText: String {
        switch state.marvelCharacter?.events?.available {
        case let .some(events):
            return "This character has \(events) upcoming events"
        case .none:
            return "This character has no upcoming events"
        }
    }
    
    var seriesText: String {
        switch state.marvelCharacter?.series?.available {
        case let .some(series):
            return "This character is a part of \(series) series"
        case .none:
            return "This character is not part of any series"
        }
    }
    
    var storiesText: String {
        switch state.marvelCharacter?.stories?.available {
        case let .some(stories):
            return "This character appears in \(stories) stories"
        case .none:
            return "This character does not appear in any stories"
        }
    }
    
    func fetchCharacterInfo() {
        state.status = .loading
        provider(characterId)
            .sink { [weak self] character in
                guard let self = self else { return }
                
                self.state = State(
                    marvelCharacter: character,
                    status: .withData
                )
        }.store(in: &cancellables)
    }
}
