//
//  HomeView.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import SwiftUI

struct HomeView: View {
    @State private var phoneNumber: String = ""
    @FocusState private var keyboardOpen: Bool
    @StateObject private var locationModel = LocationSearchViewModel()
    @StateObject var userLocation = UserLocation.shared
    @State private var selectedLocation: LocationSearchResult? = nil

    var body: some View {
        ZStack{
            MapView(userLocation: userLocation)
            VStack{
                HStack{
                    Spacer()
                        .frame(width: 25)
                    TextField("Enter destination", text: $locationModel.searchTerm)
                        .frame(height: 60)
                        .focused($keyboardOpen)
                }.background(.white)
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    .padding(.top, 50)
                    .cornerRadius(20)
                
                List(locationModel.results) { mapItem in
                    VStack(alignment: .leading) {
                        Text(mapItem.title)
                        Text(mapItem.subtitle)
                            .foregroundColor(.secondary)
                    }.frame(height: 50)
                        .onTapGesture {
                            //Update selection
                            selectedLocation = mapItem
                            UserDefaults.saveLocations(originLat: userLocation.region.center.latitude, originLong: userLocation.region.center.longitude, destinationLat: mapItem.latitude, destinationLong: mapItem.longitude)
                            //Clear the view
                            keyboardOpen = false
                            locationModel.results = [LocationSearchResult]()
                        }
                }.listStyle(.plain)
                    .padding(.horizontal)
                
                Spacer()
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: selectedLocation == nil ? 0 : 200)
                    if selectedLocation != nil {
                        VStack(alignment: .leading){
                            Text("You'll get a call when you're nearly at:")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 2)
                            Text("\(selectedLocation!.title)")
                                .font(.system(size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button("Cancel") {
                                selectedLocation = nil
                                UserDefaults.saveLocations(originLat: nil, originLong: nil, destinationLat: nil, destinationLong: nil)
                            }
                            .padding()
                            .background(Color(red: 1, green: 0, blue: 0))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }.padding()
                    }
                }
            }
        }.edgesIgnoringSafeArea([.top])
    }
}
