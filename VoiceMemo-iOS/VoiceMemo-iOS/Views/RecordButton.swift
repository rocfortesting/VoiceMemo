//
//  RecordButton.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import UIKit

class RecordButton: VoiceMemoBasicButton {
    
    // MARK: Touches Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        iconImageView.alpha = 0.5
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.iconImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        iconImageView.alpha = 1
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.iconImageView.transform = .identity
        }, completion: nil)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        iconImageView.alpha = 1
    }
    
    
    // MARK: Life-Cycle Methods
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        makeUI()
    }
    
    
    // MARK: Private Methods
    
    private func makeUI() {
        iconImageView.image = .voiceMemoIconRecord
    }
    
}
