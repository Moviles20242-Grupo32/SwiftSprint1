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
    @State private var errorMessageName = ""
    @State private var errorMessageEmail = ""
    @State private var errorMessagePassword = ""
    @State private var errorMessageUserExists = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var present

    let fullNameLimit = 15
    let emailLimit = 50
    let passwordLimit = 20

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center) {
                    // Top HStack with back button
                    HStack {
                        Button(action: { present.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundColor(.orange)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    // App Logo
                    Image("AppLogo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                        .clipShape(RoundedRectangle(cornerRadius: 15)) // Adjust the corner radius to match the rounding you need
                        .padding(.vertical, 32)

                    // Form fields
                    VStack(spacing: 24) {
                        InputView(text: $fullName, title: "Nombre", placeHolder: "Ingresa tu nombre")
                            .onChange(of: fullName) { newValue in
                                if fullName.count > fullNameLimit {
                                    fullName = String(fullName.prefix(fullNameLimit))
                                }
                            }
                        if !errorMessageName.isEmpty {
                            Text(errorMessageName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.top, 8)
                        }

                        InputView(text: $email, title: "Correo electrónico", placeHolder: "nombre@ejemplo.com")
                            .onChange(of: email) { newValue in
                                if email.count > emailLimit {
                                    email = String(email.prefix(emailLimit))
                                }
                            }
                            .autocapitalization(.none)
                        if !errorMessageEmail.isEmpty {
                            Text(errorMessageEmail)
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                        if !errorMessagePassword.isEmpty {
                            Text(errorMessagePassword)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.top, 8)
                        }

                        ZStack(alignment: .trailing) {
                            InputView(text: $confirmPassword, title: "Confirmar contraseña", placeHolder: "Confirma la contraseña", isSecureField: true)
                            if !password.isEmpty && !confirmPassword.isEmpty {
                                Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(password == confirmPassword ? Color(.systemGreen) : Color(.systemRed))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    // Sign Up button
                    Button {
                        Task {
                            // Sign up logic
                        }
                    } label: {
                        Text("Registrar")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 69/255, green: 39/255, blue: 13/255))
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.orange)
                                    .shadow(color: Color(red: 143/255, green: 120/255, blue: 111/255), radius: 5, x: 0, y: 2)
                            )
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top, 24)
                    }
                    .disabled(!FormIsValid)
                    .opacity(FormIsValid ? 1.0 : 0.8)

                    if !errorMessageUserExists.isEmpty && viewModel.userExists {
                        Text(errorMessageUserExists)
                            .frame(width: geometry.size.width * 0.8, alignment: .leading)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top, 8)
                    }

                    Spacer()

                    // Sign In button
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("¿Ya tienes cuenta?")
                                .foregroundColor(Color(red: 69/255, green: 39/255, blue: 13/255))
                            Text("Inicia sesión")
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 69/255, green: 39/255, blue: 13/255))
                        }
                        .font(.system(size: 16))
                    }
                    .padding(.bottom)
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error de conexión"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                .frame(width: geometry.size.width, alignment: .center)
            }
        }
    }
}




extension RegistrationView: AuthenticationFormProtocol {
    var FormIsValid: Bool {
        return !email.isEmpty && !password.isEmpty
        && confirmPassword == password
        && !fullName.isEmpty
    }
}

