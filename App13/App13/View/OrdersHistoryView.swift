//
//  OrdersHistoryView.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 12/11/24.
//

import SwiftUI

struct OrdersHistoryView: View {
    
    @Environment(\.presentationMode) var present
    @StateObject var HomeModel = HomeViewModel.shared
    
    var body: some View {
        
        VStack {
            HStack{
                Button(action: {present.wrappedValue.dismiss()}){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.orange)
                }
                Spacer()
                    .frame(width: 300)
            }
            
            if HomeModel.activeOrders.isEmpty {
                
                Spacer()
                
                Text("No tienes pedidos en curso")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                    .padding()
                
                Text("¡Antojate y pide!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                    .padding()
                
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    .foregroundStyle(.orange)
                    .font(.system(size: 40))
                
                Spacer()
                
            }
            else{
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing:5){
                        ForEach(HomeModel.activeOrders){cart in
                            
                            VStack{
                                
                                HStack{
                                    
                                    CacheAsyncImage(url: URL(string: cart.item.item_image)!){ phase in
                                        switch phase {
                                        case .success(let image):
                                            HStack {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 100, height: 100)
                                                    .clipped()

                                            }
                                        case .failure(let error):
                                            Image(systemName: "xmark.octagon")
                                        case .empty:
                                            HStack {
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                                Spacer()
                                            }
                                        @unknown default:
                                            Image(systemName: "questionmark")
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 4){
                                        HStack{
                                            Text(cart.item.item_name)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                                        }
                                        
                                        Text(cart.item.item_details)
                                            .font(.caption)
                                            .foregroundColor(Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0))
                                            .lineLimit(2)
                                            
                                    }.padding(.leading, 0)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(red: 49/255.0, green: 67/255.0, blue: 65/255.0))
                                        .frame(width: 125, height: 25)
                                    
                                    NavigationLink(destination: {
                                        TrackOrderView()
                                    }, label: {
                                        Text("Ver en el mapa")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .bold()
                                    })
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            }
                            
                            
                        }
                    }
                    .padding(.top, 10)
                })
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


 #Preview {
 OrdersHistoryView()
 }

