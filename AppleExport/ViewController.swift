//
//  ViewController.swift
//  AppleExport
//
//  Created by BBC Test on 15/12/2016.
//  Copyright © 2016 Steven Sams. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class ViewController: UIViewController {
    
    
    @IBAction func createPlaylist() {
        let export = Export()
        let playlist = export.getPlaylist()
        
      /*  if(playlist == nil) {
            // no playlist, create one?
        } else {
            //show playlist
        }*/
    }
    
    @IBAction func openPlaylist() {
        //let iTunesPath = "https://itunes.apple.com/gb/playlist/my-bbc-music-playlist/idpl.f96eb1bdb34f4e779ee97f1a87b651c3"
        let iTunesPath = "https://itunes.apple.com/gb/playlist/my-bbc-music-playlist/idpl.6939409701285735539"
        let settingsUrl = NSURL(string: iTunesPath)
        UIApplication.shared.open(settingsUrl as! URL)
    }
    
    @IBAction func addTrack() {
        let export = Export()
        let playlist = export.getPlaylist()
        
        let utils = Utils()
        let track = utils.getRandomTrack()
        let status = export.addTrack(playlist: playlist as! MPMediaPlaylist, track: track)
        
        if(status == true) {
            NSLog("OK, added track \(track)")
        } else {
            NSLog("Not ok, no track added \(track)")
        }
    }
    
    /** Authentication **/
    
    @IBAction func authenticate() {
        self.processAuthorisation()
    }
    
    func processAuthorisation() {
        if(self.isDeviceCapable()) {
            if(self.requestICloudAccess()) {
                if(self.isUKStorefront()) {
                    if(self.requestMediaLibraryAccess()) {
                        NSLog("authenticate success, finally!")
                        self.promptAuthSuccess()
                    }
                }
            }
        }
    }
    
    func requestICloudAccess() -> Bool {
        var capable = false
        SKCloudServiceController.requestAuthorization({
            (status: SKCloudServiceAuthorizationStatus) in
            switch status {
            case .authorized:
                print("SKCloud Authorisation authorized")
                capable = true
            case .denied:
                print("SKCloud Authorisation error")
                self.promptSettingsResticted()
            case .restricted:
                self.promptICloudAccessRequired()
                print("SKCloud Restricted \(status)")
            case .notDetermined:
                print("SKCloud Restricted \(status)")
            }
        })
        return capable
    }
    
    func isUKStorefront() -> Bool {
        return true
    }
    
    func requestMediaLibraryAccess() -> Bool {
        
        var capable = false
        
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                print("MPMediaLibrary authorised")
                capable = true
            } else {
                switch MPMediaLibrary.authorizationStatus() {
                case .restricted:
                    self.promptICloudAccessRequired()
                    print("Media library access restricted by corporate or parental settings - open icloud settings")
                case .denied:
                    print("Media library access denied by user - open appleexport settings screen")
                    self.promptSettingsResticted()
                default:
                    print("Unknown error")
                }
            }
        }
        return capable
    }
    
    
    func isDeviceCapable() -> Bool {
        
        var capable = false
        SKCloudServiceController().requestCapabilities { capabilities, error in
            if error != nil {
                NSLog("SKCloudServiceController Capabilities error")
                
            } else if capabilities.contains(SKCloudServiceCapability.addToCloudMusicLibrary) {
                //https://developer.xamarin.com/api/field/StoreKit.SKCloudServiceCapability.AddToCloudMusicLibrary/
                NSLog("SKCloud Capabilities success: User 'is capable' of writing to their Apple Music Library")
                capable = true
            } /*else if (capabilities & SKCloudServiceCapabilityMusicCatalogPlayback) {
                 // http://stackoverflow.com/questions/37613889/apple-music-detect-is-member
                 // https://developer.xamarin.com/api/type/StoreKit.SKCloudServiceAuthorizationStatus/
             } */ else if capabilities.rawValue == 2 {
                
                //if 2 = register with apple music - restricted
                //if 1 = sharing disabled - shazam
                self.promptAppleMusicSubscriptionNeeded()
            } else if capabilities.rawValue == 1 {
                self.promptICloudAccessRequired()
            } else {
                NSLog("SKCloud Capabilities cannot write tracks: \(capabilities)")
            }
        }
        return capable
    }
    
    
    /* user prompts */
    
    func exportSuccess(count: Int){
        let alertController = UIAlertController(title: "Export Complete", message: "\(count) tracks added to your Apple Music Library", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    func promptAuthSuccess() {
        let alertController = UIAlertController(title: "Authorisation Success", message: "You're authorised!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func promptAppleMusicSubscriptionNeeded() {
        let alertController = UIAlertController(title: "No Apple Music Subscription", message: "Please register with Apple Music", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func promptICloudAccessRequired() {
        let alertController = UIAlertController(title: "iCloud Access Required", message: "Exporting tracks to Apple Music requires the 'iCloud Music Library' setting in Settings > Music to be enabled", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func promptICloudResticted() {
        let alertController = UIAlertController(title: "iCloud Access Required", message: "iCloud setup required. Go to Settings > iCloud and enable", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func promptSettingsResticted() {
        
        let alertController = UIAlertController(title: "Settings Restricted",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) { (alertAction) in
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings as URL)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

