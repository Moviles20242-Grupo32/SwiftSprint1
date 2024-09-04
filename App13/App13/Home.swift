//
//  Home.swift
//  App13
//
//  Created by Daniela Uribe on 28/08/24.
//

import SwiftUI
import AVFoundation

struct Home: View {
    @State private var synthesizer: AVSpeechSynthesizer?
    @StateObject var HomeModel = HomeViewModel()
    
    var body: some View {
        
        ZStack{
            VStack(spacing:10){
                
                HStack(spacing:15){
                    
                    Button(action: {
                        withAnimation(.easeIn){
                            HomeModel.showMenu.toggle()
                        }
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(Color(.orange))
                    })
                    
                    Button(action:{
                        
                        var elementsString: String {
                                HomeModel.filtered.map { $0.item_name }.joined(separator: " ")
                            }
                    
                        speak(elements: " " + elementsString)
                        
                        },
                        label: {
                        Image(systemName: "megaphone")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 15, height: 15)
                            .padding(15)
                            .background(Color.orange)
                            .clipShape(Circle())
                            
                    }).padding(20)
                    
                    Text(HomeModel.userLocation == nil ? "Localizando..." : "Dirección entrega")
                        .foregroundColor(.black)
                    
                    Text(HomeModel.userAdress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(.orange))
                    
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                }
                .padding([.horizontal,.top])
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    TextField("Buscar", text: $HomeModel.search)
    
                }
                .padding(.horizontal)
                .padding(.top,10)
                
                Divider()
                
            
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing:25){
                        ForEach(HomeModel.filtered){item in
                            HStack{
                                
                                ItemView(item: item)
                                    .padding(15)
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Button(action: {
                                    HomeModel.addToCart(item: item)
                                }, label: {
                                    Image(systemName: item.isAdded ? "checkmark" : "plus")
                                        .resizable()  // Make the image resizable
                                        .aspectRatio(contentMode: .fit)  // Maintain the aspect ratio
                                        .frame(width: 10, height: 10)  // Set the width and height
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(item.isAdded ? Color.green : Color.orange)
                                        .clipShape(Circle())
                                })
                            }
                            .padding(.trailing, 10)
                            .padding(.top, 10)
                        }
                    }
                    .padding(.top, 10)
                })
            }
            
            HStack{
                Menu(homeData: HomeModel)
                    .offset(x: HomeModel.showMenu ? 0: -UIScreen.main.bounds.width/1.6)
                Spacer(minLength: 0)
            }
            .background(Color.black.opacity(HomeModel.showMenu ? 0.3: 0).ignoresSafeArea())
            .onTapGesture(perform: {
                withAnimation(.easeIn){
                    HomeModel.showMenu.toggle()
                }
            })
            
            if HomeModel.noLocation{
                Text("Por favor active el acceso a su ubicación en configuración para continuar !!!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        .onAppear(perform: {
            HomeModel.locationManager.delegate = HomeModel
        })
        .onChange(of: HomeModel.search, perform:{ value in
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                
                if value == HomeModel.search && HomeModel.search != ""{
                    HomeModel.filterData()
                }
                
                if HomeModel.search == ""{
                    withAnimation(.linear) { HomeModel.filtered = HomeModel.items}
                }
            }
        })
    }
    
    func speak(elements: String) {
            
            let audioSession = AVAudioSession() // 2) handle audio session first, before trying to read the text
            do {
                try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
                try audioSession.setActive(false)
            } catch let error {
                print("❓", error.localizedDescription)
            }
            
            synthesizer = AVSpeechSynthesizer()
            
            let speechUtterance = AVSpeechUtterance(string: "Las cajas disponibles son " + elements)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
            
            synthesizer?.speak(speechUtterance)
        }
}


#Preview {
    Home(HomeModel: HomeViewModel())
}
