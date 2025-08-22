//
//  Validation.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import Foundation

enum Validator {
    static func validateFirstName(_ s: String) -> String? {
        s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Введите имя" : nil
    }
    
    static func validateLastName(_ s: String) -> String? {
        let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.count < 2 ? "Фамилия минимум 2 символа" : nil
    }
}

enum PasswordValidator {
    static func validate(_ s: String) -> String? {
        let hasDigit = s.rangeOfCharacter(from: .decimalDigits) != nil
        let hasUpper = s.rangeOfCharacter(from: .uppercaseLetters) != nil
        if !hasDigit { return "Пароль должен содержать цифру"}
        if !hasUpper { return "Пароль должен содержать заглавную букву"}
        return nil
    }
    
    static func confirm(_ s: String, _ c: String) -> String? {
        return s == c ? nil : "Пароли не совпадают"
    }
}
