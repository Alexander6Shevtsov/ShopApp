//
//  RegistrationViewModel.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import Foundation

final class RegistrationViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    @Published var passwordError: String?
    @Published var confirmError: String?
    
    @Published var didAttemptSubmit: Bool = false
    
    private let sessionStore: SessionStoreType
    var onSuccess: (() -> Void)?
    
    init(sessionStore: SessionStoreType) {
        self.sessionStore = sessionStore
    }
    
    var isFormFilled: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !password.isEmpty && confirmPassword == password
    }
    
    private func validateAll() -> Bool {
        firstNameError = NameValidator.validateFirstName(firstName)
        lastNameError = NameValidator.validateLastName(lastName)
        passwordError = PasswordValidator.validate(password)
        confirmError = PasswordValidator.confirm(password, confirmPassword)
        
        return firstNameError == nil &&
        lastNameError == nil &&
        passwordError == nil &&
        confirmError == nil
    }
    
    func register() {
        didAttemptSubmit = true
        guard validateAll() else { return }
        
        sessionStore.userName = firstName
        sessionStore.isRegistered = true
        
        onSuccess?()
    }
}
