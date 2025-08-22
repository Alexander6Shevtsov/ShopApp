//
//  RegistrationViewModelTests.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 22.08.2025.
//

import XCTest
@testable import ShopApp

final class RegistrationViewModelTests: XCTestCase {
    func test_register_success_setsSession_and_callsOnSuccess() {
        let store = InMemorySessionStore()
        let viewModel = RegistrationViewModel(sessionStore: store)
        viewModel.firstName = "Alex"
        viewModel.lastName = "Ivanov"
        viewModel.password = "Qwerty1"
        viewModel.confirmPassword = "Qwerty1"
        
        let called = expectation(description: "onSuccess")
        viewModel.onSuccess = { called.fulfill() }
        
        viewModel.register()
        
        XCTAssertTrue(store.isRegistered)
        XCTAssertEqual(store.userName, "Alex")
        wait(for: [called], timeout: 0.2)
    }
}
