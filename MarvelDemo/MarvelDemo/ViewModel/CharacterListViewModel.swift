//
//  CharacterListViewModel.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import Foundation

enum Constants {
    static let pageSize = 20
}

typealias CharacterProvider = (Int) -> AnyPublisher<Response, Never>

final class CharacterListViewModel {
    struct State: Equatable {
        enum Status: Equatable {
            case initial
            case loading
            case withData
            
            var title: String {
                switch self {
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
    
    
    private let provider: CharacterProvider
    private var hasNextPage = false
    
    private var currentPage: Int { (state.marvelCharacters.count / Constants.pageSize) }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(provider: @escaping CharacterProvider) {
        self.provider = provider
    }
    
    // MARK: - Public API
    var marvelCharactersCount: Int { state.marvelCharacters.count }
    
    func marvelCharacter(at index: Int) -> MarvelCharacter {
        state.marvelCharacters[index]
    }
    
    func fetchFirstPage() {
        fetchMarvelCharacters(offset: 0)
    }
    
    func fetchNextPageIfNeeded(for index: Int) {
        guard hasNextPage
            && state.status != .loading
            && index > max(0, marvelCharactersCount - 5) else { return }
        
        fetchMarvelCharacters(offset: currentPage + 1)
    }
    
    // MARK: Private Methods
    private func fetchMarvelCharacters(offset: Int) {
        state.status = .loading
        provider(offset)
            .sink { [weak self] response in
                guard let self = self else { return }
                
                self.hasNextPage = (response.data?.total ?? 0) > (self.marvelCharactersCount + (response.data?.count ?? 0))
                self.state = State(
                    marvelCharacters: self.state.marvelCharacters + (response.data?.results ?? []),
                    status: .withData
                )
        }
        .store(in: &cancellables)
    }
}
