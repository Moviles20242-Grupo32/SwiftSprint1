//
//  LoginView.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email =  ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                
                Spacer()
                    .frame(height: 1)
                
                Image("Palabra")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 10)
                
                Spacer()
                    .frame(height: 50)
                
                //image
                Image("AppLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 10)
                

                
                
                //form fields
                VStack(spacing: 24){
                    
                    InputView(text: $email,
                              title: "Correo electrónico",
                              placeHolder: "nombre@ejemplo.com")
                    .autocapitalization(.none)
                    

                    InputView(text: $password,
                              title: "Contraseña",
                              placeHolder: "Ingrese su contraseña",
                              isSecureField: true)
                }
                .padding(30)
                .padding(.top, 12)
                
                // sign in button
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email,                        password: password)
                    }
                } label: {
                    HStack {
                        Text("Iniciar sesión")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                            Image(systemName: "arrow.right")
                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32,          height: 48)
                }
                .background(
                                RoundedRectangle(cornerRadius: 10) // Adjust corner radius as needed
                                .fill(Color.orange) // Background color of the rectangle
                                .shadow(color: Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0), radius: 5, x: 0, y: 2) // Shadow parameters
                            )
                .disabled(!FormIsValid)
                .opacity(FormIsValid ? 1.0 : 0.8)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                // sign up button
                NavigationLink(destination: {
                    RegistrationView()
                }, label: {
                    HStack {
                        Text("¿No tienes cuenta?")
                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                        Text("Registrarte")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                    }
                    .font(.system(size: 16))
                })
                
                
            }
        }

    }
}

extension LoginView: AuthenticationFormProtocol {
    var FormIsValid: Bool {
        return !email.isEmpty && email.contains("@")
        && !password.isEmpty && password.count > 5
    }
}

#Preview {
    LoginView()
}
