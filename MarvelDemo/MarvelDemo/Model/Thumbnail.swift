//
//  Thumbnail.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

struct Thumbnail : Codable {
	let path : String?
	let `extension` : String?

	enum CodingKeys: String, CodingKey {

		case path = "path"
		case `extension` = "extension"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		path = try values.decodeIfPresent(String.self, forKey: .path)
		`extension` = try values.decodeIfPresent(String.self, forKey: .extension)
	}

}
