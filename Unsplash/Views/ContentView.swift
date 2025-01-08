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
                Button(action: {
                    Task {
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
                            ForEach(0..<5, id: \.self) { _ in
                                VStack {
                                    PlaceholderView()
                                        .frame(width: 100, height: 100)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 80, height: 12)
                                }
                            }
                        } else {
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
                                                PlaceholderView()
                                                    .frame(width: 100, height: 100)
                                            }
                                        } else {
                                            PlaceholderView()
                                                .frame(width: 100, height: 100)
                                        }

                                        Text(topic.title)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 100)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
