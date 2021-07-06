//
//  GPSServiceMock.swift
//  DVTWeatherUIKitTests
//
//  Created by Kurt Jacobs
//

import Foundation
import CoreLocation
@testable import DVTWeatherUIKit

class GPSServiceMock: GPSServiceProtocol {
    var locationDidUpdateObservable: ObserverSet<(CLAuthorizationStatus?, CLLocation?)>
    var locationAuthDidUpdateObservable: ObserverSet<CLAuthorizationStatus?>
    
    var locationStatus: CLAuthorizationStatus?
    var lastLocation: CLLocation?
    
    private var mockAuthStatus: CLAuthorizationStatus
    
    init(status: CLAuthorizationStatus) {
        mockAuthStatus = status
        locationDidUpdateObservable = ObserverSet<(CLAuthorizationStatus?, CLLocation?)>()
        locationAuthDidUpdateObservable = ObserverSet<CLAuthorizationStatus?>()
    }
    
    func refreshLocation() {
        let location = CLLocation(latitude: CLLocationDegrees(22), longitude: CLLocationDegrees(22))
        locationStatus = mockAuthStatus
        lastLocation = location
        locationAuthDidUpdateObservable.notify(mockAuthStatus)
        locationDidUpdateObservable.notify((mockAuthStatus, location))
    }
}
