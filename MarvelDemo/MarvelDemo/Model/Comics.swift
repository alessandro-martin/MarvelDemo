//
//  Comics.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

struct Comics : Codable {
	let available : Int?
	let collectionURI : String?
	let items : [Items]?
	let returned : Int?

	enum CodingKeys: String, CodingKey {

		case available = "available"
		case collectionURI = "collectionURI"
		case items = "items"
		case returned = "returned"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		available = try values.decodeIfPresent(Int.self, forKey: .available)
		collectionURI = try values.decodeIfPresent(String.self, forKey: .collectionURI)
		items = try values.decodeIfPresent([Items].self, forKey: .items)
		returned = try values.decodeIfPresent(Int.self, forKey: .returned)
	}

}
