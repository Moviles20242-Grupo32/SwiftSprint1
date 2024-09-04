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
        
        NavigationView{
            ZStack(alignment: .leading){
                VStack(spacing:10){
                    
                    HStack(spacing:15){
                        
                        // Carrito de compras
                        NavigationLink(destination: {
                            CartView(homeData: HomeViewModel())
                        }, label: {
                            Image(systemName: "cart")
                                .font(.title)
                                .foregroundColor(Color(.orange))
                        })
                        .padding(10)
                        
                        // Text to Speach
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
                                .frame(width: 20, height: 20)
                                .padding(13)
                                .background(Color(.orange))
                                .clipShape(Circle())
                            
                        }).padding(10)
                        
                        //Direccion domicilio
                        Text(HomeModel.userLocation == nil ? "Localizando..." : "Dirección entrega")
                            .foregroundColor(.black)
                            .frame(width: 110)
                        
                        Text(HomeModel.userAdress)
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(Color(.orange))
                        
                        
                        Spacer(minLength: 0)
                        
                        // Profile
                        NavigationLink(destination: {
                            ProfileView()
                        }, label: {
                            Image(systemName: "person.crop.circle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            
                        }).padding(10)
                        
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
                    
                    if HomeModel.items.isEmpty{
                        
                        Spacer()
                        
                        ProgressView()
                        
                        Spacer()
                        
                    }
                    else{
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
                    
                    
                }
                
                if HomeModel.noLocation{
                    Text("Por favor active el acceso a su ubicación en configuración para continuar !!!")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3).ignoresSafeArea())
                    
                    
                }
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        
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
        .environmentObject(AuthViewModel())
}
