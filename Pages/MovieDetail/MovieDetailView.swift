//
//  MovieDetailView.swift
//  SwiftUI_MVVM
//
//  Created by Sam Kerridge on 28/09/21.
//

import SwiftUI
import Combine

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
        content
            .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return spinner.eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let movie):
            return self.movie(movie).eraseToAnyView()
        }
    }
    
    private func movie(_ movie: MovieDetailViewModel.MovieDetail) -> some View {
        ScrollView {
            VStack {
                fillWidth
                
                Text(movie.title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                             
                Divider()

                HStack {
                    Text(movie.releasedAt)
                    Text(movie.language)
                    Text(movie.duration)
                }
                .font(.subheadline)
                
                poster(of: movie)
                
                genres(of: movie)
                
                Divider()

                movie.rating.map {
                    Text("⭐️ \(String($0))/10").font(.body)
                }
                
                Divider()

                movie.overview.map {
                    Text($0).font(.body)
                }
            }
        }
    }
    
    private var fillWidth: some View {
        HStack {
            Spacer()
        }
    }
        
    @ViewBuilder
    private func poster(of movie: MovieDetailViewModel.MovieDetail) -> some View {
        if #available(iOS 15.0, *) {
            movie.poster.map { url in
                AsyncImage(
                    url: url,
                    content: { image in
                        image.resizable()
                    },
                    placeholder: {
                        self.spinner
                    }
                ).aspectRatio(contentMode: .fit)
            }
        }
    }
        
    private var spinner: Spinner { Spinner(isAnimating: true, style: .large) }
    
    private func genres(of movie: MovieDetailViewModel.MovieDetail) -> some View {
        HStack {
            ForEach(movie.genres, id: \.self) { genre in
                Text(genre)
                    .padding(5)
                    .border(Color.gray)
            }
        }
    }
}
