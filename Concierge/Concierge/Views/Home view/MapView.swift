//
//  MapView.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var userLocation = UserLocation.shared

    var body: some View {
        ZStack{
            Map(coordinateRegion: $userLocation.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.4)
        }
    }
}
