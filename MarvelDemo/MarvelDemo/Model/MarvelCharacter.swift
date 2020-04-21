//
//  MarvelCharacter.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

struct MarvelCharacter: Decodable {
	let id: Int?
	let name: String?
	let description: String?
	let thumbnail: Thumbnail?
	let comics: Item?
	let series: Item?
	let stories: Item?
	let events: Item?
}
