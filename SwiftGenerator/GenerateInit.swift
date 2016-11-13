//
//  GenerateInit.swift
//  GenerateSwiftInit
//
//  Created by Brandon Kobilansky on 10/13/16.
//  Copyright © 2016 Brandon Kobilansky. All rights reserved.
//

import Foundation

private let regex = try! NSRegularExpression(pattern: "(?:var|let)\\s(\\w+)\\s?:\\s?(\\w+\\??)", options: [.caseInsensitive])

private struct Match {
    let name: String
    let type: String

    init(name: String, type: String) {
        self.name = name
        self.type = type
    }

    var paramString: String {
        return "\(name): \(type)"
    }

    var valueInitializer: String {
        return "self.\(name) = \(name)"
    }
}

public func generateInit(lines: [String]) -> String {

    let results = lines.flatMap { line -> Match? in
        let range = NSRange(location: 0, length: line.utf8.count)
        let matches = regex.matches(in: line, options: [], range: range)

        guard let match = matches.first, match.numberOfRanges >= 2 else { return nil }

        // TODO: should be able to solve this with pure Swift...
        let nsline = line as NSString
        let nameRange = match.rangeAt(1)
        let typeRange = match.rangeAt(2)

        return Match(
            name: nsline.substring(with: nameRange),
            type: nsline.substring(with: typeRange)
        )
    }

    // optional? throws?
    guard results.count > 0 else { return "" }

    let paramString = results.map { $0.paramString }.joined(separator: ", ")

    // TODO: correct indent
    let valueInitializers = results.map { $0.valueInitializer }.joined(separator: "\n\t")

    // TODO: correct indent
    return "\ninit(\(paramString)) {\n\t\(valueInitializers)\n}\n"
}
