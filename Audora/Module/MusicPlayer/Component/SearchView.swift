//
//  SearchView.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import SwiftUI

struct SearchView: View {
    var placeholder: String = ""
    @Binding var searchQuery: String
    var onSubmitQuery: (String) -> Void
    
    var body: some View {
        ZStack {
            HStack {
                TextField(placeholder, text: $searchQuery)
                    .font(.custom(.rubik, size: 14))
                    .padding()
                    .onSubmit {}
                
                Button(action: {
                    onSubmitQuery(searchQuery)
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                })
            }
        }
        .background(.background)
        .cornerRadius(10)
    }
}

#Preview {
    SearchView(placeholder: "Search music, album.....", searchQuery: .constant(""), onSubmitQuery: {_ in })
}
