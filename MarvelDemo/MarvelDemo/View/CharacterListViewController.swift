//
//  CharacterListViewController.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import UIKit

final class CharacterListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let viewModel: CharacterListViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = MarvelCharacterCell.UI.estimatedCellHeight
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(MarvelCharacterCell.self, forCellReuseIdentifier: MarvelCharacterCell.reuseIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.pin(tableView, to: view)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                self.title = state.status.title

                switch state.status {
                case .initial:
                    self.viewModel.fetchFirstPage()
                case .loading, .error:
                    break
                case .withData:
                    self.tableView.reloadData()
                }
        }
        .store(in: &cancellables)
    }
}

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.marvelCharactersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarvelCharacterCell.reuseIdentifier, for: indexPath) as? MarvelCharacterCell else { fatalError("Unknown Cell Type") }
        
        cell.reset()
        
        let index = indexPath.row
        let marvelCharacter = viewModel.marvelCharacter(at: index)
        cell.configure(marvelCharacter: marvelCharacter)
        viewModel.fetchNextPageIfNeeded(for: index)
        
        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let characterId = viewModel.marvelCharacter(at: indexPath.row).id else { return }
        
        let detailVM = CharacterDetailViewModel(characterId: characterId)
        let detailVC = CharacterDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
