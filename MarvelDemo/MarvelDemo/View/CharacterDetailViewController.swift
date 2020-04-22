//
//  CharacterDetailViewController.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 22/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    private let viewModel: CharacterViewModel
    
    init(viewModel: CharacterViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        viewModel.fetchCharacterInfo()
    }
}

import Combine

final class CharacterViewModel {
    private(set) var marvelCharacter: MarvelCharacter?
    
    private let characterId: Int
    private let provider: CharactersProvider
    
    private var cancellables = Set<AnyCancellable>()
    
    init(characterId: Int, provider: @escaping CharactersProvider) {
        self.characterId = characterId
        self.provider = provider
        print("---> Character Id: \(characterId)")
    }
    
    func fetchCharacterInfo() {
        provider(characterId)
            .sink { [weak self] response in
                guard let self = self else { return }
                
                print("--->", response.data?.results?.first as Any)
                self.marvelCharacter = response.data?.results?.first
                
        }.store(in: &cancellables)
    }
}
