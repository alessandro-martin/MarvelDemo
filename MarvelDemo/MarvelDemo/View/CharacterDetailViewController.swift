//
//  CharacterDetailViewController.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 22/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import UIKit

final class CharacterDetailViewController: UIViewController {
    private let viewModel: CharacterViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CharacterViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.state.title
        view.backgroundColor = .systemBackground
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                self.title = state.title
                
                switch state.status {
                case .initial, .loading:
                    break
                case .withData:
                    break // UPDATE UI
                }
        }.store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchCharacterInfo()
    }
}
