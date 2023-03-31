//
//  AppStorageObserverTests.swift
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
import Combine
import XCTest

final class AppStorageObserverTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testBool() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.bool, store: store),
            writing: [false, true, false, true],
            to: \TestObject.bool,
            on: &container)
    }

    func testInt() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.int, store: store),
            writing: [1, 2, 3, 4],
            to: \TestObject.int,
            on: &container)
    }

    func testDouble() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.double, store: store),
            writing: [1, 2, 3, 4],
            to: \TestObject.double,
            on: &container)
    }

    func testString() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.string, store: store),
            writing: ["foo", "bar", "baz", "qux"],
            to: \TestObject.string,
            on: &container)
    }

    func testURL() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.url, store: store),
            writing: [
                URL(string: "https://foo.com")!,
                URL(string: "https://bar.com")!,
                URL(string: "https://baz.com")!
            ],
            to: \TestObject.url,
            on: &container)
    }

    func testData() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.data, store: store),
            writing: [
                Data(repeating: 0x11, count: 4),
                Data(repeating: 0x22, count: 4),
                Data(repeating: 0x33, count: 4)
            ],
            to: \TestObject.data,
            on: &container)
    }

    func testName() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.name, store: store),
            writing: [
                Name(given: "Jerome", family: "Horwitz"),
                Name(given: "Moses", family: "Horwitz"),
                Name(given: "Louis", family: "Feinberg")
            ],
            to: \TestObject.name,
            on: &container)
    }

    func testBinary() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.binary, store: store),
            writing: [
                .zero, .one, .zero, .one, .zero, .one
            ],
            to: \TestObject.binary,
            on: &container)
    }

    func testMetavariable() {
        let store = UserDefaults(suiteName: suiteName)!
        var container = TestObject()

        evaluate(
            observer: AppStorageObserver(for: AppStorageKeys.metavariable, store: store),
            writing: [.foo, .bar, .baz, .foo, .bar, .baz],
            to: \TestObject.metavariable,
            on: &container)
    }

    private func evaluate<Container, Value>(
        observer: AppStorageObserver<Value>,
        writing sent: [Value],
        to keyPath: WritableKeyPath<Container, Value>,
        on container: inout Container
    ) where Value: Equatable {
        var received: [Value] = []

        let expectation = XCTestExpectation(description: "Received values")
        let cancellable: AnyCancellable? = observer
            .publisher
            .collect(sent.count)
            .sink {
                received = $0
                expectation.fulfill()
            }

        for value in sent {
            container[keyPath: keyPath] = value
        }

        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(sent, received)
        XCTAssertNotNil(cancellable)
    }
}
