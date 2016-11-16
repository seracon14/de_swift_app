//
//  ViewController.swift
//  location2
//
//  Created by Sergio Contreras on 10/5/16.
//  Copyright © 2016 Sergio Contreras. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var hAccuracy: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var vAccuracy: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var spd: UILabel!
    var recording_now:Bool?
    
    
    var locationManager: CLLocationManager!
    var startLocation: CLLocation!
    var disBet: CLLocationDistance!
    var curdat: Date!
    var predat: Date!
    var fname: String!
    var myFileHandler: FileManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        predat = Date()  // get a time when app starts
        print(predat) // show this time
        recording_now = false // not recording yet
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter  = 0 // No filter for distance moved
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        startLocation = nil
        
    }

    @IBAction func record_button(_ sender: AnyObject) {
        
        if recording_now! {
            // was recording, stop
            locationManager.stopUpdatingLocation()
            recording_now = false
            print("Stopped Recording")
            clean_up()
            sender.setTitle("Start Recording", for: .normal)
        } else {
            //open up file
            
            var dat_name = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMM_dd_yyyy_HH_mm_ss"
            var convertedDate = dateFormatter.string(from: dat_name)
            
            
            // not recording, start
            locationManager.startUpdatingLocation()
            recording_now = true
            print("Started Recording")
            sender.setTitle("Stop Recording", for: .normal)
        }
    }
    
    @IBAction func resetDistance(_ sender: AnyObject) {
        startLocation = nil
        //print("Hello Swift")
    }
    
    func clean_up () {
        
        latitude.text = ""
        longitude.text = ""
        hAccuracy.text = ""
        altitude.text = ""
        vAccuracy.text = ""
        spd.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print("Update Location")
        
        // the last location
        //let latestLocation: AnyObject = locations[locations.count - 1]
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        // a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        
        // display the current date from GPS
        curdat = latestLocation.timestamp
        //print(curdat)
        
        // find and print how much time has passed since last legitimate time
        let elapsed = curdat.timeIntervalSince(predat)
        /*
        print("elapsed")
        print(elapsed)
        print(" ")
        */
        
        // only get new locations after two seconds
        if (elapsed>2) {
            
            //what was the horizontal distance?
            let hAstr = NSString(format: "%.6f", latestLocation.horizontalAccuracy)
            //print(hAstr)
            
            
            //if latestLocation.horizontalAccuracy<10 {
            if latestLocation.horizontalAccuracy<500 {
                
                print(" ")
                
                //print("accurate enough")
                predat=curdat;
                
                //dateFormatter.dateStyle = DateFormatter.Style.full
                //dateFormatter.dateStyle = DateFormatter.Style.medium
                //dateFormatter.dateStyle = DateFormatter.Style.long
                dateFormatter.dateStyle = DateFormatter.Style.short
                var convertedDate = dateFormatter.string(from: curdat)
                print(convertedDate)
                
                dateFormatter.dateFormat = "HH:mm:ss"
                convertedDate = dateFormatter.string(from: curdat)
                print(convertedDate)
                
                // Print out information
                let latstr = NSString(format: "%.6f", latestLocation.coordinate.latitude)
                print(latstr)
                let lonstr = NSString(format: "%.6f", latestLocation.coordinate.longitude)
                print(lonstr)
                //let hAstr = NSString(format: "%.6f", latestLocation.horizontalAccuracy)
                print(hAstr)
                let altstr = NSString(format: "%.6f", latestLocation.altitude)
                print(altstr)
                let vAstr = NSString(format: "%.6f", latestLocation.verticalAccuracy)
                print(vAstr)
                let spdstr = NSString(format: "%.6f", latestLocation.speed)
                print(spdstr)
                let crsstr = NSString(format: "%.6f", latestLocation.course)
                print(crsstr)
                
                //Print out strings
                latitude.text = String(format: "%.4f",
                                       latestLocation.coordinate.latitude)
                longitude.text = String(format: "%.4f",
                                        latestLocation.coordinate.longitude)
                hAccuracy.text = String(format: "%.4f",
                                        latestLocation.horizontalAccuracy)
                altitude.text = String(format: "%.4f",
                                       latestLocation.altitude)
                vAccuracy.text = String(format: "%.4f",
                                        latestLocation.verticalAccuracy)
                spd.text = String(format: "%.4f m/s", latestLocation.speed)
                
                
                
                
                // Distance so far
                if startLocation == nil {
                    disBet = 0
                } else {
                    disBet = latestLocation.distance(from: startLocation)
                    
                }
                
                distance.text = String(format: "%.2f m", disBet)
                
                let disstr = NSString(format: "%.2f", disBet)
                print(disstr)
                
                startLocation = latestLocation
                
            }
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        //let distanceBetween: CLLocationDistance =
        
        //  latestLocation.distance(startLocation)
        
        //distance.text = String(format: "%.2f", distanceBetween)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            //print("Authorized Always")
            //locationManager.startUpdatingLocation()
        }
    }
    



}

