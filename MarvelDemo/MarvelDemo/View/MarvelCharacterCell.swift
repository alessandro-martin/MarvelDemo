//
//  MarvelCharacterCell.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Nuke
import UIKit

final class MarvelCharacterCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)
    
    private let characterImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setUp() {
        let stackView = UIStackView()
        stackView.spacing = 16.0
        stackView.alignment = .center
        contentView.addSubview(stackView)
        NSLayoutConstraint.pin(stackView, to: contentView, insets: NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
        
        stackView.addArrangedSubview(characterImageView)
        NSLayoutConstraint.setSize(of: characterImageView, to: CGSize(width: 120.0, height: 120.0))
        
        nameLabel.numberOfLines = 0
        nameLabel.font = .preferredFont(forTextStyle: .body)
        stackView.addArrangedSubview(nameLabel)
    }
    
    func configure(marvelCharacter: MarvelCharacter) {
        nameLabel.text = marvelCharacter.name
        
        if let imageURL = marvelCharacter.thumbnail?.url {
            Nuke.loadImage(with: imageURL, into: characterImageView)
        } else {
            characterImageView.image = UIImage(systemName: "photo")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }
    }
    
    func reset() {
        Nuke.cancelRequest(for: characterImageView)
        nameLabel.text = nil
        characterImageView.image = nil
    }
}
