//
//  ValidatorTests.swift
//  ValidatorTests
//
//  Created by Alexander Shevtsov on 17.08.2025.
//

import XCTest
@testable import ShopApp

final class ValidatorTests: XCTestCase {
    func test_firstName_empty_error() {
        XCTAssertEqual(Validator.validateFirstName(" "), "Введите имя")
    }
    func test_lastName_short_error() {
        XCTAssertEqual(Validator.validateLastName("А"), "Фамилия минимум 2 символа")
    }
    func test_password_rules_and_confirm() {
        XCTAssertEqual(PasswordValidator.validate("Qwerty"), "Пароль должен содержать цифру")
        XCTAssertEqual(PasswordValidator.validate("qwerty1"), "Пароль должен содержать заглавную букву")
        XCTAssertNil(PasswordValidator.validate("Qwerty1"))
        XCTAssertEqual(PasswordValidator.confirm("Qwerty1", "Qwerty2"), "Пароли не совпадают")
    }
}
