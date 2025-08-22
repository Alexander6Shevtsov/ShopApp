//
//  Validation.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import Foundation

enum Validator {
    static func validateFirstName(_ firstName: String) -> String? {
        firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Введите имя" : nil
    }
    
    static func validateLastName(_ lastName: String) -> String? {
        let t = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.count < 2 ? "Фамилия минимум 2 символа" : nil
    }
}

enum PasswordValidator {
    static func validate(_ password: String) -> String? {
        let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasUpper = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        if !hasDigit { return "Пароль должен содержать цифру"}
        if !hasUpper { return "Пароль должен содержать заглавную букву"}
        return nil
    }
    
    static func confirm(_ password: String, _ confirm: String) -> String? {
        return password == confirm ? nil : "Пароли не совпадают"
    }
}
