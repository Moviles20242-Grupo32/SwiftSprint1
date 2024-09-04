//
//  RegistrationView.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            
            //image
            Image("AppLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding(.vertical, 32)
            
            //form fields
            VStack(spacing: 24){
                InputView(text: $fullName,
                          title: "Full Name",
                          placeHolder: "Enter your name")
                
                InputView(text: $email,
                          title: "Email Address",
                          placeHolder: "name@example.com")
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                InputView(text: $password,
                          title: "Password",
                          placeHolder: "Enter your password",
                          isSecureField: true)
                
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeHolder: "Confirm your password",
                          isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            //Sign Up button
            Button {
                Task{
                    try await viewModel.createUser(withEmail: email,                                password: password,                              fullname: fullName)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32,          height: 48)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            // Sign In button
            Button{
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .font(.system(size: 16))
            }
        }
    }
}

#Preview {
    RegistrationView()
}
