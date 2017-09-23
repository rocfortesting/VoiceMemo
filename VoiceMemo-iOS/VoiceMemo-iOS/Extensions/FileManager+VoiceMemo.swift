//
//  FileManager+VoiceMemo.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import Foundation

extension FileManager {
    
    class func generateURLForRecordingCache() -> URL {
        let temporaryPath = URL(fileURLWithPath: NSTemporaryDirectory())
        let name = Date().voiceMemoBasicTimeString + ".m4a"
        let fileURL = temporaryPath.appendingPathComponent(name)
        
        printLog(fileURL)
        
        return fileURL
    }
    
    class func generateURLForRecording() -> (name: String, url: URL) {
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let name = Date().voiceMemoBasicTimeString + ".m4a"
            let fileURL = url.appendingPathComponent(name)
            return (name, fileURL)
        } catch {
            fatalError("Can't Generate URL")
        }
    }
    
    class func generateURLForPlaying(name: String) -> URL {
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return url.appendingPathComponent(name)
        } catch {
            fatalError("Can't Generate URL")
        }
    }
    
}
