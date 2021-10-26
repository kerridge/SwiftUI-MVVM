//
//  MoviesAPI.swift
//  SwiftUI_MVVM
//
//  Created by Sam Kerridge on 12/10/21.
//

import Foundation
import Combine

enum MoviesAPI {
    static let imageBase = URL(string: "https://image.tmdb.org/t/p/original/")!
    
    private static let base = URL(string: "https://api.themoviedb.org/3")!
    private static let apiKey = "efb6cac7ab6a05e4522f6b4d1ad0fa43"
    private static let agent = Agent()
    
    static func trending() -> AnyPublisher<PageDTO<MovieDTO>, Error> {
        let request = URLComponents(
            url: base.appendingPathComponent("trending/movie/week"),
            resolvingAgainstBaseURL: true
        )?
        .addingApiKey(apiKey)
        .request
        
        return agent.run(request!)
    }
    
    static func latest() -> AnyPublisher<PageDTO<MovieDTO>, Error> {
        let request = URLComponents(
            url: base.appendingPathComponent("movie/latest"),
            resolvingAgainstBaseURL: true
        )?
        .addingApiKey(apiKey)
        .request

        return agent.run(request!)
    }
    
    static func movieDetail(id: Int) -> AnyPublisher<MovieDetailDTO, Error> {
        let request = URLComponents(
            url: base.appendingPathComponent("movie/\(id)"),
            resolvingAgainstBaseURL: true
        )?
        .addingApiKey(apiKey)
        .request
        
        return agent.run(request!)
    }
}

private extension URLComponents {
    func addingApiKey(_ apiKey: String) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        return copy
    }
    
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}
