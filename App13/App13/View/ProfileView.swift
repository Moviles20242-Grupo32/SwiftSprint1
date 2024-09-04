//
//  ProfileView.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {

        if let user = viewModel.currentUser {

        }
        List {
            Section {
                HStack {
                    Text("JA") //user.initials
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text("Juan  And") //user.fullname
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text("email@email.com") //user.email
                            .font(.footnote)
                            .accentColor(.gray)
                    }
                    
                }
            }
            Section("General"){
                HStack(spacing: 12){
                    Image(systemName: "gear")
                        .imageScale(.small)
                        .font(.title)
                        .foregroundColor(Color(.systemGray))
                    
                    Text("Version")
                        .font(.subheadline)
                        .foregroundStyle(.black)
                
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            Section("Account"){
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Button(action: {
                        print("Sign Out")
                    }) {
                        HStack(spacing: 12){
                            Image(systemName: "arrow.left.circle.fill")
                                .imageScale(.small)
                                .font(.title)
                                .foregroundColor(Color(.systemRed))
                            
                            Text("Sign Out")
                                .font(.subheadline)
                                .foregroundStyle(.black)
                        
                        }
                    }
                    
                    Divider()
                    
                    Button(action: {
                        print("Delete account")
                    }){
                        HStack(spacing: 12){
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.small)
                                .font(.title)
                                .foregroundColor(Color(.systemRed))
                            
                            Text("Delete Account")
                                .font(.subheadline)
                                .foregroundStyle(.black)
                        
                        }
                    }
                    
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        
        
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
