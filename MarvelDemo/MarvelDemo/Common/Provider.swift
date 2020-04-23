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

enum AppError: Error {
    case characterNotFound
    case generic(Error)
    case networkError
    case serverError(code: Int, message: String)
    
    var message: String {
        switch self {
        case .characterNotFound:
            return "Character not Found"
        case let .generic(error):
            return error.localizedDescription
        case .networkError:
            return "Network Error"
        case let .serverError(code, message):
            return "Error \(code): \(message)"
        }
    }
}

enum Provider {
    static func marvelCharactersList(offset: Int) -> AnyPublisher<CharacterDataContainer, AppError> {
        Self.characterDataContainer(url: Provider.charactersListUrl(offset: offset))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func characterDetails(characterId: Int) -> AnyPublisher<MarvelCharacter, AppError> {
        Self.characterDataContainer(url: Provider.characterDetailsUrl(characterId: characterId))
            .tryMap { container in
                guard let character = container.results?.first else { throw AppError.characterNotFound }
                
                return character
            }
            .mapError { error in
                if let error = error as? AppError {
                    return error
                } else {
                    return .generic(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private static func characterDataContainer(url: URL) -> AnyPublisher<CharacterDataContainer, AppError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, urlResponse  in
                if let urlResponse = urlResponse as? HTTPURLResponse,
                    urlResponse.statusCode != 200 {
                    throw AppError.networkError
                } else if let response = try? JSONDecoder().decode(Response.self, from: data) {
                    if let characterDataContainer = response.data {
                        return characterDataContainer
                    } else if let code = response.code,
                        let status = response.status {
                        throw AppError.serverError(code: code, message: status)
                    } else {
                        throw AppError.networkError
                    }
                } else {
                    throw AppError.networkError
                }
        }
        .mapError { error in
            if let error = error as? AppError {
                return error
            } else {
                return .generic(error)
            }
        }
        .eraseToAnyPublisher()
    }
    
    private static func charactersListUrl(offset: Int) -> URL {
        let timestamp = String(Date().timeIntervalSince1970)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.port = 443
        components.path = "/v1/public/characters"
        components.queryItems = [
            .init(name: "offset", value: "\(offset)"),
            .init(name: "apikey", value: Constants.publicKey),
            .init(name: "hash", value: Provider.hash(timeStamp: timestamp)),
            .init(name: "ts", value: timestamp)
        ]
        
        return components.url!
    }
    
    private static func characterDetailsUrl(characterId: Int) -> URL {
        let timestamp = String(Date().timeIntervalSince1970)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.port = 443
        components.path = "/v1/public/characters/\(characterId)"
        components.queryItems = [
            .init(name: "apikey", value: Constants.publicKey),
            .init(name: "hash", value: Provider.hash(timeStamp: timestamp)),
            .init(name: "ts", value: timestamp)
        ]
        
        return components.url!
    }
    
    private static func hash(timeStamp: String) -> String {
        Insecure.MD5
            .hash(data: Data((timeStamp + Constants.privateKey + Constants.publicKey).utf8))
            .reduce(into: "") { $0 += String(format: "%02hhx", $1) }
    }
}
