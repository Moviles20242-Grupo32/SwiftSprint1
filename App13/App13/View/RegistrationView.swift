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
    @Environment(\.presentationMode) var present
    
    var body: some View {
        VStack{
            
            HStack{
                Button(action: {present.wrappedValue.dismiss()}){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.orange)
                }
                
                Spacer()
                    .frame(width: 300)
            }
            
            //image
            Image("AppLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding(.vertical, 32)
            
            //form fields
            VStack(spacing: 24){
                InputView(text: $fullName,
                          title: "Usuario",
                          placeHolder: "Ingresa un usuario")
                
                InputView(text: $email,
                          title: "Correo electrónico",
                          placeHolder: "nombre@ejemplo.com")
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                InputView(text: $password,
                          title: "Contraseña",
                          placeHolder: "Ingresa una contraseña",
                          isSecureField: true)
                
                ZStack(alignment: .trailing){
                    InputView(text: $confirmPassword,
                              title: "Confirmar contraseña",
                              placeHolder: "Confirma la contraseña",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else{
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(30)
            .padding(.top, 12)

            
            //Sign Up button
            Button {
                Task{
                    try await viewModel.createUser(withEmail: email,                                password: password,                              fullname: fullName)
                }
            } label: {
                HStack {
                    Text("Registrar")
                        .fontWeight(.semibold)
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
            
            // Sign In button
            Button{
                dismiss()
            } label: {
                HStack {
                    Text("¿Ya tienes cuenta?")
                        .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                    Text("Inicia sesión")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                }
                .font(.system(size: 16))
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var FormIsValid: Bool {
        return !email.isEmpty && email.contains("@")
        && !password.isEmpty && password.count > 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
}

#Preview {
    RegistrationView()
}
