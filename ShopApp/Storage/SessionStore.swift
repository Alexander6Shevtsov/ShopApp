//
//  SessionStore.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 18.08.2025.
//

import Foundation

protocol SessionStoreType {
    var userName: String? { get set }
    var isRegistered: Bool { get set }
}

final class UserDefaultsSessionStore: SessionStoreType {
    private enum Keys {
        static let userName = "session.username"
        static let isRegistered = "session.isRegistered"
    }
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    var userName: String? {
        get { defaults.string(forKey: Keys.userName) }
        set { defaults.set(newValue, forKey: Keys.userName) }
    }
    
    var isRegistered: Bool {
        get { defaults.bool(forKey: Keys.isRegistered) }
        set { defaults.set(newValue, forKey: Keys.isRegistered) }
    }
}
