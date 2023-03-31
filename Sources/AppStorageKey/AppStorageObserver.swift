//
//  AppStorageObserver.swift
//  AppStorageKey
//
//  Copyright (c) 2023 DEPT Digital Products, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Combine
import SwiftUI

/// An `AppStorageObserver` observes and publishes changes to a user default
/// associated with an `AppStorageKey`.
///
public final class AppStorageObserver<Value>: ObservableObject {

    /// We dynamically create an AppStorage instance instead of using the
    /// property wrapper syntax. As the containing type implements
    /// ObservableObject, changes to this AppStorage will emit events on the
    /// objectWillChange publisher.
    ///
    private let storage: AppStorage<Value>

    /// We lazily subscribe to objectWillChange, compactMap (to support the use
    /// of weak self) the value, and re-publish it.
    ///
    public lazy private(set) var publisher: AnyPublisher<Value, Never> = {
        objectWillChange
            .compactMap { [weak self] _ in
                self?.value
            }
            .eraseToAnyPublisher()
    }()

    /// The value of the user default associated with this observer's key.
    ///
    public var value: Value {
        storage.wrappedValue
    }

    // MARK: - Initializers

    /// Creates an observer that publishes changes to the user default
    /// associated with the specified key.
    ///
    public init(for key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Bool {
        storage = AppStorage(key: key, store: store)
    }

    /// Creates an observer that publishes changes to the user default
    /// associated with the specified key.
    ///
    public init(for key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Int {
        storage = AppStorage(key: key, store: store)
    }

    /// Creates an observer that publishes changes to the user default
    /// associated with the specified key.
    ///
    public init(for key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Double {
        storage = AppStorage(key: key, store: store)
    }

    /// Creates an observer that publishes changes to the user default
    /// associated with the specified key.
    ///
    public init(for key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == String {
        storage = AppStorage(key: key, store: store)
    }

    /// Creates an observer that publishes changes to the user default
    /// associated with the specified key.
    ///
    public init(for key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == URL {
        storage = AppStorage(key: key, store: store)
    }

    /// Creates an observer that publishes changes to the user default
    /// associated with the specified key.
    ///
    public init(for key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Data {
        storage = AppStorage(key: key, store: store)
    }

    /// Creates an observer that publishes changes to the user default
    /// associated with the specified key.
    ///
    public init(for key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value: RawRepresentable, Value.RawValue == Int {
        storage = AppStorage(key: key, store: store)
    }

    /// Creates an observer that publishes changes to the user default
    /// associated with the specified key.
    ///
    public init(for key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value: RawRepresentable, Value.RawValue == String {
        storage = AppStorage(key: key, store: store)
    }
}
