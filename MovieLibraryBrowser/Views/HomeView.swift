//
//  HomeView.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/2/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel: MovieViewModel
    var body: some View {
        HomeViewContent(viewModel: viewModel)
    }
}

struct HomeViewContent: View {
    @StateObject var viewModel: MovieViewModel
    var body: some View {
        VStack
        {
            HStack{
                Text("Most Popular")
                Spacer()
                Button("Today"){
                    print("retrieve daily")
                    Task {
                        await viewModel.loadMovies(for: "day")
                    }
                }
                Button("This Week"){
                    print("retrieve weekly")
                    Task {
                        await viewModel.loadMovies(for: "week")
                    }
                }
            }
            if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.movies) { movie in
                            MovieView(movie: movie, movieViewModel: viewModel)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
        .padding()
    }
}
