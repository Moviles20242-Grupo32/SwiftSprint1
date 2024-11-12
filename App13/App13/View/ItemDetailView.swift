//
//  Untitled.swift
//  App13
//
//  Created by Daniela Uribe on 7/11/24.
//

import SwiftUI

struct ItemDetailView: View {
    let item: Item  // Replace `Item` with the actual type of your item model
    @StateObject var homeData = HomeViewModel.shared // Make sure to pass your view model when initializing this view
    @Environment(\.presentationMode) var present
    
    var body: some View {
        
        VStack{
            
            HStack{
                Button(action: {present.wrappedValue.dismiss()}){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.orange)
                }.padding()
                
                Spacer()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Item Name
                    Text(item.item_name)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.darkBrown)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Item Rating
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: "star.fill")
                                .foregroundColor(index <= (Int(item.item_ratings) ?? 0) ? Color.orange : Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Item Image
                    CacheAsyncImage(url: URL(string: item.item_image)!) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .clipped()
                                .frame(maxWidth: .infinity, alignment: .center)
                        case .failure(_):
                            Image(systemName: "xmark.octagon")
                                .frame(width: 150, height: 150)
                                .foregroundColor(.red)
                        case .empty:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                .frame(width: 150, height: 150)
                        @unknown default:
                            Image(systemName: "questionmark")
                        }
                    }
                    
                    // Item Cost
                    Text("$\(item.item_cost)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.darkBrown)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Item Details - "Posible contenido"
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Posible contenido")
                            .font(.headline)
                            .foregroundColor(Color.darkGreen)
                        Text(item.item_details)
                            .font(.body)
                            .foregroundColor(Color.lightBrown)
                    }
                    
                    // Divider
                    Divider()
                        .padding(.vertical)
                    
                    // Item Ingredients
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ingredientes")
                            .font(.headline)
                            .foregroundColor(Color.definedOrange)
                        Text(item.item_ingredients)
                            .font(.body)
                            .foregroundColor(Color.lightBrown)
                    }
                    
                    // Star Products
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Productos estrella")
                            .font(.headline)
                            .foregroundColor(Color.definedOrange)
                        Text(item.item_starProducts)
                            .font(.body)
                            .foregroundColor(Color.lightBrown)
                    }
                    
                    // Add to Cart Button
                    HStack {
                        Spacer()  // Center-align the button
                        Button(action: {
                            let searchStartTime = Date().timeIntervalSince1970
                            homeData.addToCart(item: item)
                        }) {
                            Image(systemName: item.isAdded ? "checkmark" : "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(item.isAdded ? Color.darkGreen : Color.orange)
                                .clipShape(Circle())
                        }
                        Spacer()  // Center-align the button
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}



