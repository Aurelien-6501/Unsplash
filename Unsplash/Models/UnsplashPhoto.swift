//
//  UnsplashPhoto.swift
//  Unsplash
//
//  Created by Aurelien Fillion on 08/01/2025.
//

struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let urls: UnsplashPhotoUrls
    let altDescription: String?
    let user: UnsplashUser?

    enum CodingKeys: String, CodingKey {
        case id, urls, user
        case altDescription = "alt_description"
    }
}

struct UnsplashPhotoUrls: Codable {
    let regular: String
    let full: String
    let small: String
}

struct UnsplashUser: Codable {
    let username: String
    let profileImage: UnsplashUserProfileImage?
    let portfolioURL: String?

    enum CodingKeys: String, CodingKey {
        case username
        case profileImage = "profile_image"
        case portfolioURL = "portfolio_url"
    }
}

struct UnsplashUserProfileImage: Codable {
    let small: String
}
