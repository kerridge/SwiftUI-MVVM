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
//    let genres: [GenreDTO]
    
    var poster: URL? { poster_path.map { MoviesAPI.imageBase.appendingPathComponent($0) } }
    
//    struct GenreDTO: Codable {
//        let id: Int
//        let name: String
//    }
}
