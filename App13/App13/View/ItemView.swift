//
//  ItemView.swift
//  App13
//
//  Created by Daniela Uribe on 29/08/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemView: View {
    
    var item: Item
    var favoriteName: String
    var body: some View {
        VStack{
            
            HStack{
                
                CacheAsyncImage(url: URL(string: item.item_image)!){ phase in
                    switch phase {
                    case .success(let image):
                        HStack {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipped()
                            Spacer()
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
                        Text(item.item_name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                        
                        if favoriteName == item.item_name {
                            ZStack {
                                // Banner background
                                RoundedRectangle(cornerRadius: 10)  // Creates a rectangle with rounded corners
                                    .fill(Color(red: 49/255.0, green: 67/255.0, blue: 65/255.0))  // Fill color for the banner
                                    .frame(width: 70, height: 25)  // Adjust the banner size as needed
                                
                                // Text inside the banner
                                Text("Favorito")
                                    .font(.caption)  // Set the font size
                                    .foregroundColor(.white)  // Set the text color
                                    .bold()  // Make the text bold if desired
                                
                            }
                        }
                    }
                    
                    Text(item.item_details)
                        .font(.caption)
                        .foregroundColor(Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0))
                        .lineLimit(2)
                    
                    HStack{
                        ForEach(1...5, id: \.self){ index in
                            Image(systemName: "star.fill")
                                .foregroundColor(index <= Int(item.item_ratings) ?? 0 ? Color(.orange): Color(red: 143/255.0, green: 120/255.0, blue: 111/255.0))
                            }
                    }
                        
                }.padding(.leading, 0)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

