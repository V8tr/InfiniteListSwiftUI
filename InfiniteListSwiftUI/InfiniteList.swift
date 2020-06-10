//
//  InfiniteList.swift
//  InfiniteListSwiftUI
//
//  Created by Vadim Bulavin on 6/10/20.
//  Copyright © 2020 Vadim Bulavin. All rights reserved.
//

import SwiftUI

struct InfiniteList<Indicator: View>: View {
    let loadNextPage: () -> Void
    let loadingIndicator: Indicator
    
    var body: some View {
        EmptyView()
    }
}

struct InfiniteList_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteList(loadNextPage: {}, loadingIndicator: EmptyView())
    }
}
