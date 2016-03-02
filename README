# Louis
Automated accessibility testing for iOS. This project is still new. Please contribute!

## Installation

### Fetch Using Cocoapods

Add the following to your ``Podfile``:
```ruby
pod 'Louis', '~> 1.0'
```

### Fetch Using Carthage

Add the following to your ``Cartfile``:
```
github "aleffert/Louis"
```


### Configuring Louis in your project

Add the following to the ``application(didFinishLaunchingWithOptions:)``
method of your app delegate:

```
LUILouis.shared.timedCheckEnabled = true
```

This will enable a check that runs every three seconds looking for violations.
The default is to log errors it finds to the console. You can also have it
assert or doing something else entirely by setting the ``reportAction``
property on the shared ``LUILouis`` instance. For example, to have it assert
if there's a problem you can do:
```swift
    LUILouis.shared.reportAction = { LUIAssertionLogger($0) }
```

You can also use Louis as part of your XCTest cases. Simply assert that your
view has no issues.
```swift
    XCTAssertEqual(view.lui_accessibilityReports.count, 0)
```


## Hacking

### Adding a new report

1. Create a new class that implements the ``LUIReport`` protocol.
2. Add ``[YourClass class]`` to ``+[LUIReport reporters]``.

## License

Louis is available under the MIT license. See the LICENSE file for more info.
