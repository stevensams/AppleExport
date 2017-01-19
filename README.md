# AppleExport
Swift Spike with Apple Music API

# Technical prerequisites

iOS 9.3 + only
StoreKit and MediaPlayer frameworks required 
NSAPPLEMUSICUSAGEDECRIPTION entry required in info.plist. More info http://iosdevcenters.blogspot.com/2016/09/infoplist-privacy-settings-in-ios-10.html

# Policy prerequisites

Apple Music Subscription (there’s no free-tier but there is a three month trial)

# Offical documentation

https://affiliate.itunes.apple.com/resources/documentation/apple-music-best-practices-for-app-developers/

# Apple API methods of interest

https://developer.apple.com/reference/mediaplayer/mpmedialibrary/1621273-getplaylist

https://developer.apple.com/reference/mediaplayer/mpmedialibrary#//apple_ref/occ/cl/MPMediaLibrary

https://developer.apple.com/reference/mediaplayer/mpmediaplaylist/1618706-additemwithproductid

https://developer.apple.com/reference/storekit/skcloudservicecontroller#//apple_ref/occ/cl/SKCloudServiceController

https://developer.apple.com/reference/storekit/skcloudservicecontroller/1620618-requeststorefrontidentifier

Authorisation guide with examples - https://developer.apple.com/library/content/qa/qa1929/_index.html

* Playback music controller - future reference only *
https://developer.apple.com/reference/mediaplayer/mpmusicplayercontroller

# Settings

Adding settings bundle (Required for opening music library (un)enable)

http://pinkstone.co.uk/how-to-link-directly-to-your-apps-settings-section/
https://github.com/phynet/SettingBundleiOSProject

Enhanced settings dialog example

https://www.natashatherobot.com/ios-taking-the-user-to-settings/

# Known pitfalls

Potential race condition issue with creating playlist and writing first track
http://stackoverflow.com/questions/36902854/error-when-using-mpmediaplaylist-additemwithproductidcompletionhandler

http://www.slideshare.net/takurohanawa/dive-into-apple-music-app

# Misc. forum finds 

https://forums.developer.apple.com/thread/45996

http://stackoverflow.com/questions/34236636/can-a-mpmediaentitypersistentid-be-cast-to-a-value-which-can-be-saved-to-nsuserd

http://stackoverflow.com/questions/34560513/ios-query-via-album-mpmediaentitypersistentid-sometimes-brings-back-no-songs

http://www.itgo.me/a/x7119407070591881420/can-a-mpmediaentitypersistentid-be-cast-to-a-value-which-can-be-saved-to-nsuserd

https://bendodson.com/weblog/2016/08/02/media-library-privacy-flaw-fixed-in-ios-10/

https://bendodson.com/weblog/2016/02/23/details-on-ios-9-3-media-library-additions/

# Older pre-Apple Music media library example code

https://developer.apple.com/library/content/documentation/Audio/Conceptual/iPodLibraryAccess_Guide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008765
