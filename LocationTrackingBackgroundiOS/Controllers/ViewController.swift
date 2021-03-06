//
//  ViewController.swift
//  LocationTrackingBackgroundiOS
//
//  Created by Chathura Hettiarachchi on 2/1/18.
//  Copyright © 2018 Chathura Hettiarachchi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, LocaitonUpdates {
    
    var locationService: BackgroundLocationService?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnEnd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationService = BackgroundLocationService()
        locationService?.delegate = self
        
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        Locations.init(timeStamp: "\(timestamp)", lat: "App opened", lan: "Buhahaha").save()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let defaults = UserDefaults.standard
//
//        let time = defaults.string(forKey: "TIM")
//        let lan = defaults.string(forKey: "LAN")
//        let lat = defaults.string(forKey: "LAT")
//
//        if let view = lblData, let t = time, let la = lan, let lt = lat {
//            view.text = "\nSaved Data\n\(String(describing: t))\nLat: \(String(describing: lt)) | Lan: \(String(describing: la))\n"
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
//        let defaults = UserDefaults.standard
//
//        let time = defaults.string(forKey: "TIM")
//        let lan = defaults.string(forKey: "LAN")
//        let lat = defaults.string(forKey: "LAT")
//
//        if let view = lblData, let t = time, let la = lan, let lt = lat {
//            view.text = "\nSaved Data\n\(String(describing: t))\nLat: \(String(describing: lt)) | Lan: \(String(describing: la))\n"
//        }
        
        self.tryToLoadFromDB()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onStartPressed(_ sender: Any) {
        locationService!.startUpdatingLocation()
    }
    
    @IBAction func onEndPressed(_ sender: Any) {
        locationService!.stopUpdatingLocation()
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        self.lblData.text = ""
        
        Locations.truncate()
    }
    
    @IBAction func onReloadPressed(_ sender: Any) {
        self.tryToLoadFromDB()
    }
    
    func tryToLoadFromDB() {
        self.lblData.text = ""
        if let data = Locations.all() as? [Locations], data.count > 0 {
            for d in data {
                if let time = d.timeStamp, let lt = d.lat, let ln = d.lan, let oldData = lblData.text {
                    self.lblData.text = "\(oldData)\n\n\(time)\nLat: \(lt) | Lan: \(ln)"
                }
            }
        }
    }
    
    func locationUpdates(locaiton: CLLocation) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        
        if let oldData = lblData.text {
            let lat = "\(locaiton.coordinate.latitude)"
            let lon = "\(locaiton.coordinate.longitude)"
            
            let newData = "\(oldData)\n\n\(timestamp)\nLat: \(lat) | Lan: \(lon)"
            let newData2 = "\n\(timestamp)\nLat: \(lat) | Lan: \(lon)"
            
            self.lblData.text = newData
            print("\(newData2)")
            
            //self.scrollView.scrollToBottom()
        }
    }
    
}

extension UIScrollView {
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}
