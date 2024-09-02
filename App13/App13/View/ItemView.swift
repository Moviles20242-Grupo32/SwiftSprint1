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
                        .foregroundColor(.black)
                    
                    Text(item.item_details)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    HStack{
                        ForEach(1...5, id: \.self){ index in
                            Image(systemName: "star.fill")
                                .foregroundColor(index <= Int(item.item_ratings) ?? 0 ? Color(.orange): .gray)
                            }
                    }
                        
                }.padding(.leading, 0)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

