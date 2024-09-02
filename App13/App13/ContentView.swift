//
//  ContentView.swift
//  App13
//
//  Created by Daniela Uribe on 28/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            Home()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
