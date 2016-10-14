//
//  SourceEditorCommand.swift
//  Extension
//
//  Created by Brandon Kobilansky on 6/13/16.
//  Copyright © 2016 Brandon Kobilansky. All rights reserved.
//

import Foundation

import XcodeKit

import SwiftGenerator

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
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

        let initializer = SwiftGenerator.generateInit(lines: lines)
        invocation.buffer.lines.insert(initializer, at: lineNumbers.upperBound.advanced(by: 1))

        completionHandler(nil)
    }
}

