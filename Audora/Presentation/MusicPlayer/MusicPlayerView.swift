//
//  MusicPlayerView.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import SwiftUI

struct MusicPlayerView: View {
    @StateObject var viewModel = MusicPlayerViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Welcome !")
                        .font(.custom(.rubik, size: 24, weight: .medium))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .padding(.horizontal)
                    
                    SearchView(placeholder: "Search music, albums...", searchQuery: $viewModel.searchQuery) {
                        viewModel.getMusicList(query: $0)
                    }
                    .shadow(color: .gray.opacity(0.3), radius: 4)
                    .background(.clear)
                    .padding()
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(viewModel.musicList, id: \.self) { music in
                                Button(action: {
                                    withAnimation {
                                        viewModel.selectMusic(selectedMusic: music)
                                    }
                                }, label: {
                                    MusicItemView(
                                        imageUrl: music.artworkUrl100 ?? "-",
                                        trackName: music.trackName ?? "-",
                                        artistName: music.artistName ?? "-",
                                        collectionName: music.collectionName ?? "-",
                                        isSelected: music == viewModel.selectedMusic,
                                        playbackState: Binding(
                                            get: { viewModel.isPlayingMusic ? .play : .pause },
                                            set: { viewModel.isPlayingMusic = ($0 == .play) }
                                        ))
                                })
                            }
                        }
                    }.padding(.horizontal)
                    
                    if viewModel.selectedMusic != nil {
                        PlayerView(viewModel: viewModel.playerViewModel)
                            .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 16))
                            .transition(.slideUp)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.3), value: viewModel.selectedMusic)
                    }
                    
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
            }
            .background(.gray.opacity(0.01))
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    MusicPlayerView()
}

struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension AnyTransition {
    static var slideUp: AnyTransition {
        .move(edge: .bottom).combined(with: .opacity)
    }
}
