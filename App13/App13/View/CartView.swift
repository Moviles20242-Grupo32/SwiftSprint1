//
//  CartView.swift
//  App13
//
//  Created by Daniela Uribe on 2/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack{
            
            HStack(spacing: 20){
                Button(action: {present.wrappedValue.dismiss()}){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.orange)
                }
                
                Text("Carrito")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                
                Spacer()
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing:0){
                    ForEach(homeData.cartItems){cart in
                        
                        HStack(spacing: 15){
                            WebImage(url: URL(string:cart.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(cart.item.item_name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                
                                Text(cart.item.item_details)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0))
                                    .lineLimit(2)
                                
                                HStack(spacing: 10){
                                    Text(homeData.getPrice(value: Float(truncating: cart.item.item_cost)))
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button(action: {
                                        if cart.quantity > 1 {homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity -= 1}
                                    }){
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                    }
                                    
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0))
                                        .padding(.vertical, 5)
                                        .padding(.horizontal,10)
                                        .background(Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0).opacity(0.06))
                                    
                                    Button(action: {
                                        homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity += 1
                                    }){
                                                
                                        Image(systemName: "plus")
                                            .font(.system(size: 16,weight: .heavy))
                                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                    }
                                }

                            }
                        }
                        .padding()
                        .contextMenu{
                            
                            Button(action: {
                                let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: false)
                                
                                homeData.items[itemIndex].isAdded = false
                                homeData.filtered[itemIndex].isAdded = false
                                
                                homeData.cartItems.remove(at: index)
                            }){
                                Text("Eliminar")
                                    .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255))
                            }
                            
                        }
                        
                        
                    }
                }
            }
            
            VStack{
                HStack{
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                    
                    Spacer()
                    
                    Text(homeData.calculateTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                }
                .padding([.top,.horizontal])
                
                Button(action: homeData.updateOrder){
                    
                    Text(homeData.ordered ? "Cancelar Orden": "Check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(
                            Color(red: 49/255.0, green: 67/255.0, blue: 65/255.0)
                        )
                        .cornerRadius(15)
                }
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

