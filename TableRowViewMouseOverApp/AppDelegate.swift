//
// AppDelegate.swift
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let windowController: NSWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "OutlineWindowController") as! NSWindowController
		
		windowController.showWindow(self)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
	
}

