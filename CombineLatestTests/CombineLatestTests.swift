//
//  CombineLatestTests.swift
//  CombineLatestTests
//
//  Created by Darshan on 11/04/23.
//

import XCTest
@testable import CombineLatest

final class CombineLatestTests: XCTestCase {

    var viewmodel = LogInViewModel.shared
    
    func updateWithSuccessData(){
        self.reset()
        viewmodel.updateEmail(txtEmail: "darshan@mail.com")
        viewmodel.updatePassword(txtPassword: "panchal236")
    }
    func reset(){
        viewmodel.updateEmail(txtEmail: "")
        viewmodel.updatePassword(txtPassword: "")
    }
    func testUserLogInRequest() throws{
        let request = SignInRequest.init(username: "kminchelle", password: "0lelplR")
        let expectation = self.expectation(description: "login_success_api")
        SignInDataResource().dataRequest(request: request) { result in
            expectation.fulfill()
            switch result{
                case .success(let result):
                print("------ \(result?.email ?? "")")
                XCTAssertEqual(result?.email ?? "", "kminchelle@qq.com")
                case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.wait(for: [expectation], timeout: 3.0)
    }
    func testUser_Success_LogIn_API() throws {
        
            self.updateWithSuccessData()
        
            let expectation = self.expectation(description: "login_success_api")

            viewmodel.userLoginRequest { result in
                        switch result{
                            case .success(let user):
                                print(user.id)
                                print(user.email)
                                XCTAssertEqual(user.email ?? "", "darshan@mail.com")
                            case .failure(let error):
                                print(error.localizedDescription)
                        }
                expectation.fulfill()
            }
            self.wait(for: [expectation], timeout: 15)
    }
    func testUser_Fail_LogIn_API() throws {
            self.reset()
            let expectation = self.expectation(description: "login_fail_api")
            viewmodel.userLoginRequest { result in
                    switch result{
                        case .success(let user):
                            print(user.id)
                            print(user.email)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 15)
    }

}
