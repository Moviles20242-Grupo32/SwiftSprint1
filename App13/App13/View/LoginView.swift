//
//  LoginView.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    let emailLimit = 50
    let passwordLimit = 20
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ScrollView {  // Enable scrolling for the entire view
                    VStack {
                        
                        Spacer()
                            .frame(height: 1)
                        
                        // Foodies title image
                        Image("Palabra")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.03)
                        
                        // App logo
                        Image("AppLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                            .clipShape(RoundedRectangle(cornerRadius: 15)) // Adjust the corner radius to match the rounding you need
                            .padding(.vertical, 32)
                        
                        // Form fields for email and password
                        VStack(spacing: 24) {
                            
                            InputView(text: $email, title: "Correo electrónico", placeHolder: "nombre@ejemplo.com")
                                .onChange(of: email) { newValue in
                                    if email.count > emailLimit {
                                        email = String(email.prefix(emailLimit))
                                    }
                                }
                                .autocapitalization(.none)
                            
                            if !errorMessage.isEmpty && errorMessage == "Formato incorrecto para el correo." {
                                Text(errorMessage)
                                    .frame(width: geometry.size.width * 0.8, alignment: .leading)
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                                    .padding(.top, 8)
                            }
                            
                            InputView(text: $password, title: "Contraseña", placeHolder: "Ingresa una contraseña", isSecureField: true)
                                .onChange(of: password) { newValue in
                                    if password.count > passwordLimit {
                                        password = String(password.prefix(passwordLimit))
                                    }
                                }
                        }
                        .padding(.horizontal, geometry.size.width * 0.08)
                        .padding(.top, geometry.size.height * 0.02)
                        
                        // Sign in button
                        Button {
                            Task {
                                if isConnected {
                                    try await viewModel.signIn(withEmail: email, password: password)
                                    
                                    if viewModel.incorrectUserPassword {
                                        errorMessage = "Correo electrónico o contraseña incorrectos. Por favor intente de nuevo."
                                    }
                                    
                                    let tldRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|edu|org|net|gov|io)"
                                    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", tldRegex)
                                    
                                    if !emailPredicate.evaluate(with: email) {
                                        errorMessage = "Formato incorrecto para el correo."
                                    }
                                } else {
                                    errorMessage = "No hay conexión a internet. No se puede iniciar sesión"
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
                            .frame(width: geometry.size.width * 0.9, height: 48)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.orange)
                                .shadow(color: Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0), radius: 5, x: 0, y: 2)
                        )
                        .disabled(!FormIsValid)
                        .opacity(FormIsValid ? 1.0 : 0.6)
                        .cornerRadius(10)
                        .padding(.top, geometry.size.height * 0.03)
                        
                        // Error message for authentication failure
                        if !errorMessage.isEmpty && errorMessage != "Formato incorrecto para el correo." {
                            Text(errorMessage)
                                .frame(width: geometry.size.width * 0.8, alignment: .center)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.top, 8)
                        }
                        
                        Spacer()
                        
                        // Sign up button
                        NavigationLink(destination: RegistrationView()) {
                            HStack {
                                Text("¿No tienes cuenta?")
                                    .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                Text("Registrarte")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                            }
                            .font(.system(size: 16))
                        }
                        
                    }
                    .frame(width: geometry.size.width)
                    .padding(.bottom, geometry.size.height * 0.05)
                }
            }
        }
    }
}



extension LoginView: AuthenticationFormProtocol {
    var FormIsValid: Bool {
        return !email.isEmpty && !password.isEmpty && password.count > 5
    }
}
