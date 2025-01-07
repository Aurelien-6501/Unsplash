import Foundation

struct UnsplashAPI {
    private let scheme = "https"
    private let host = "api.unsplash.com"

    func unsplashApiBaseUrl() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.queryItems = [
            URLQueryItem(name: "client_id", value: ConfigurationManager.instance.plistDictionnary.clientId)
        ]
        return components
    }

    func feedUrl(orderBy: String = "popular", perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl()
        components.path = "/photos"
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "order_by", value: orderBy),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ])
        return components.url
    }

    func topicsUrl() -> URL? {
        var components = unsplashApiBaseUrl()
        components.path = "/topics"
        components.queryItems?.append(URLQueryItem(name: "per_page", value: "10"))
        return components.url
    }

    func topicPhotosUrl(slug: String) -> URL? {
        var components = unsplashApiBaseUrl()
        components.path = "/topics/\(slug)/photos"
        return components.url
    }
}
