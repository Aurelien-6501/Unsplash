//
//  TopicFeedView.swift
//  Unsplash
//
//  Created by Aurelien Fillion on 08/01/2025.
//

//
//  TopicFeedView.swift
//  Unsplash
//
//  Created by Aurelien Fillion on 08/01/2025.
//

import SwiftUI

struct TopicFeedView: View {
    let topic: UnsplashTopic
    @StateObject var topicState = TopicState()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @State private var selectedPhoto: UnsplashPhoto? = nil

    var body: some View {
        VStack {
            Text(topic.title)
                .font(.title)
                .padding()

            Button(action: {
                Task {
                    await topicState.fetchTopicPhotos(for: topic.slug)
                }
            }, label: {
                Text("Load Photos")
                    .font(.headline)
                    .padding()
            })
            .disabled(topicState.isLoading)

            ScrollView {
                if topicState.isLoading {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(0..<12, id: \.self) { _ in
                            PlaceholderViewWithSpinner()
                        }
                    }
                    .padding(.horizontal)
                } else if topicState.topicPhotos.isEmpty {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(0..<12, id: \.self) { _ in
                            PlaceholderView()
                        }
                    }
                    .padding(.horizontal)

                    Text("No photos available for this topic.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(topicState.topicPhotos) { photo in
                            PhotoView(photo: photo)
                                .onTapGesture {
                                    selectedPhoto = photo
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(item: $selectedPhoto) { photo in
            DetailView(photo: photo)
                .padding(.top, 16)
        }
    }
}

struct TopicFeedView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTopic = UnsplashTopic(
            id: "1",
            title: "Nature",
            slug: "nature",
            coverPhoto: UnsplashPhoto(
                id: "photo1",
                urls: UnsplashPhotoUrls(
                    regular: "https://150",
                    full: "https://300",
                    small: "https://50"
                ),
                altDescription: "Sample photo",
                user: nil
            )
        )
        TopicFeedView(topic: sampleTopic)
    }
}
