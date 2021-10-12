//
//  MovieDetail.swift
//  SwiftUI_MVVM
//
//  Created by Sam Kerridge on 12/10/21.
//

import Foundation

struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let vote_average: Double?
    let genres: [GenreDTO]
    let release_date: String?
    let runtime: Int?
    let spoken_languages: [LanguageDTO]
    
    var poster: URL? { poster_path.map { MoviesAPI.imageBase.appendingPathComponent($0) } }
    
    struct GenreDTO: Codable {
        let id: Int
        let name: String
    }
    
    struct LanguageDTO: Codable {
        let name: String
    }
}
