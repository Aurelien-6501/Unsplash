//
//  PhotoView.swift
//  Unsplash
//
//  Created by Aurelien Fillion on 08/01/2025.
//

import SwiftUICore
import SwiftUI

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

struct PlaceholderView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 150)
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


