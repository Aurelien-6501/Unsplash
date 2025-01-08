//
//  TopicState.swift
//  Unsplash
//
//  Created by Aurelien Fillion on 07/01/2025.
//

import Foundation
import Combine

@MainActor
class TopicState: ObservableObject {
    @Published var topics: [UnsplashTopic] = []
    @Published var topicPhotos: [UnsplashPhoto] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let unsplashAPI = UnsplashAPI()

    func fetchTopics() async {
        isLoading = true
        errorMessage = nil

        guard let url = unsplashAPI.topicsUrl() else {
            errorMessage = "URL invalide"
            isLoading = false
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decodedTopics = try JSONDecoder().decode([UnsplashTopic].self, from: data)
            self.topics = decodedTopics
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func fetchTopicPhotos(for slug: String) async {
        isLoading = true
        errorMessage = nil

        guard let url = unsplashAPI.topicPhotosUrl(slug: slug) else {
            errorMessage = "URL invalide"
            isLoading = false
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decodedPhotos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
            self.topicPhotos = decodedPhotos
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
