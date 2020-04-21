//
//  MarvelCharacterCell.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import UIKit

final class MarvelCharacterCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)
    
    private let characterImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setUp() {
        
    }
    
    func configure(marvelCharacter: MarvelCharacter) {
        textLabel?.text = marvelCharacter.name
    }
}
