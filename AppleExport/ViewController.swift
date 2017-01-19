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
    
    let iTunesTracks:[String] = ["695543530","324212499","585972803","1173028439","1050244131","264373418","159363080","269864994","300972325","388127880","257541624","419770556","725824503","398138385","659741383","401572692","59081939","429945616","1095449161","429945814","1173106804","1104984917","704273366","1171369368","1131561770","640369648","1160747530","714632733","388127922","1135984045","1109473878","388128572","580708180","7593728","1174605458","611387719","714861225","1175357008","928248075","1153701506","1137330136","1132115989","1051333363","14193723","1179447252","1168957626","1169385965","712325420","388128567","1174559876","1168039947","1156443908","14193705","1150317110","1170657803","1171368622","1169246072","1164046335","1155229943","1178024930","1123546970","1179022952","15466647","206627085","329519371","1133221371","14976844","724391063","1171239668","891452599","681348468","929802289","1152499331","867694916","963510673","296790657","1154504662","1079131941","1064886123","1165164775","29215363","1138293961","692299824","1160511318","1100287328","7668336","1151464059","941830995","1160511315","1151197755","1097758930","1152996330"]
    
    
    @IBAction func authenticate() {
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
    
    @IBAction func createPlaylist() {
        self.constructPlaylist()
    }
    
    @IBAction func addTrack() {
        
        /*
        for trackId in self.iTunesTracks {
            playlist?.addItem(withProductID: trackId) { error in
                if error != nil {
                    print("error writing track \(error)")
                    return
                } else {
                    NSLOG("Added track to playlist")
                }
            }
        }
        NSLOG("playlist writing done \(playlist?.persistentID)")
        
        self.exportSuccess(count: self.iTunesTracks.count)
        */
    }
    
    @IBAction func openPlaylist() {

        //let iTunesPath = "https://itunes.apple.com/gb/playlist/my-bbc-music-playlist/idpl.f96eb1bdb34f4e779ee97f1a87b651c3"
       // let iTunesPath = "https://itunes.apple.com/gb/playlist/my-bbc-music-playlist/idpl.6939409701285735539"
       // let settingsUrl = NSURL(string: iTunesPath)
       // UIApplication.shared.open(settingsUrl as! URL)
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
                // concerned with playback
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
    
    func clearPrefs() {
     
        let localstore = UserDefaults.standard
        localstore.removeObject(forKey: "playlist")
        localstore.synchronize()
        NSLog("playlist removed")
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
                //break
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
    
    func getPlaylist() -> MPMediaItemCollection {
        
        let localstore = UserDefaults.standard
        let playlistId = localstore.string(forKey: "playlist")
        var playlist: MPMediaItemCollection?
        
        if (playlistId != nil) {
        
            let predicate = MPMediaPropertyPredicate(value: playlistId, forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery()
            query.addFilterPredicate(predicate)
        
            if let items = query.collections, let item = items.first {
                
                playlist = items
                NSLog("Playlist IDs: \(playlistId) and \(item.persistentID)")
                NSLog("Playlist found in settings: \(item.value(forProperty: MPMediaPlaylistPropertyName))")
                NSLog("rep value: \(playlist.items)")
                NSLog("rep value: \(playlist.representativeItem)")
                returnPlaylist = playlist.representativeItem!
                
            } else {
                NSLog("no playlist found through predicate")
            }
        } else {
            NSLog("no playlist in local storage")
            self.constructPlaylist()
            return self.getPlaylist()
        }
        return playlist!
    }
    
    func constructPlaylist() {
        
        let localstore = UserDefaults.standard
        let library = MPMediaLibrary.default()
        let metadata = MPMediaPlaylistCreationMetadata(name: "My BBC Music Playlist")
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy HH:MM"
        let dateString = format.string(from: date)
        metadata.descriptionText = "Exported on \(dateString)"
        metadata.authorDisplayName = "BBC Music"
        
        library.getPlaylist(with: UUID(), creationMetadata: metadata) { playlist, error in
            if error != nil {
                DispatchQueue.main.async {
                    print("Error writing playlist")
                }
            } else {
                let delayTime = DispatchTime.now() + Double(Int64(5.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                /* We need to wait ~5 seconds for a new playlist to be ready for adding tracks
                 https://forums.developer.apple.com/message/140472#140472
                 */
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    
                    let stringID = playlist!.persistentID.description
                    localstore.set(stringID, forKey: "playlist")
                    localstore.synchronize()
                    NSLog("\(stringID) written")
                }
                
            }
        }
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
