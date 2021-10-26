import SwiftUI

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                trendingMoviesView
            }
            .navigationBarTitle("Home")
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var trendingMoviesView: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
            
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
            
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
            
        case .loaded:
            return movieCarousel(of: viewModel.trendingMovies, title: "Trending Movies").eraseToAnyView()
        }
    }
    
//    private var latestMoviesView: some View {
//
//    }
    
    private func movieCarousel(of movies: [MoviesListViewModel.ListItem], title: String) -> some View {
        return VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(movies) { movie in
                        NavigationLink(
                            destination: MovieDetailView(viewModel: MovieDetailViewModel(movieID: movie.id)),
                            label: { MovieListItemView(movie: movie) }
                        )
                    }
                }
            }
        }
    }
}

struct MovieListItemView: View {
    let movie: MoviesListViewModel.ListItem

    var body: some View {
        VStack {
            poster
            title
        }
    }
    
    let posterSize: CGSize = CGSize(
        width: UIScreen.main.bounds.height * 0.30 / 1.5,
        height: UIScreen.main.bounds.height * 0.30
    ) // 2:3 aspect ratio
    
    private var title: some View {
        Text(movie.title)
            .font(.caption)
            .frame(maxWidth: posterSize.width, alignment: .leading)
    }
    
    @ViewBuilder
    private var poster: some View {
        if #available(iOS 15.0, *) {
            movie.poster.map { url in
                AsyncImage(
                    url: url,
                    content: { image in
                        image
                            .resizable()
                            .scaledToFill()
                    },
                    placeholder: {
                        self.spinner
                    }
                )
            }
            .frame(width: posterSize.width, height: posterSize.height)
            .background(Color.gray)
            .cornerRadius(15)
        }
    }
    
    private var spinner: some View {
        Spinner(isAnimating: true, style: .medium)
    }
}
