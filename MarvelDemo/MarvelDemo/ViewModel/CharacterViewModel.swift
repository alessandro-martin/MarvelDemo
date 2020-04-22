//
//  CharacterViewModel.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 22/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine

final class CharacterViewModel {
    struct State: Equatable {
        enum Status: Equatable {
            case initial
            case loading
            case withData
        }
        
        fileprivate var marvelCharacter: MarvelCharacter?
        fileprivate(set) var status: Status = .initial
        
        var title: String {
            switch status {
            case .withData:
                return marvelCharacter?.name ?? "Unknown"
            case .initial, .loading:
                return "Loading..."
            }
        }
    }
    
    @Published private(set) var state = State(marvelCharacter: nil, status: .initial)
    
    private let characterId: Int
    private let provider: CharactersProvider
    
    private var cancellables = Set<AnyCancellable>()
    
    init(characterId: Int, provider: @escaping CharactersProvider) {
        self.characterId = characterId
        self.provider = provider
    }
    
    func fetchCharacterInfo() {
        state.status = .loading
        provider(characterId)
            .sink { [weak self] response in
                guard let self = self else { return }
                
                self.state = State(
                    marvelCharacter: response.data?.results?.first,
                    status: .withData
                )
        }.store(in: &cancellables)
    }
}
