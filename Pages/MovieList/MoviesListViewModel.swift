import Combine
import Foundation

final class MoviesListViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    
    @Published var trendingMovies: [ListItem] = []
    
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}


extension MoviesListViewModel {
    enum State {
        case idle
        case loading
        case loaded
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectMovie(Int)
        case onTrendingMoviesLoaded([ListItem])
        case onFailedToLoadMovies(Error)
    }
    
    struct ListItem: Identifiable {
        let id: Int
        let title: String
        let poster: URL?
//        let genres: [String]
        
        init(movie: MovieDTO) {
            id = movie.id
            title = movie.title
            poster = movie.poster
//            genres = movie.genres.map(\.name)
        }
    }
}

extension MoviesListViewModel {
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return MoviesAPI.trending()
                .map { $0.results.map(ListItem.init) }
                .map(Event.onTrendingMoviesLoaded)
                .catch { Just(Event.onFailedToLoadMovies($0)) }
                .eraseToAnyPublisher()
        }
    }
    
//    static func whenLoadingLatestMovies() -> Feedback<State, Event> {
//        Feedback { (state: State) -> AnyPublisher<Event, Never> in
//            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
//
//            return MoviesAPI.latest()
//                .map { $0.results.map(ListItem.init) }
//                .map(Event.onTrendingMoviesLoaded)
//                .catch { Just(Event.onFailedToLoadMovies($0)) }
//                .eraseToAnyPublisher()
//        }
//    }
}

extension MoviesListViewModel {
    func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadMovies(let error):
                return .error(error)
            case .onTrendingMoviesLoaded(let movies):
                trendingMovies = movies
                return .loaded
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }

    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
