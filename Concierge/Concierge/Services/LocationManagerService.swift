//
//  LocationManagerService.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import CoreLocation
import Combine

class LocationManagerService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared: LocationManagerService = LocationManagerService()
    
    var locationManager: CLLocationManager = CLLocationManager()
        
    //MARK: Initialization
    //Request authorization and start tracking
    override init() {
        super.init()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: Monitor updates
    public func startMonitoringChanges() {
        //Check that the device supports monitoring
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() { return }
        
        //Start monitoring location
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func stopMonitoringChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        //We should make an API call
        if UserDefaults.getDestination().0 != nil && UserDefaults.getOrigin().0 != nil {
            //Check that the data is more than a minute old
            let previousLocation = UserDefaults.getLastLocation()
            let currentLocation = locations.last!

            if previousLocation != nil {
                let secondsDiff = currentLocation.timestamp.secondsSince(date: previousLocation!.timestamp)
                print("Seconds is \(secondsDiff)")
                if secondsDiff < 45.0 { return }
            }
            
            UserDefaults.saveLastLocation(location: currentLocation)

            APIManagerService.shared.makeAPICall(originLat: currentLocation.coordinate.latitude, originLong: currentLocation.coordinate.longitude, destinationLat: UserDefaults.getDestination().0!, destinationLong: UserDefaults.getDestination().1!, speed: Float(currentLocation.speed))
            print("Last location JUST received: \(currentLocation)")
        }
    }
    
    //MARK: Error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            //Location updates are not authorized.
            self.stopMonitoringChanges()
            print("Error updating locations. Monitoring has been disabled.")
            return
        }
    }
}
