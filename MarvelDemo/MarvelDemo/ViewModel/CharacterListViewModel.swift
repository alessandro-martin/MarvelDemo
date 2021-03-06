//
//  CharacterListViewModel.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import Foundation

typealias CharactersProvider = (Int) -> AnyPublisher<CharacterDataContainer, AppError>

final class CharacterListViewModel {
    struct State: Equatable {
        enum Status: Equatable {
            case error(String)
            case initial
            case loading
            case withData
            
            var title: String {
                switch self {
                case let .error(message):
                    return message
                case .initial, .withData:
                    return "Marvel Characters"
                case .loading:
                    return "Loading..."
                }
            }
        }
        
        fileprivate var marvelCharacters: [MarvelCharacter] = []
        fileprivate(set) var status: Status = .initial
    }
    
    @Published private(set) var state = State()
    
    
    private let provider: CharactersProvider
    
    private var targetOffset = 0
    private var totalCharactersCount: Int?
    private var canFetchNextPage: Bool { totalCharactersCount.map { targetOffset < $0 } == true }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(provider: @escaping CharactersProvider = Provider.marvelCharactersList) {
        self.provider = provider
    }
    
    // MARK: - Public API
    var marvelCharactersCount: Int { state.marvelCharacters.count }
    
    func marvelCharacter(at index: Int) -> MarvelCharacter {
        state.marvelCharacters[index]
    }
    
    func fetchFirstPage() {
        fetchMarvelCharacters()
    }
    
    func fetchNextPageIfNeeded(for index: Int) {
        guard canFetchNextPage
            && state.status != .loading
            && index > max(0, marvelCharactersCount - 5) else { return }
        
        fetchMarvelCharacters()
    }
    
    // MARK: Private Methods
    private func fetchMarvelCharacters() {
        state.status = .loading
        provider(targetOffset)
            .sink(receiveCompletion: {  [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.state.status = .error(error.message)
                }
            }) { [weak self] characterData in
                guard let self = self else { return }
                
                self.targetOffset += Constants.pageSize
                self.totalCharactersCount = characterData.total

                self.state = State(
                    marvelCharacters: self.state.marvelCharacters + (characterData.results ?? []),
                    status: .withData
                )
        }
        .store(in: &cancellables)
    }
}
