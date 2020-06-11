//
//  GithubAPI.swift
//  InfiniteListSwiftUI
//
//  Created by Vadim Bulavin on 6/11/20.
//  Copyright © 2020 Vadim Bulavin. All rights reserved.
//

import Foundation
import Combine

enum GithubAPI {
    static func searchRepos(query: String, page: Int) -> AnyPublisher<[Repository], Error> {
        let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&sort=stars&per_page=10&page=\(page)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveOutput: {
                print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!)
            })
            .decode(type: GithubSearchResult<Repository>.self, decoder: JSONDecoder())
            .map(\.items)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct GithubSearchResult<T: Codable>: Codable {
    let items: [T]
}

struct Repository: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
}
