//
//  SwiftUI_MVVMApp.swift
//  SwiftUI_MVVM
//
//  Created by Sam Kerridge on 28/09/21.
//

import SwiftUI

@main
struct SwiftUI_MVVMApp: App {
    var body: some Scene {
        WindowGroup {
            MoviesListView(viewModel: MoviesListViewModel())
        }
    }
}
