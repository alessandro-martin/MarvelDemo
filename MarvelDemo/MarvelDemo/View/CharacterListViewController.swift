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
        tableView.estimatedRowHeight = 100.0
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.register(MarvelCharacterCell.self, forCellReuseIdentifier: MarvelCharacterCell.reuseIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.pin(tableView, to: view)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                self.title = state.status.title
                print("--->", state)
                switch state.status {
                case .initial:
                    self.viewModel.fetchFirstPage()
                case .loading:
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
        
        let index = indexPath.row
        let marvelCharacter = viewModel.marvelCharacter(at: index)
        cell.configure(marvelCharacter: marvelCharacter)
        
        viewModel.fetchNextPageIfNeeded(for: index)
        
        return cell
    }
}

extension NSLayoutConstraint {
    static func pin(_ view: UIView, to superview: UIView, insets: NSDirectionalEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.leading),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.trailing),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    static func setSize(of view: UIView, to size: CGSize) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: size.width),
            view.heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
}
