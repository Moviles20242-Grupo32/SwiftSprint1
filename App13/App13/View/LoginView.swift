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
    @State private var errorMessage = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                
                Spacer()
                    .frame(height: 1)
                
                //Foodies
                Image("Palabra")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 10)
                
                Spacer()
                    .frame(height: 50)
                
                // Logo foodies
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
                    
                    if !errorMessage.isEmpty && errorMessage == "Formato incorrecto para el correo."{
                        Text(errorMessage)
                            .frame(width: 350, alignment: .leading)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top, 8)
                    }

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
                        
                        if viewModel.incorrectUserPassword{
                            errorMessage = "Correo electrónico o contraseña incorrectos. Por favor intente de nuevo."
                        }
                        
                        let tldRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|edu|org|net|gov|io)"
                        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", tldRegex)
                        
                        if !emailPredicate.evaluate(with: email) {
                            errorMessage = "Formato incorrecto para el correo."
                        }
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
                .opacity(FormIsValid ? 1.0 : 0.6)
                .cornerRadius(10)
                .padding(.top, 24)
                
                //If user auth failed.
                if !errorMessage.isEmpty && viewModel.incorrectUserPassword == true{
                    Text(errorMessage)
                        .frame(width: 350, alignment: .leading)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 8)
                }
                
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
        return !email.isEmpty && !password.isEmpty && password.count > 5
    }
}

#Preview {
    LoginView()
}
