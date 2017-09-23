//
//  VoiceMemoBasicButton.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/23.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import UIKit

class VoiceMemoBasicButton: UIView {
    
    // MARK: Closures
    
    var touchesBeginAction: (() -> Void)?
    
    var touchesEndedAction: (() -> Void)?
    
    
    // MARK: UI Elements
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    
    // MARK: Touches Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        touchesBeginAction?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        touchesEndedAction?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        iconImageView.alpha = 1
    }
    
    
    // MARK: Life-Cycle Methods
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        makeUI()
        makeLayout()
    }
    
    
    // MARK: Private Methods
    
    private func makeUI() {
        addSubview(iconImageView)
    }
    
    private func makeLayout() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
}
