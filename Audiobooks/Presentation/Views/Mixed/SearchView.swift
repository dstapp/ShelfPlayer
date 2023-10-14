//
//  SearchView.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 14.10.23.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.libraryId) var libraryId
    
    @State var query = ""
    @State var task: Task<(), Error>? = nil
    
    @State var audiobooks = [Audiobook]()
    @State var podcasts = [Podcast]()
    @State var authors = [Author]()
    @State var series = [Series]()
    
    var body: some View {
        NavigationStack {
            List {
                if !audiobooks.isEmpty {
                    Section("Audiobooks") {
                        ForEach(audiobooks) { audiobook in
                            NavigationLink(destination: AudiobookView(audiobook: audiobook)) {
                                AudiobookRow(audiobook: audiobook)
                            }
                        }
                    }
                }
                if !podcasts.isEmpty {
                    Section("Podcasts") {
                        ForEach(podcasts) { podcast in
                            NavigationLink(destination: PodcastView(podcast: podcast)) {
                                PodcastRow(podcast: podcast)
                            }
                        }
                    }
                }
                
                if !series.isEmpty {
                    Section("Series") {
                        ForEach(series) { item in
                            NavigationLink(destination: SeriesView(series: item)) {
                                SeriesRow(series: item)
                            }
                        }
                    }
                }
                
                if !authors.isEmpty {
                    Section("Authors") {
                        ForEach(authors) { author in
                            NavigationLink(destination: AuthorView(author: author)) {
                                AuthorRow(author: author)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Search")
            .searchable(text: $query)
            .modifier(NowPlayingBarSafeAreaModifier())
            .onChange(of: query) {
                task?.cancel()
                task = Task.detached {
                    do {
                        (audiobooks, podcasts, authors, series) = try await AudiobookshelfClient.shared.search(query: query, libraryId: libraryId)
                    }
                }
            }
        }
        .modifier(NowPlayingBarModifier())
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }
    }
}

#Preview {
    SearchView()
        .environment(\.libraryId, "4c5831b3-13e1-43e8-a1db-5a4e48929321")
}


#Preview {
    SearchView()
        .environment(\.libraryId, "368e36e5-22b2-4d74-8f17-c50fe6299adf")
}
