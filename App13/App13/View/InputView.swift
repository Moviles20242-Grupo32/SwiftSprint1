//
//  InputView.swift
//  App13
//
//  Created by Daniela Uribe on 11/09/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    var title: String
    var placeHolder: String
    var textColor: Color = .black // Default text color

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField(placeHolder, text: $text)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .foregroundColor(textColor) // Add text color here
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}
