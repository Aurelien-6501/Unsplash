import Foundation
import Combine

@MainActor
class FeedState: ObservableObject {
    @Published var homeFeed: [UnsplashPhoto]? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let unsplashAPI = UnsplashAPI()

    /// Fonction pour charger le flux d'images
    func fetchHomeFeed(orderBy: String = "popular", perPage: Int = 10) async {
        isLoading = true
        errorMessage = nil

        guard let url = unsplashAPI.feedUrl(orderBy: orderBy, perPage: perPage) else {
            isLoading = false
            errorMessage = "URL invalide"
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decodedPhotos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
            self.homeFeed = decodedPhotos
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
