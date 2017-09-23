//
//  AudioManager.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject {
    
    static let shared = AudioManager()

    private static let audioFormat: [String: AnyObject] = [
        AVFormatIDKey: kAudioFormatMPEG4AAC as AnyObject,
        AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue as AnyObject,
        AVNumberOfChannelsKey: 2 as AnyObject,
        AVSampleRateKey: 44100.0 as AnyObject,
        AVEncoderBitDepthHintKey: 16 as AnyObject
    ]
    
    private let audioRecorder: AVAudioRecorder
    
    private var audioPlayer: AVAudioPlayer?
    
    private var recordingCompletion: ((_ success: Bool) -> Void)?
    
    private var playingCompletion: ((_ success: Bool) -> Void)?
    
    var currentRecoderString: String {
        get {
            let time = Int(audioRecorder.currentTime)
            let hour = time / 3600
            let minute = time % 3600 / 60
            let second = time % 60
            
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
    }
    
    var currentPlayerString: String {
        get {
            guard let audioPlayer = audioPlayer else { return "" }
            let time = Int(audioPlayer.currentTime)
            let hour = time / 3600
            let minute = time % 3600 / 60
            let second = time % 60
            
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
    }
    
    
    // MARK: Life-Cycle Methods
    
    private override init() {
        audioRecorder = try! AVAudioRecorder(url: FileManager.generateURLForRecordingCache(), settings: AudioManager.audioFormat)
        
        super.init()
        
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
    }
    
    
    // MARK: Record
    
    class func record() throws {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        } catch {
            printLog(error.localizedDescription)
            
            throw error
        }
        
        if shared.audioRecorder.isRecording {
            shared.audioRecorder.stop()
            shared.audioRecorder.deleteRecording()
        }
        
        shared.audioRecorder.record()
    }
    
    class func stopRecord(completion: @escaping ((_ success: Bool) -> Void)) {
        shared.recordingCompletion = completion
        shared.audioRecorder.stop()
    }
    
    class func saveRecordToDocument(completion: ((_ success: Bool, _ memo: VoiceMemo?) -> Void)) {
        let sourceURL = shared.audioRecorder.url
        let (name, desURL) = FileManager.generateURLForRecording()
        
        do {
            try FileManager.default.copyItem(at: sourceURL, to: desURL)
            let memo = VoiceMemo(name: name)
            completion(true, memo)
            
            shared.audioRecorder.prepareToRecord()
        } catch {
            printLog(error.localizedDescription)
            completion(false, nil)
        }
    }
    
    
    // MARK: Play
    
    class func play(with memo: VoiceMemo, completion: @escaping ((Bool) -> Void)) throws {
        if let player = shared.audioPlayer, player.isPlaying {
            player.stop()
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            let url = FileManager.generateURLForPlaying(name: memo.name)
            shared.audioPlayer = try AVAudioPlayer(contentsOf: url)
            shared.audioPlayer?.delegate = shared
            shared.playingCompletion = completion
            shared.audioPlayer?.play()
        } catch {
            throw error
        }
    }
    
    class func stopPlay() {
        guard let player = shared.audioPlayer, player.isPlaying else { return }
        player.stop()
        shared.playingCompletion?(false)
        shared.playingCompletion = nil
    }
    
}


// MARK: - AVAudioRecorderDelegate

extension AudioManager: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordingCompletion?(flag)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        printLog(error?.localizedDescription)
    }
    
}


// MARK: - AVAudioPlayerDelegate

extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playingCompletion?(true)
        playingCompletion = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        playingCompletion?(false)
        playingCompletion = nil
        printLog(error?.localizedDescription)
    }
    
}
