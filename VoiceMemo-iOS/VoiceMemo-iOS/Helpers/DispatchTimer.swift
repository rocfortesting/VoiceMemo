//
//  DispatchTimer.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import Foundation

class DispatchTimer {
    
    private let timer: DispatchSourceTimer
    private var isRunning = false
    
    
    // MARK: Life-Cycle Methods
    
    init(with interval: DispatchTimeInterval, on queue: DispatchQueue, handler: @escaping (() -> Void)) {
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer.setEventHandler {
            handler()
        }
        timer.schedule(deadline: .now() + interval, repeating: interval)
    }
    
    deinit {
        if !isRunning {
            timer.cancel()
        }
    }
    
    
    // MARK: Public Methods
    
    func start() {
        if !isRunning {
            timer.resume()
            isRunning = true
        }
    }
    
    func stop() {
        if isRunning {
            timer.suspend()
            isRunning = false
        }
    }
}
