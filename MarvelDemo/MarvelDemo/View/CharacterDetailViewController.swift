//
//  CharacterDetailViewController.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 22/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import Nuke
import UIKit

final class CharacterDetailViewController: UIViewController {
    private let viewModel: CharacterViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let characterImageView = UIImageView()
    private let comicsLabel = UILabel()
    private let eventsLabel = UILabel()
    private let seriesLabel = UILabel()
    private let storiesLabel = UILabel()
    
    init(viewModel: CharacterViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.state.title
        view.backgroundColor = .systemBackground
        
        setUpUI()
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                self.title = state.title
                
                switch state.status {
                case .initial, .loading:
                    break
                case .withData:
                    self.updateUI()
                }
        }.store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchCharacterInfo()
    }

    private func setUpUI() {
        view.addSubview(scrollView)
        NSLayoutConstraint.pin(scrollView, to: view)
        
        stackView.layoutMargins = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.spacing = 16.0
        scrollView.addSubview(stackView)
        NSLayoutConstraint.pin(stackView, to: scrollView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        descriptionLabel.numberOfLines = 0
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.addArrangedSubview(characterImageView)
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor)
        ])
        
        comicsLabel.numberOfLines = 0
        stackView.addArrangedSubview(comicsLabel)
        
        eventsLabel.numberOfLines = 0
        stackView.addArrangedSubview(eventsLabel)
        
        seriesLabel.numberOfLines = 0
        stackView.addArrangedSubview(seriesLabel)
        
        storiesLabel.numberOfLines = 0
        stackView.addArrangedSubview(storiesLabel)
    }
    
    private func updateUI() {
        descriptionLabel.text = viewModel.description
        if let imageURL = viewModel.imageURL {
            Nuke.loadImage(with: imageURL, into: characterImageView)
        } else {
            characterImageView.image = UIImage(systemName: "photo")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }
        comicsLabel.text = viewModel.comicsText
        eventsLabel.text = viewModel.eventsText
        seriesLabel.text = viewModel.seriesText
        storiesLabel.text = viewModel.storiesText
    }
}
