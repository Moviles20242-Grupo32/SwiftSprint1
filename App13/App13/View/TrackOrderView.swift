//
//  TrackOrderView.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 12/11/24.
//

import SwiftUI
import MapKit

struct TrackOrderView: View {
    
    @State var camera: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(
        latitude: 4.603070289144005,
        longitude: -74.0649850505477), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    @State var latitude: Double = 4.603070289144005
    @State var longitude: Double = -74.0649850505477
    
    @Environment(\.presentationMode) var present
    @ObservedObject var locationViewModel = LocationViewModel.shared
    @StateObject var HomeModel = HomeViewModel.shared
    
    let foodie = CLLocationCoordinate2D( //example
        latitude: 4.605642247058096,
        longitude: -74.06685186800394)
    
    var body: some View {
        
        if HomeModel.items.isEmpty {
            
            HStack{
                Button(action: {present.wrappedValue.dismiss()}){
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 35, weight: .heavy))
                        .foregroundStyle(.white, .orange)
                }
                Spacer()
                    .frame(width: 300)
            }
            
            Spacer()
            
            Text("Debe contar con conexión a internet para que la App funcione correctamente")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                .padding()
            
            ProgressView()
            
            Spacer()
        }
        else {
            Map(position: $camera) {
                
                Annotation("Tú", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)){
                    Image(systemName: "figure.wave.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color(red: 69/255.0, green: 39/255.0, blue: 13/255.0))
                    
                }
                
                if HomeModel.areThereActiveOrders {
                    Annotation("Foodie", coordinate: foodie){
                        Image(systemName: "bicycle.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.white, Color.orange)
                        
                    }
                }

            }
            .onAppear {
                updateRegion()
            }
            .onChange(of: locationViewModel.userLocation) {
                updateRegion()
            }
            .safeAreaInset(edge: .bottom){
                HStack {
                    Spacer()
                    Button {
                        camera = .automatic
                    } label: {
                        HStack {
                            Image(systemName: "location.circle")
                            Text("Recenter")
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                .background(.ultraThinMaterial)
            }
            .safeAreaInset(edge: .top){
                HStack{
                    Button(action: {present.wrappedValue.dismiss()}){
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundStyle(.white, .orange)
                    }
                    Spacer()
                        .frame(width: 300)
                }
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func updateRegion() {
        if (locationViewModel.latitude != nil),
           (locationViewModel.longitude != nil) {
            latitude = locationViewModel.latitude ?? 4.603070289144005
            longitude = locationViewModel.longitude ?? -74.0649850505477
            camera = .automatic
        }
    }
}

#Preview {
    TrackOrderView()
}
