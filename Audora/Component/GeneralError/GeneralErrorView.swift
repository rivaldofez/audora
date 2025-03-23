//
//  GeneralErrorView.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import SwiftUI

struct GeneralErrorView: View {
    var message: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "x.square")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text(message)
                .font(.custom(.rubik, size: 16, weight: .semiBold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    GeneralErrorView(message: "Lorem ipsum dolor sit amet")
}


