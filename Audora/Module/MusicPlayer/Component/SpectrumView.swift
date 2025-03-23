//
//  SpectrumView.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import SwiftUI

enum SpectrumState {
    case play, pause, reset
}

struct SpectrumView: View {
    @State private var bars: [Double] = Array(repeating: 0.5, count: 8)
    @State private var timer: Timer? = nil
    @Binding var state: SpectrumState
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 4) {
                ForEach(0..<bars.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.primary, Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: geometry.size.width / CGFloat(bars.count), height: CGFloat(bars[index] * geometry.size.height))
                        .animation(.easeInOut(duration: 0.2), value: bars[index])
                }
            }
            .onChange(of: state, { _, newValue in
                handleStateChange(newValue)
            })
            .onAppear {
                handleStateChange(state)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func handleStateChange(_ newState: SpectrumState) {
        switch newState {
        case .play:
            startAnimating()
        case .pause:
            stopTimer()
        case .reset:
            stopTimer()
            bars = Array(repeating: 0.5, count: 8)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startAnimating() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation {
                bars = bars.map { _ in Double.random(in: 0.2...1) }
            }
        }
    }
}
