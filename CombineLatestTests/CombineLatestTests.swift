//
//  CombineLatestTests.swift
//  CombineLatestTests
//
//  Created by Darshan on 06/04/23.
//

import XCTest
@testable import CombineLatest

final class CombineLatestTests: XCTestCase {
    
    func testEmailvalidation(){
        let viewmodel = LogInViewModel.shared
        XCTAssertTrue(viewmodel.isValidEmail("test@mail.com"))
    }
}
