//
//  Thumbnail.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Foundation

struct Thumbnail: Decodable, Equatable {
	let path: String?
	let `extension`: String?
    
    var url: URL? {
        guard let path = path,
            let `extension` = `extension` else { return nil }
        
        return URL(string: "\(path).\(`extension`)")
    }
}
