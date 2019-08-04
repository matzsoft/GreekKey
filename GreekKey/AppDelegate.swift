//
//  AppDelegate.swift
//  GreekKey
//
//  Created by Mark Johnson on 7/28/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var optionsWindowController: NSWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let storyBoard = NSStoryboard( name: "Main", bundle: nil )
        
        optionsWindowController = storyBoard.instantiateController( withIdentifier: "optionsWindowController" ) as? NSWindowController
        optionsWindowController?.showWindow( self )
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

