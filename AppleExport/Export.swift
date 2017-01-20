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

    func getPlaylist() -> MPMediaItemCollection {
        
        let localstore = UserDefaults.standard
        let playlistId = localstore.string(forKey: "playlist")
        var playlistreturn: MPMediaItemCollection?
        
        if let playlist = localstore.string(forKey: "playlist") {
            let query = MPMediaQuery.playlists()
            let items = query.collections
            
            for item in items! {
                
                let stringID: String = String(describing: item.persistentID)
                let playlistid: String = String(describing: playlist)
                
                NSLog("Store: \(stringID) Library: \(playlistid)")
                
                if(stringID == playlist) {
                    NSLog("Playlist found in settings: \(item.value(forProperty: MPMediaPlaylistPropertyName))")
                    playlistreturn = item
                } else {
                    // NSLog("not equal - \(String(item.persistentID) == playlist))")
                    //NSLog(item.description)
                    //NSLog(String(item.persistentID))
                    ///NSLog("local store: \(playlist)")
                }
            }
        } else {
            NSLog("no playlist in local storage")
        }
        return playlistreturn!
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
    
    func addTrack(playlist: MPMediaPlaylist, track: String) -> Bool {
        
        var status = false
        playlist.addItem(withProductID: track) { error in
            if error != nil {
                print("error writing track \(error)")
                
            } else {
                print("Added track to playlist")
                status = true
            }
        }
        print("playlist writing done \(playlist.persistentID)")
        return status
    }
}