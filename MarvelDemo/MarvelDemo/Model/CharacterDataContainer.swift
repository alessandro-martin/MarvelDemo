//
//  CharacterDataContainer.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

struct CharacterDataContainer: Decodable {
	let offset: Int?
	let limit: Int?
	let total: Int?
	let count: Int?
	let results: [MarvelCharacter]?
}
