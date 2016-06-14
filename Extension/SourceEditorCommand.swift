//
//  SourceEditorCommand.swift
//  Extension
//
//  Created by Brandon Kobilansky on 6/13/16.
//  Copyright © 2016 Brandon Kobilansky. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (NSError?) -> Void ) -> Void {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            let error = NSError(domain: "GenerateSwiftInit", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid selection for generation"])
            completionHandler(error)
            return
        }

        let lineNumbers = selection.start.line ... selection.end.line

        guard lineNumbers.count > 0 else {
            completionHandler(nil)
            return
        }

        let lines = invocation.buffer.lines.enumerated().flatMap { (lineNumber, untypedLine) -> String? in
            guard let line = untypedLine as? String else { return nil }
            return lineNumbers.contains(lineNumber) ? line : nil
        }

        invocation.buffer.lines.insert(generateInit(lines: lines), at: lineNumbers.upperBound.advanced(by: 1))

        completionHandler(nil)
    }

    private let regex = try! RegularExpression(pattern: "(?:var|let)\\s(\\w+)\\s?:\\s?(\\w+\\??)", options: [.caseInsensitive])

    private struct Match {
        let name: String
        let type: String

        var paramString: String {
            return "\(name): \(type)"
        }

        var valueInitializer: String {
            return "self.\(name) = \(name)"
        }
    }

    private func generateInit(lines: [String]) -> String {

        let results = lines.flatMap { line -> Match? in
            let range = NSRange(location: 0, length: line.utf8.count)
            let matches = regex.matches(in: line, options: [], range: range)

            guard let match = matches.first else { return nil }

            let nsline = line as NSString

            let nameRange = match.range(at: 1)
            let typeRange = match.range(at: 2)

            return Match(name: nsline.substring(with: nameRange), type: nsline.substring(with: typeRange))
        }

        // optional? throws?
        guard results.count > 0 else { return "" }

        let paramString = results.map { $0.paramString }.joined(separator: ", ")

        // TODO: correct indent
        let valueInitializers = results.map { $0.valueInitializer }.joined(separator: "\n\t")

        // TODO: correct indent
        return "\ninit(\(paramString)) {\n\t\(valueInitializers)\n}"
    }
}

