//
//  Utilities.swift
//  MarvelDemoTests
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Foundation
@testable import MarvelDemo

// This is a class because we need to access the bundle
final class Utilities: NSObject {
    static var responseFromJSON: Response {
        Bundle(for: Utilities.self)
            .url(forResource: "response", withExtension: "json")
            .map { try! Data(contentsOf: $0) }
            .map { try! JSONDecoder().decode(Response.self, from: $0) }!
    }
}
