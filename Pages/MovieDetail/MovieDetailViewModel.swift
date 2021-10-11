//
//  MovieDetailViewModel.swift
//  SwiftUI_MVVM
//
//  Created by Sam Kerridge on 28/09/21.
//

import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var state: State
    
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
          
    init(movieID: Int) {
        state = .idle(movieID)
          
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }

    func send(event: Event) {
        input.send(event)
    }
}

extension MovieDetailViewModel {
    enum State {
        case idle(Int)
        case loading(Int)
        case loaded(MovieDetail)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onLoaded(MovieDetail)
        case onFailedToLoad(Error)
    }
    
    struct MovieDetailDTO: Codable {
        let id: Int
        let title: String
        let overview: String?
        let poster_path: String?
        let vote_average: Double?
//        let genres: [GenreDTO]
        let release_date: String?
        let runtime: Int?
//        let spoken_languages: [LanguageDTO]
    }
    
    struct MovieDetail: Identifiable {
        let id: Int
        let title: String
        let overview: String?
        
        init(movie: MovieDetailDTO) {
            id = movie.id
            title = movie.title
            overview = movie.overview
        }
    }
}

// MARK: - State Machine

extension MovieDetailViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle(let id):
            switch event {
            case .onAppear:
                return .loading(id)
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoad(let error):
                return .error(error)
            case .onLoaded(let movie):
                return .loaded(movie)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading(let id) = state else { return Empty().eraseToAnyPublisher() }
            return MoviesAPI.movieDetail(id: id)
                .map(MovieDetail.init)
                .map(Event.onLoaded)
                .catch { Just(Event.onFailedToLoad($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback(run: { _ in
            return input
        })
    }
}
