//
//  CleanyModal_Tests.swift
//  CleanyModal_Tests
//
//  Created by Lory Huz on 30/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import CleanyModal

class CleanyModal_Tests: XCTestCase {
    
    func testBasicAlert() {
        let title = "Hello world"
        
        let alert = CleanyAlertViewController(title: title, message: "a test message")
        
        XCTAssertTrue(alert.dataSource.title == title)
        XCTAssertTrue(alert.dataSource.message != "another test message")
        
        XCTAssertTrue(alert.textFields?.count == 0 || alert.textFields == nil)
        alert.addTextField()
        XCTAssertTrue(alert.textFields?.count == 1)
    }
    
}
