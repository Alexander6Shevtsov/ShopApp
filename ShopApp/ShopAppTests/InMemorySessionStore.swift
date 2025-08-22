//
//  InMemorySessionStore.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 22.08.2025.
//

@testable import ShopApp

final class InMemorySessionStore: SessionStoreType {
    var isRegistered = false
    var userName: String?
}
