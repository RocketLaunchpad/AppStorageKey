# AppStorageKey

Using `@AppStorage` requires you to provide a string key and a default value:

```swift
@AppStorage("storedPropertyKey")
var storedProperty = "default value"
```

If you use that property in multiple places in the app, you need to use the same key name in each location. Each location can also provide its own default value. This can be counterintuitive.

The `AppStorageKey` library allows you to define a key and its default value in one place:

```swift
enum AppStorageKeys {
    static let storedProperty = AppStorageKey(
        name: "storedPropertyKey",
        defaultValue: "default value")
}
```

and use it with the existing `@AppStorage` property wrapper.

```swift
@AppStorage(key: AppStorageKeys.storedProperty)
var storedProperty
```

This library also provides an `AppStorageObserver` type that observes and publishes changes to a user default associated with an `AppStorageKey`. For example:

```swift
// You will need to retain the observer
let observer = AppStorageObserver(for: AppStorageKeys.storedProperty)

observer
    .publisher
    .sink(receiveValue: { newValue in
        print("Received update to \(AppStorageKeys.storedProperty.name): \(newValue)")
    })
    .store(in: &cancellables)
```
