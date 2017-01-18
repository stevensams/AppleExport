//
//  Export.swift
//  AppleExport
//
//  Created by BBC Test on 15/12/2016.
//  Copyright © 2016 Steven Sams. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class Export: NSObject {

    /*
    func authorise()
    {
        SKCloudServiceController.requestAuthorization({
            (status: SKCloudServiceAuthorizationStatus) in
            switch(status)
            {
            case .authorized: print("Access granted.")
            case .denied, .restricted: print("Access denied or restricted.")
            case .notDetermined: print("Access cannot be determined.")
            }
        })
        
        switch SKCloudServiceController.authorizationStatus()
        {
        case .authorized: print("Access granted.")
        case .notDetermined: print("Not determined") //requestAuthorization()
        case .denied, .restricted: print("Access denied or restricted.")
        }
        
        let controller = SKCloudServiceController()
        
      /*  controller.requestCapabilities(completionHandler: {
            (capabilities: SKCloudServiceCapability, error: NSError?) in
            if capabilities.contains(SKCloudServiceCapability.musicCatalogPlayback)
            {
                print("The device allows playback of Apple Music catalog tracks.")
            }
        } as! (SKCloudServiceCapability, Error?) -> Void)
        */
        controller.requestCapabilities(completionHandler: {
            (capabilities: SKCloudServiceCapability, error: NSError?) in
            if capabilities.contains(SKCloudServiceCapability.addToCloudMusicLibrary)
            {
                print("The device allows tracks to be added to the user’s music library.")
            } else {
                print("capabilities \(capabilities)")
            }
        } as! (SKCloudServiceCapability, Error?) -> Void)
    }
    */
    func authorise() {
        
       // var error = false
        
        SKCloudServiceController.requestAuthorization({
            (status: SKCloudServiceAuthorizationStatus) in
            switch status {
            case .denied:
                DispatchQueue.main.async {
                    print("SKCloud Authorisation error")
                    //error = true
                }
            case .restricted:
                print("SKCloud Restricted \(status)")
                // Access to iCloud restricted
            default:
                print("SKCloud Authorisation success")
                break
            }
        })
        
        switch SKCloudServiceController.authorizationStatus()
        {
        case .authorized: checkCapabilities()
        case .notDetermined: print("not determined")//checkCapabilities()
        case .denied, .restricted: print("restricted")//checkCapabilities()
        }
        
        /*
        
        let controller = SKCloudServiceController()
        controller.requestCapabilities(completionHandler: {
            (capabilities: SKCloudServiceCapability, error: NSError?) in
            if capabilities.contains(SKCloudServiceCapability.addToCloudMusicLibrary)
            {
                print("The device allows addToCloudMusicLibrary.")
            }
        } as! (SKCloudServiceCapability, Error?) -> Void)
        */
        /*
         func iCloudAuthStatus() {
         switch SKCloudServiceController.authorizationStatus()
         {
         case .authorized: print("authorized")
         case .notDetermined:
         requestICloudAccess()
         break
         case .restricted: print("restricted")//checkCapabilities()
         case .denied: print("restricted")//checkCapabilities()
         }
         }
         
         func requestICloudAccess() {
         SKCloudServiceController.requestAuthorization({
         (status: SKCloudServiceAuthorizationStatus) in
         switch status {
         case .denied:
         print("SKCloud Authorisation error")
         case .restricted:
         print("SKCloud Restricted \(status)")
         // Access to iCloud restricted
         default:
         print("SKCloud Authorisation success")
         break
         }
         })
         }
         */
        
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                print("MPMediaLibrary authorised")
                self.runMediaLibraryQuery()
            } else {
                switch MPMediaLibrary.authorizationStatus() {
                case .restricted:
                    print("Media library access restricted by corporate or parental settings")
                case .denied:
                    print("Media library access denied by user")
                default:
                    print("Unknown error")
                }
            }
        }
        
        
       // let player = MPMusicPlayerController.systemMusicPlayer()
       // player.setQueueWithStoreIDs(<#T##storeIDs: [String]##[String]#>)
        
 
       // return error
    }
    
    func runMediaLibraryQuery() {
        let query = MPMediaQuery.songs()
        if let items = query.items, let item = items.first {
            print("Title: \(item.title)")
        }
    }
    
    func checkCapabilities() {
        
        
        SKCloudServiceController().requestCapabilities { capabilities, error in
            if error != nil {
              
                    print("SKCloud Capabilities error")
                    //error = true
                
            } else if capabilities.contains(SKCloudServiceCapability.addToCloudMusicLibrary) {
                //https://developer.xamarin.com/api/field/StoreKit.SKCloudServiceCapability.AddToCloudMusicLibrary/
                print("SKCloud Capabilities success: \(capabilities)")
            } else {
                // if 2 = register with apple music - restricted
                //if 1 = sharing disabled - shazam
                
                print("SKCloud Capabilities cannot write tracks: \(capabilities)")
            }
        }
        
    }
    
    func addTrack(productID: String) {
        
        
    }
    
    func getPlaylist(playlistID: String) {
     //   MPMusicPlayerController.
    }
    
    func createPlaylist() {
        
        let library = MPMediaLibrary.default()
        let metadata = MPMediaPlaylistCreationMetadata(name: "My BBC Music Playlist")
        metadata.descriptionText = "Exported on DATE"
        metadata.authorDisplayName = "BBC Music"
        
        library.getPlaylist(with: UUID(), creationMetadata: metadata) { playlist, error in
            if error != nil {
                DispatchQueue.main.async {
                    print("Error writing playlist")
                }
                return
            } else {
                let delayTime = DispatchTime.now() + Double(Int64(5.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                /* We need to wait ~5 seconds for a new playlist to be ready for adding tracks
                 https://forums.developer.apple.com/message/140472#140472
                 */
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    
                    print("Playlist written \(playlist?.persistentID)")
                    
                    ///
                    /*
                     playlist?.addItem(withProductID: "712325420") { error in
                        if error != nil {
                            print("error writing track \(error)")
                            return
                        } else {
                            print("Added track to playlist")
                        }
                     }
                     */
                    
                    ///
                    
                    //playlist
                    
                }
                
            }
        }
    }
    
    func addTracktoPlaylist() {
        let player = MPMusicPlayerController.systemMusicPlayer()
        player.setQueueWithStoreIDs(["401187150"])
        player.play()
        
       // let library = MPMediaLibrary.default()
       // let metadata = MPMediaPlaylistCreationMetadata(name: "My BBC Music Playlist")
        
       // library.getPlaylist(with: <#T##UUID#>, creationMetadata: <#T##MPMediaPlaylistCreationMetadata?#>, completionHandler: <#T##(MPMediaPlaylist?, Error?) -> Void#>)
       
    }
}
