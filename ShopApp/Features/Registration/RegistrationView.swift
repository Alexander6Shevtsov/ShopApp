//
//  RegistrationView.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let dateRange: ClosedRange<Date> = {
        let now = Date()
        var dateComponts = DateComponents()
        dateComponts.year = 1900; dateComponts.month = 1; dateComponts.day = 1
        let min = Calendar.current.date(from: dateComponts) ?? Date(timeIntervalSince1970: 0)
        return min...now
    }()
    
    var body: some View {
        Form {
            Section(header: Text("Регистрация")) {
                TextField("Имя", text: $viewModel.firstName)
                    .textContentType(.givenName)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.words)
                fieldError(viewModel.firstNameError)
                
                TextField("Фамилия", text: $viewModel.lastName)
                    .textContentType(.familyName)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.words)
                fieldError(viewModel.lastNameError)
                
                DatePicker(
                    "Дата рождения",
                    selection: $viewModel.birthDate,
                    in: dateRange,
                    displayedComponents: .date
                )
            }
            
            Section(header: Text("Безопасность")) {
                SecureField("Пароль", text: $viewModel.password)
                    .textContentType(.newPassword)
                fieldError(viewModel.passwordError)
                
                SecureField("Повтор пароля", text: $viewModel.confirmPassword)
                    .textContentType(.newPassword)
                fieldError(viewModel.confirmError)
            }
            
            Section {
                Button("Регистрация") { viewModel.register() }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(!viewModel.isFormFilled)
            }
        }
        
        .navigationTitle("Регистрация")
        .onSubmit { viewModel.register() }
        .onChange(of: viewModel.didAttemptSubmit) { _ in
            _ = ()
        }
    }
    
    @ViewBuilder
    private func fieldError(_ text: String?) -> some View {
        if let text, viewModel.didAttemptSubmit {
            Text(text).foregroundStyle(.red).font(.footnote)
        }
    }
}

#Preview {
    let defaults = UserDefaults(suiteName: "Preview")!
    let store = UserDefaultsSessionStore(defaults: defaults)
    let vm = RegistrationViewModel(sessionStore: store)
    return RegistrationView(viewModel: vm)
}
