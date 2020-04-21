//
//  Provider.swift
//  MarvelDemo
//
//  Created by Alessandro Martin on 21/04/2020.
//  Copyright © 2020 Alessandro Martin. All rights reserved.
//

import Combine
import CryptoKit
import Foundation

//https://gateway.marvel.com:443/v1/public/characters?offset=20&apikey=377559716b35b6d2d5b6c078b7219b37
//https://gateway.marvel.com:443/v1/public/characters?offset=00&apikey=377559716b35b6d2d5b6c078b7219b37
enum Provider {
    static func marvelCharactersList(offset: Int) -> AnyPublisher<Response, Never> {
        URLSession.shared.dataTaskPublisher(for: Provider.url(offset: offset))
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .replaceError(with: Response(code: nil, data: nil))
            .eraseToAnyPublisher()
    }
    
    private static func url(offset: Int) -> URL {
        let timestamp = String(Date().timeIntervalSince1970)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.port = 443
        components.path = "/v1/public/characters"
        components.queryItems = [
            .init(name: "offset", value: "\(offset)"),
            .init(name: "apikey", value: "377559716b35b6d2d5b6c078b7219b37"),
            .init(name: "hash", value: md5(timeStamp: timestamp)),
            .init(name: "ts", value: timestamp)
        ]
        
        return components.url!
    }
}

func md5(timeStamp: String) -> String {
    let digest = Insecure.MD5.hash(data: Data((timeStamp + "f324b49a0621abb813a9001ceb77f470ad9372a7" + "377559716b35b6d2d5b6c078b7219b37").utf8))
    
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
