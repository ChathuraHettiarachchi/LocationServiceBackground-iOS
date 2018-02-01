//
//  BackgroundLocationService.swift
//  LocationTrackingBackgroundiOS
//
//  Created by Chathura Hettiarachchi on 2/1/18.
//  Copyright © 2018 Chathura Hettiarachchi. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocaitonUpdates {
    func locationUpdates(locaiton: CLLocation)
}

class BackgroundLocationService: NSObject, CLLocationManagerDelegate {
    
    public static var sharedInstance = BackgroundLocationService()
    
    let locationManager: CLLocationManager
    var timer: Timer!
    var delegate: LocaitonUpdates?
    
    override init() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        super.init()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if let newLocation = locations.last{
            //print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude))")
            self.delegate?.locationUpdates(locaiton: newLocation)
        }
        
//        locationManager.stopUpdatingLocation()
//        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
        
    }
    
    @objc func timerFired(){
        //timer.invalidate()
        locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingLocation()
            locationManager.startUpdatingLocation()
        }else{
            showTurnOnLocationServiceAlert()
        }
    }
    
    func stopUpdatingLocation(){
        //timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocationInBackground(){
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func showTurnOnLocationServiceAlert(){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
}
