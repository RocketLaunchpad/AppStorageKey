//
//  AppStorageKeyTests.swift
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
import XCTest

final class AppStorageKeyTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults(suiteName: suiteName)!.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        UserDefaults(suiteName: suiteName)!.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    /// Ensure that the default values are correctly registered
    func testDefaultValues() {
        let object = TestObject()
        XCTAssertEqual(object.bool, AppStorageKeys.bool.defaultValue)
        XCTAssertEqual(object.int, AppStorageKeys.int.defaultValue)
        XCTAssertEqual(object.double, AppStorageKeys.double.defaultValue)
        XCTAssertEqual(object.string, AppStorageKeys.string.defaultValue)
        XCTAssertEqual(object.url, AppStorageKeys.url.defaultValue)
        XCTAssertEqual(object.data, AppStorageKeys.data.defaultValue)
        XCTAssertEqual(object.name, AppStorageKeys.name.defaultValue)
        XCTAssertEqual(object.binary, AppStorageKeys.binary.defaultValue)
        XCTAssertEqual(object.metavariable, AppStorageKeys.metavariable.defaultValue)
    }

    /// Ensure changing values persist across object lifetimes
    func testPersistingValues() {
        let bool = false
        let int = 21
        let double = 2.17828
        let string = "fnord"
        let url = URL(string: "https://www.webhamster.com/")!
        let data = Data(repeating: 0xAA, count: 4)
        let name = Name(given: "Moses", family: "Horwitz")
        let binary = BinaryEnum.one
        let metavariable = Metavariable.bar

        let object1 = TestObject()
        object1.bool = bool
        object1.int = int
        object1.double = double
        object1.string = string
        object1.url = url
        object1.data = data
        object1.name = name
        object1.binary = binary
        object1.metavariable = metavariable

        XCTAssertEqual(object1.bool, bool)
        XCTAssertEqual(object1.int, int)
        XCTAssertEqual(object1.double, double)
        XCTAssertEqual(object1.string, string)
        XCTAssertEqual(object1.url, url)
        XCTAssertEqual(object1.data, data)
        XCTAssertEqual(object1.name, name)
        XCTAssertEqual(object1.binary, binary)
        XCTAssertEqual(object1.metavariable, metavariable)

        let object2 = TestObject()
        XCTAssertEqual(object2.bool, bool)
        XCTAssertEqual(object2.int, int)
        XCTAssertEqual(object2.double, double)
        XCTAssertEqual(object2.string, string)
        XCTAssertEqual(object2.url, url)
        XCTAssertEqual(object2.data, data)
        XCTAssertEqual(object2.name, name)
        XCTAssertEqual(object2.binary, binary)
        XCTAssertEqual(object2.metavariable, metavariable)
    }
}
