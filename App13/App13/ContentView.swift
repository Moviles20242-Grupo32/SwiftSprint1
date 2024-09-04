//
//  ContentView.swift
//  App13
//
//  Created by Daniela Uribe on 28/08/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                Home()
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
