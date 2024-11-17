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
    
    // Define the character limits
    let fullNameLimit = 15
    let emailLimit = 50
    let passwordLimit = 20
    
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
                
                InputView(text: $fullName, title: "Nombre", placeHolder: "Ingresa tu nombre")
                    .onChange(of: fullName) { newValue in
                        if fullName.count > fullNameLimit {
                            fullName = String(fullName.prefix(fullNameLimit))
                        }
                    }
                
                if !errorMessageName.isEmpty { //&& (fullName.count > 15 || fullName.isEmpty)
                    Text(errorMessageName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 8)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                
                // Email input with character limit (max 50)
                InputView(text: $email, title: "Correo electrónico", placeHolder: "nombre@ejemplo.com")
                    .onChange(of: email) { newValue in
                        if email.count > emailLimit {
                            email = String(email.prefix(emailLimit))
                        }
                }
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
//                let tldRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|edu|org|net|gov|io)"
//                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", tldRegex)
                if !errorMessageEmail.isEmpty{ //&& !emailPredicate.evaluate(with: email)
                    Text(errorMessageEmail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 8)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                }
                
                // Password input with character limit (max 20)
                InputView(text: $password, title: "Contraseña", placeHolder: "Ingresa una contraseña", isSecureField: true)
                    .onChange(of: password) { newValue in
                        if password.count > passwordLimit {
                            password = String(password.prefix(passwordLimit))
                        }
                }

//                let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$"
//                let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                if !errorMessagePassword.isEmpty { //&& (!passwordPredicate.evaluate(with: password) || password.count <= 5)
                    Text(errorMessagePassword)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 8)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        
                }
                
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
                    errorMessageName = ""
                    errorMessageEmail = ""
                    errorMessagePassword = ""
                    errorMessageUserExists = ""
                    
                    let tldRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|edu|org|net|gov|io)"
                    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", tldRegex)
                    
                    if !emailPredicate.evaluate(with: email) {
                        errorMessageEmail = "Formato incorrecto para el correo."
                    }
                    let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$"
                    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                    
                    if(!passwordPredicate.evaluate(with: password) || !(password.count > 5)){
                        errorMessagePassword = "Debe tener: Mínimo una mayúscula, minúscula y un número. Mínimo 6 carácteres"
                    }
                    if (fullName.isEmpty || fullName.count > 15){
                        errorMessageName = "No puede estar vacio, máx. 15 caracteres"
                    }

                    if errorMessageName.isEmpty && errorMessageEmail.isEmpty && errorMessagePassword.isEmpty{
                        try await viewModel.createUser(withEmail: email,password: password,fullname: fullName)
                        
                        if viewModel.userExists{
                            errorMessageUserExists = "El correo que intenta registrar ya tiene una cuenta asociada."
                        }//no muestra mensaje
                    }
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
            
            if !errorMessageUserExists.isEmpty && viewModel.userExists{
                Text(errorMessageUserExists)
                    .frame(width: 320, alignment: .leading)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.top, 8)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error de conexión"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
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

#Preview {
    RegistrationView()
}
