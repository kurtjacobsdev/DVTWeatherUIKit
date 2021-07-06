//
//  GPSService.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation
import CoreLocation

protocol GPSServiceProtocol {
    var locationDidUpdateObservable: ObserverSet<(CLAuthorizationStatus?, CLLocation?)> { get set }
    var locationAuthDidUpdateObservable: ObserverSet<CLAuthorizationStatus?> { get set }
    var locationStatus: CLAuthorizationStatus? { get set }
    var lastLocation: CLLocation? { get set }
    
    func refreshLocation()
}

class GPSService: NSObject, CLLocationManagerDelegate, GPSServiceProtocol {

    private let locationManager = CLLocationManager()
    var locationStatus: CLAuthorizationStatus?
    var lastLocation: CLLocation?
    var locationDidUpdateObservable: ObserverSet<(CLAuthorizationStatus?, CLLocation?)> = ObserverSet<(CLAuthorizationStatus?, CLLocation?)>()
    var locationAuthDidUpdateObservable: ObserverSet<CLAuthorizationStatus?> = ObserverSet<CLAuthorizationStatus?>()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func refreshLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        locationAuthDidUpdateObservable.notify(locationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        locationManager.stopUpdatingLocation()
        locationDidUpdateObservable.notify((locationStatus, lastLocation))
    }
}
