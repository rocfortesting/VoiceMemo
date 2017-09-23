//
//  AccessChecker.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import Foundation
import AVFoundation

class AccessChecker {
    
    class func canAccessMicrophone(action: @escaping ((Bool) -> Void)) {
        AVAudioSession.sharedInstance().requestRecordPermission { (access) in
            DispatchQueue.main.async {
                action(access)
            }
        }
    }
    
}
