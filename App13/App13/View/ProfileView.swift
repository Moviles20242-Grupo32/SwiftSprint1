//
//  ProfileView.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showPasswordPrompt: Bool = false
    @State private var password = ""
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
            ZStack {
                        // Set the overall background color
                        Color.white.edgesIgnoringSafeArea(.all)
                        if let user = viewModel.currentUser {
                            List {
                                Section {
                                    HStack {
                                        Text(user.initials)
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                            .frame(width: 72, height: 72)
                                            .background(Color.orange)
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 4){
                                            Text(user.fullname)
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                                .fontWeight(.semibold)
                                                .padding(.top, 4)
                                            
                                            Text(user.email)
                                                .font(.footnote)
                                                .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                        }
                                        
                                    }
                                    .listRowBackground(Color.white)
                                }
                                Section(header:
                                        // Custom header with modified color and style
                                        Text("General")
                                        .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                    ){
                                    HStack(spacing: 12){
                                        Image(systemName: "gear")
                                            .imageScale(.small)
                                            .font(.title)
                                            .foregroundColor(Color(.systemGray))
                                        
                                        Text("Versión")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                            .foregroundStyle(.black)
                                        
                                        Spacer()
                                        
                                        Text("1.0.0")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0))
                                    }
                                    .listRowBackground(Color.white)
                                }
                                Section(header:
                                            Text("Cuenta")
                                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                        ){
                                    
                                    VStack(alignment: .leading, spacing: 5){
                                        
                                        Button(action: {
                                            viewModel.signOut()
                                        }) {
                                            HStack(spacing: 12){
                                                Image(systemName: "arrow.left.circle.fill")
                                                    .imageScale(.small)
                                                    .font(.title)
                                                    .foregroundColor(Color(.systemRed))
                                                
                                                Text("Cerrar Sesión")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                                
                                            }
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .listRowBackground(Color.white)
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                }
        }
        .background(Color(.white))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
