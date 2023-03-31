//
//  TestData.swift
//  AppStorageKeyTests
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

import AppStorageKey
import SwiftUI

let suiteName = "AppStorageKeyTests"

struct Name: Codable, RawRepresentable, Equatable {
    var given: String
    var family: String

    internal init(given: String, family: String) {
        self.given = given
        self.family = family
    }

    enum CodingKeys: String, CodingKey {
        case given
        case family
    }

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.given = try container.decode(String.self, forKey: .given)
        self.family = try container.decode(String.self, forKey: .family)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.given, forKey: .given)
        try container.encode(self.family, forKey: .family)
    }

    init?(rawValue: String) {
        do {
            self = try JSONDecoder().decode(Name.self, from: Data(rawValue.utf8))
        }
        catch {
            return nil
        }
    }

    var rawValue: String {
        do {
            return try String(decoding: JSONEncoder().encode(self), as: UTF8.self)
        }
        catch {
            return "{}"
        }
    }
}

enum BinaryEnum: Int {
    case zero = 0
    case one = 1
}

enum Metavariable: String {
    case foo
    case bar
    case baz
}

enum AppStorageKeys {
    static let bool = AppStorageKey(name: "bool", defaultValue: true)
    static let int = AppStorageKey(name: "int", defaultValue: 42)
    static let double = AppStorageKey(name: "double", defaultValue: 3.1415)
    static let string = AppStorageKey(name: "string", defaultValue: "foobar")
    static let url = AppStorageKey(name: "url", defaultValue: URL(string: "https://zombo.com")!)
    static let data = AppStorageKey(name: "data", defaultValue: Data(repeating: 0x55, count: 4))
    static let name = AppStorageKey(name: "name", defaultValue: Name(given: "Jerome", family: "Horwitz"))
    static let binary = AppStorageKey(name: "binary", defaultValue: BinaryEnum.zero)
    static let metavariable = AppStorageKey(name: "metavariable", defaultValue: Metavariable.foo)
}

final class TestObject {
    @AppStorage(key: AppStorageKeys.bool, store: UserDefaults(suiteName: suiteName))
    var bool

    @AppStorage(key: AppStorageKeys.int, store: UserDefaults(suiteName: suiteName))
    var int

    @AppStorage(key: AppStorageKeys.double, store: UserDefaults(suiteName: suiteName))
    var double

    @AppStorage(key: AppStorageKeys.string, store: UserDefaults(suiteName: suiteName))
    var string

    @AppStorage(key: AppStorageKeys.url, store: UserDefaults(suiteName: suiteName))
    var url

    @AppStorage(key: AppStorageKeys.data, store: UserDefaults(suiteName: suiteName))
    var data

    @AppStorage(key: AppStorageKeys.name, store: UserDefaults(suiteName: suiteName))
    var name

    @AppStorage(key: AppStorageKeys.binary, store: UserDefaults(suiteName: suiteName))
    var binary

    @AppStorage(key: AppStorageKeys.metavariable, store: UserDefaults(suiteName: suiteName))
    var metavariable
}
