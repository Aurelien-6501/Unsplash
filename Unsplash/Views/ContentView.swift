import SwiftUI

struct ContentView: View {
    @StateObject var feedState = FeedState()
    @StateObject var topicState = TopicState()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack {
                // Bouton pour charger les données
                Button(action: {
                    Task {
                        // Charger les photos et les topics
                        await feedState.fetchHomeFeed(orderBy: "latest", perPage: 20)
                        await topicState.fetchTopics()
                    }
                }, label: {
                    Text("Load Data")
                        .font(.headline)
                        .padding()
                })
                .disabled(feedState.isLoading || topicState.isLoading)

                // Affichage des topics
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        if topicState.isLoading || topicState.topics.isEmpty {
                            // Placeholder pour les topics avec roues crantées
                            ForEach(0..<10, id: \.self) { _ in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 100, height: 100)
                                    }
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 80, height: 12)
                                }
                            }
                        } else {
                            // Affichage des topics réels
                            ForEach(topicState.topics) { topic in
                                NavigationLink(destination: TopicFeedView(topic: topic)) {
                                    VStack {
                                        if let previewImageUrl = topic.previewImageUrl {
                                            AsyncImage(url: URL(string: previewImageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            } placeholder: {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 100, height: 100)
                                            }
                                        } else {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 100, height: 100)
                                        }

                                        Text(topic.title)
                                            .font(.subheadline)
                                            .padding(5)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Affichage des photos
                ScrollView {
                    if feedState.isLoading {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(0..<12, id: \.self) { _ in
                                PlaceholderViewWithSpinner()
                            }
                        }
                        .padding(.horizontal)
                    } else if let homeFeed = feedState.homeFeed {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(homeFeed) { photo in
                                PhotoView(photo: photo)
                            }
                        }
                        .padding(.horizontal)
                    } else if feedState.homeFeed == nil {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(0..<12, id: \.self) { _ in
                                PlaceholderView()
                            }
                        }
                        .padding(.horizontal)
                    } else if let errorMessage = feedState.errorMessage {
                        Text("Erreur : \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
            .navigationTitle("Feed")
        }
    }
}


struct TopicFeedView: View {
    let topic: UnsplashTopic
    @StateObject var topicState = TopicState()

    var body: some View {
        VStack {
            Text(topic.title)
                .font(.title)
                .padding()
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(topicState.topicPhotos) { photo in
                        PhotoView(photo: photo)
                    }
                }
                .padding(.horizontal)
            }
        }
        .task {
            await topicState.fetchTopicPhotos(for: topic.slug)
        }
    }
}

struct PhotoView: View {
    let photo: UnsplashPhoto

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: photo.urls.regular)) { image in
                image
                    .resizable()
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
            }
        }
    }
}

struct PlaceholderViewWithSpinner: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 150)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct PlaceholderView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 150)
    }
}

// Modèles pour UnsplashPhoto
struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let urls: UnsplashPhotoUrls
    let altDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, urls
        case altDescription = "alt_description"
    }
}

struct UnsplashPhotoUrls: Codable {
    let regular: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
