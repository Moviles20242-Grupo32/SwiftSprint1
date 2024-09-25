//
//  InputView.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text: String
    let title: String
    let placeHolder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                .fontWeight(.semibold)
                .font(.footnote)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    // Custom colored placeholder text
                    Text(placeHolder)
                        .foregroundColor(Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0))
                        .font(.system(size: 14))
                }
                
                if isSecureField {
                    SecureField("", text: $text)
                        .font(.system(size: 14))
                } else {
                    TextField("", text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                }
            }


        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeHolder: "name@example.com")
}
