//
//  Movie.swift
//  SwiftUI_MVVM
//
//  Created by Sam Kerridge on 12/10/21.
//

import Foundation

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let poster_path: String?
    
    var poster: URL?
}
