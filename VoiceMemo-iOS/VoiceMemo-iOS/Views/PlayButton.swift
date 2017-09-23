//
//  PlayButton.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/23.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import UIKit

class PlayButton: VoiceMemoBasicButton {
    
    
    // MARK: Data Elements
    
    enum State {
        case tapToPlay
        case tapToStop
        
        var icon: UIImage {
            get {
                switch self {
                case .tapToPlay:
                    return .voiceMemoIconPlay
                case .tapToStop:
                    return .voiceMemoIconStop
                }
            }
        }
    }
    
    var state: State = .tapToPlay {
        didSet {
            iconImageView.image = state.icon
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                isUserInteractionEnabled = true
                alpha = 1
            } else {
                isUserInteractionEnabled = false
                alpha = 0.5
            }
        }
    }
    
    
    // MARK: Life-Cycle Methods
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        makeUI()
    }
    
    
    // MARK: Private Methods
    
    private func makeUI() {
        iconImageView.image = .voiceMemoIconPlay
    }
    
}
