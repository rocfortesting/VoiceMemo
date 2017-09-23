//
//  PrintLog.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import Foundation

func printLog<T>(_ message: @autoclosure () -> T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent): \(line), `\(method)`:\n  \(message())")
    #endif
}
