//
//  Utils.swift
//  AppleExport
//
//  Created by BBC Test on 19/01/2017.
//  Copyright © 2017 Steven Sams. All rights reserved.
//

import Foundation


class Utils: NSObject {

let iTunesTracks:[String] = ["695543530","324212499","585972803","1173028439","1050244131","264373418","159363080","269864994","300972325","388127880","257541624","419770556","725824503","398138385","659741383","401572692","59081939","429945616","1095449161","429945814","1173106804","1104984917","704273366","1171369368","1131561770","640369648","1160747530","714632733","388127922","1135984045","1109473878","388128572","580708180","7593728","1174605458","611387719","714861225","1175357008","928248075","1153701506","1137330136","1132115989","1051333363","14193723","1179447252","1168957626","1169385965","712325420","388128567","1174559876","1168039947","1156443908","14193705","1150317110","1170657803","1171368622","1169246072","1164046335","1155229943","1178024930","1123546970","1179022952","15466647","206627085","329519371","1133221371","14976844","724391063","1171239668","891452599","681348468","929802289","1152499331","867694916","963510673","296790657","1154504662","1079131941","1064886123","1165164775","29215363","1138293961","692299824","1160511318","1100287328","7668336","1151464059","941830995","1160511315","1151197755","1097758930","1152996330", "1188240321","501581919","401136705","1037110849","1116740923","658898253","1192703100","1172814851","209945072","1170335527"]


    func getRandomTrack() -> String {
        let random = Int(arc4random_uniform(UInt32(iTunesTracks.count)))
        return iTunesTracks[random]
    }
    
    func storePreference() {
        let localstore = UserDefaults.standard
        localstore.removeObject(forKey: "playlist")
        localstore.synchronize()
        NSLog("playlist removed")
     }
    
    func getPreference() {
        let localstore = UserDefaults.standard
        localstore.removeObject(forKey: "playlist")
        localstore.synchronize()
        NSLog("playlist removed")
    }
    
    func clearPreferences() {
        let localstore = UserDefaults.standard
        localstore.removeObject(forKey: "playlist")
        localstore.synchronize()
        NSLog("playlist removed")
    }
}
