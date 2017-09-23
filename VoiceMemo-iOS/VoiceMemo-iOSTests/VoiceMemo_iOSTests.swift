//
//  VoiceMemo_iOSTests.swift
//  VoiceMemo-iOSTests
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import XCTest
import CoreData
@testable import VoiceMemo_iOS

class VoiceMemo_iOSTests: XCTestCase {
    
    var context: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        
        context = CoreDataManager.shared.persistentContainer.viewContext
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        _ = FileManager.generateURLForRecordingCache()
        _ = FileManager.generateURLForRecording()
        _ = FileManager.generateURLForPlaying(name: "Test")
        
        XCTAssertNotNil(context)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
