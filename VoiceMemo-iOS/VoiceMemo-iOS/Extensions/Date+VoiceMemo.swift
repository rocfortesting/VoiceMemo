//
//  Date+VoiceMemo.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import Foundation


// MARK: - Date Formatter

private let voiceMemoBasicDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd-HH:mm:ss:SS"
    let timeZone = TimeZone(identifier: "Asia/Shanghai")
    formatter.timeZone = timeZone
    
    return formatter
}()


// MARK: - Date Extension

extension Date {
    
    var voiceMemoBasicTimeString: String {
        return voiceMemoBasicDateFormatter.string(from: self)
    }
    
}
