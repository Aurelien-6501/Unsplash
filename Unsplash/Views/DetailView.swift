//
//  DetailView.swift
//  Unsplash
//
//  Created by Aurelien Fillion on 08/01/2025.
//

import SwiftUI

struct DetailView: View {
    let photo: UnsplashPhoto

    @State private var selectedSize: ImageSize = .regular

    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 20)
            HStack(spacing: 10) {
                if let profileImage = photo.user?.profileImage?.small {
                    AsyncImage(url: URL(string: profileImage)) { image in
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                    }
                }
                VStack(alignment: .leading) {
                    Text("Une image de @\(photo.user?.username ?? "inconnu")")
                        .font(.headline)
                    if let portfolioUrl = photo.user?.portfolioURL {
                        Link("Voir le profil", destination: URL(string: portfolioUrl)!)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)

            Picker("Taille", selection: $selectedSize) {
                ForEach(ImageSize.allCases, id: \.self) { size in
                    Text(size.rawValue.capitalized)
            }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            AsyncImage(url: URL(string: selectedSize.url(for: photo))) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding()
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .padding()
            }

            Button(action: {
                downloadImage(from: selectedSize.url(for: photo))
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Télécharger")
                }
            }
            .padding()


            Spacer()
        }
        .navigationTitle("Détails de l'image")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func downloadImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            }
        }.resume()
    }
}

enum ImageSize: String, CaseIterable {
    case regular, full, small

    func url(for photo: UnsplashPhoto) -> String {
        switch self {
        case .regular:
            return photo.urls.regular
        case .full:
            return photo.urls.full
        case .small:
            return photo.urls.small
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePhoto = UnsplashPhoto(
            id: "1",
            urls: UnsplashPhotoUrls(
                regular: "https://300",
                full: "https://600",
                small: "https:///150"
            ),
            altDescription: "Sample photo",
            user: UnsplashUser(
                username: "Test",
                profileImage: UnsplashUserProfileImage(small: "https://40"),
                portfolioURL: "https://test.com"
            )
        )
        DetailView(photo: samplePhoto)
    }
}   
