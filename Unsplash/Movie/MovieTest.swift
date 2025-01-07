//
//  MovieTest.swift
//  Unsplash
//
//  Created by Aurelien Fillion on 07/01/2025.
//
//

import Foundation

let jsonString = """
[
    {
        "title": "Inception",
        "releaseYear": 2010,
        "genre": "Sci-Fi",
        "director": {
            "firstName": "Christopher",
            "lastName": "Nolan"
        }
    },
    {
        "title": "The Dark Knight",
        "releaseYear": 2008,
        "genre": "Action",
        "director": {
            "firstName": "Christopher",
            "lastName": "Nolan"
        }
    },
    {
        "title": "Dunkirk",
        "releaseYear": 2017,
        "genre": "War",
        "director": null
    }
]
"""
func decodeMovies() {
    
    
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: jsonData)
            for movie in movies {
                if let director = movie.director {
                    print("Film: \(movie.title), Année de sortie: \(movie.releaseYear), Genre: \(movie.genre), Réalisateur: \(director.firstName) \(director.lastName)")
                } else {
                    print("Film: \(movie.title), Année de sortie: \(movie.releaseYear), Genre: \(movie.genre), Réalisateur: Inconnu")
                }
            }
        } catch {
            print("Erreur de décodage: \(error)")
        }
    }
    
}

