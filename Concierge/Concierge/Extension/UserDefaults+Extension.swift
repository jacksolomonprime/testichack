//
//  UserDefaults+Extension.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import Foundation
import CoreLocation

extension UserDefaults {
    static let defaults = UserDefaults.standard
    
    //Keys
    static let LAST_LOCATION: String = "last_location"
    static let PHONE_NUMBER: String = "phone_number"
    static let DESTINATION_LONG: String = "destination_long"
    static let DESTINATION_LAT: String = "destination_lat"
    static let ORIGIN_LONG: String = "origin_long"
    static let ORIGIN_LAT: String = "origin_lat"

    static func saveLastLocation(location: CLLocation) {
        if let encodedLocation = try? NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: false) {
            defaults.set(encodedLocation, forKey: self.LAST_LOCATION)
        }
    }
    
    static func getLastLocation() -> CLLocation? {
        if let loadedLocation = defaults.data(forKey: self.LAST_LOCATION),
           let decodedLocation = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedLocation) as? CLLocation {
            return decodedLocation
        }
        return nil
    }
    
    static func savePhoneNumber(number: String) {
        defaults.set(number, forKey: PHONE_NUMBER)
    }
    
    static func getPhoneNumber() -> String? {
        defaults.string(forKey: PHONE_NUMBER)
    }
    
    static func saveLocations(originLat: CLLocationDegrees?, originLong: CLLocationDegrees?,
                                        destinationLat: CLLocationDegrees?, destinationLong: CLLocationDegrees?) {
        defaults.set(originLat, forKey: ORIGIN_LAT)
        defaults.set(originLong, forKey: ORIGIN_LONG)
        defaults.set(destinationLat, forKey: DESTINATION_LAT)
        defaults.set(destinationLong, forKey: DESTINATION_LONG)
    }
    
    static func getDestination() -> (CLLocationDegrees?, CLLocationDegrees?) {
        return (defaults.object(forKey: DESTINATION_LAT) as? CLLocationDegrees, defaults.object(forKey: DESTINATION_LONG) as? CLLocationDegrees)
    }
    
    static func getOrigin() -> (CLLocationDegrees?, CLLocationDegrees?) {
        return (defaults.object(forKey: ORIGIN_LAT) as? CLLocationDegrees, defaults.object(forKey: ORIGIN_LONG) as? CLLocationDegrees)
    }
}
