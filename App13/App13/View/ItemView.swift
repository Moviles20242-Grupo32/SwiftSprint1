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
    var body: some View {
        VStack{
            
            HStack{
                
                WebImage(url: URL(string: item.item_image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 4){
                    Text(item.item_name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                    
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

