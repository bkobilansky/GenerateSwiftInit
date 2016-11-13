# GenerateSwiftInit
Generates an init based on properties of a type.

Given a simple class `Employee`:
```swift
class Employee {
  let name: String
  let id: Int
}
```

`Employee` needs an `init` method, which is largely boilerplate. This project includes an Xcode editor extension to generate the initializer. It matches declarations of the form:
```
var {name}: {Type}
let {name}: {Type}
```

Highlight the properties of `Employee` and invoke the command by selecting Editor > Generate Swift Init > Generate Swift Init From Selection. The following code will be generated:

```swift
init(name: String, id: Int) {
  self.name = name
  self.id = id
}
```

# Installation

## Build
Clone the repository. Run the GenerateSwiftInit target on your machine. You'll likely need to update code signing information.

## Download
A developer-signed mac app is included in the GenerateSwiftInit directory. It is compatible with macOS 10.12 and Xcode 8.

0. Download and move it to your /Applications directory.
0. Open System Preferences > Extensions
0. Ensure the checkbox for GenerateSwiftInit is checked
0. Restart Xcode
