//
//  VoiceMemo.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import Foundation
import CoreData

struct VoiceMemo {
    let name: String
}

class LocalMemo: NSManagedObject {
    
    enum Keys: String {
        case name
    }
    
    class func saveMemo(from memo: VoiceMemo, in context: NSManagedObjectContext) -> Bool {
        let localMemo = LocalMemo(context: context)
        localMemo.name = memo.name
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchMemos(in context: NSManagedObjectContext) {
        context.perform {
            let request: NSFetchRequest<LocalMemo> = LocalMemo.fetchRequest()
            guard let results = try? context.fetch(request) else { return }
            printLog(results)
        }
    }
    
}
