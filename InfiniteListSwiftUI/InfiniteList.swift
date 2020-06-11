//
//  InfiniteList.swift
//  InfiniteListSwiftUI
//
//  Created by Vadim Bulavin on 6/10/20.
//  Copyright © 2020 Vadim Bulavin. All rights reserved.
//

import SwiftUI
import Combine

struct InfiniteListContainer: View {
    @State private var page = 1
    @State private var repos: [Repository] = []
    @State private var subscription: AnyCancellable?
    
    var body: some View {
        InfiniteList(
            repos: repos,
            onScrolledAtBottom: fetch
        )
        .onAppear(perform: fetch)
        .onDisappear(perform: cancel)
    }
    
    private func fetch() {
        page += 1
        subscription = GithubAPI.searchRepos(query: "swift", page: page)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { batch in self.repos += batch })
    }
    
    private func cancel() {
        subscription?.cancel()
    }
}

struct InfiniteList: View {
    let repos: [Repository]
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            ForEach(repos) { repo in
                RepositoryRow(repo: repo).onAppear {
                    if self.repos.last == repo {
                        self.onScrolledAtBottom()
                    }
                }
            }
            
            loadingIndicator
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct RepositoryRow: View {
    let repo: Repository
    
    var body: some View {
        VStack {
            Text(repo.name).font(.title)
            Text("⭐️ \(repo.stargazers_count)")
            repo.description.map(Text.init)?.font(.body)
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}
