//
//  UnsplashTopic.swift
//  Unsplash
//
//  Created by Aurelien Fillion on 07/01/2025.
//

import Foundation

struct UnsplashTopic: Codable, Identifiable {
    let id: String
    let title: String
    let slug: String
    let coverPhoto: UnsplashPhoto?

        var previewImageUrl: String? {
            coverPhoto?.urls.regular
        }

        enum CodingKeys: String, CodingKey {
            case id, title, slug
            case coverPhoto = "cover_photo"
        }
}
