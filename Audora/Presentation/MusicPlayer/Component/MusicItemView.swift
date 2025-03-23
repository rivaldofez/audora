//
//  MusicItemView.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import SwiftUI

struct MusicItemView: View {
    private var imageSize: CGFloat = 65
    var imageUrl: String
    var trackName: String
    var artistName: String
    var collectionName: String
    var isSelected: Bool
    @Binding var playbackState: SpectrumState
    
    init(imageUrl: String, trackName: String, artistName: String, collectionName: String, isSelected: Bool, playbackState: Binding<SpectrumState>) {
        self.imageUrl = imageUrl
        self.trackName = trackName
        self.artistName = artistName
        self.collectionName = collectionName
        self.isSelected = isSelected
        self._playbackState = playbackState
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                        .transition(.opacity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .aspectRatio(contentMode: .fit)
                        .transition(.opacity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                case .failure:
                    Image(systemName: "rectangle.slash")
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .aspectRatio(contentMode: .fit)
                        .transition(.opacity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trackName)
                    .font(.custom(.rubik, size: 16, weight: .semiBold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(artistName)
                    .font(.custom(.rubik, size: 12, weight: .medium))
                    .foregroundColor(.primary.opacity(0.7))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(collectionName)
                    .font(.custom(.rubik, size: 10, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            if isSelected {
                SpectrumView(state: $playbackState)
                    .frame(width: 30, height: 30)
                    .padding(.horizontal)
            }
        }
        .shadow(color: .gray.opacity(0.3), radius: 10)
    }
}

struct MusicItemViewShimmer: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 65, height: 65)
                .shimmer()
            
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .shimmer()
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 30)
                .shimmer()
        }
    }
}


#Preview {
    MusicItemView(imageUrl: "", trackName: "", artistName: "", collectionName: "", isSelected: true, playbackState: .constant(.play))
}
