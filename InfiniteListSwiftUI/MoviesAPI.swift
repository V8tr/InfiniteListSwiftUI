//
//  MoviesAPI.swift
//  InfiniteListSwiftUI
//
//  Created by Vadim Bulavin on 6/10/20.
//  Copyright © 2020 Vadim Bulavin. All rights reserved.
//

import Foundation
import Combine

enum MoviesAPI {
    static let imageBase = URL(string: "https://image.tmdb.org/t/p/original/")!
    private static let apiKey = "efb6cac7ab6a05e4522f6b4d1ad0fa43"
    
    static func trending(page: Int) -> AnyPublisher<Page<Movie>, Error> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(MoviesAPI.apiKey)&sort_by=release_date.desc&page=\(page)")!
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveOutput: { print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!) })
            .decode(type: Page<Movie>.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    
    var poster: URL? { posterPath.map { MoviesAPI.imageBase.appendingPathComponent($0) } }
}

struct Page<T: Codable>: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [T]
}
