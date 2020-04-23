//
//  Response.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

struct Response: Decodable {
	let code: Int?
    let status: String?
	let data: CharacterDataContainer?
}
