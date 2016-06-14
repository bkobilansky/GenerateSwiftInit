//
//  SourceEditorExtension.swift
//  Extension
//
//  Created by Brandon Kobilansky on 6/13/16.
//  Copyright © 2016 Brandon Kobilansky. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    func extensionDidFinishLaunching() {
        // there appears to be an issue wherein if you don't want until the extension launches, it never becomes available in the menu
        // add some logging so we know when we can safely advance
        print("Ready to go")
    }

    /*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: AnyObject]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return []
    }
    */
    
}

