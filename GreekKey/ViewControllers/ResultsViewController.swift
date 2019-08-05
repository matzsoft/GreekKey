//
//  ResultsViewController.swift
//  GreekKey
//
//  Created by Mark Johnson on 8/1/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Cocoa

class ResultsViewController: NSViewController, NSWindowDelegate {
    @IBOutlet weak var imageView: NSImageView!
    
    var optionsViewController: OptionsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        self.view.window?.delegate = self
    }
    
    func windowDidResize(_ notification: Notification) {
        // Your code goes here
        optionsViewController?.updateBorder()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func setImage( image: CGImage ) -> Void {
        let nsImage = NSImage( cgImage: image, size: NSZeroSize )
        
        imageView.image = nsImage
    }
}
