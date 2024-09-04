//
//  Menu.swift
//  App13
//
//  Created by Daniela Uribe on 28/08/24.
//

import SwiftUI

struct Menu: View {
    
    @ObservedObject var homeData : HomeViewModel
    var body: some View {
        VStack{
            
            NavigationLink(destination: CartView(homeData: homeData)){

                HStack(spacing: 15){
                    
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(.orange)
                    
                    Text("Carrito")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
                .padding()
            }
            
            Spacer()
            
//            NavigationLink(destination: {
//                ProfileView()
//            }, label: {
//                HStack(spacing: 15){
//                    Image(systemName: "person.crop.circle")
//                        .font(.title)
//                        .foregroundColor(.orange)
//                    
//                    Text("Mi Perfil")
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                    
//                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
//                }
//                .padding()
//            })
        }
        .frame(width: UIScreen.main.bounds.width/1.6)
        .background(Color.white.ignoresSafeArea())
        
    }
}


#Preview {
    Menu(homeData: HomeViewModel())
}

