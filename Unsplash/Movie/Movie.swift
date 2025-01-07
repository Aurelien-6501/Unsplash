//
//  Movie.swift
//  YourProject
//
//  Created by Aurelien Fillion on 07/01/2025.
//

import Foundation

// Define the Movie structure
struct Movie: Codable {
    let title: String
    let releaseYear: Int
    let genre: String
    let director: Director? // Optional director property
}

// Define the Director structure
struct Director: Codable {
    let firstName: String
    let lastName: String
}
