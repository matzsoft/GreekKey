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
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        guard let blockSize = optionsViewController?.blockSizeSlider.intValue else {
            return frameSize
        }
        
        let oldBounds = imageView.bounds.size
        let oldFrame  = sender.frame.size
        let deltax    = frameSize.width - oldFrame.width
        let deltay    = frameSize.height - oldFrame.height
        let newBounds = CGSize( width: oldBounds.width + deltax, height: oldBounds.height + deltay )
        let minSize   = GreekKeyBorder.minImageSize( forBlockSize: CGFloat(blockSize) )
        var newFrame  = frameSize
        
        if newBounds.width < minSize.width {
            newFrame.width = oldFrame.width - oldBounds.width + minSize.width
        }
        if newBounds.height < minSize.height {
            newFrame.height = oldFrame.height - oldBounds.height + minSize.height
        }
        
        return newFrame
    }
    
    func windowDidResize(_ notification: Notification) {
        // Your code goes here
        optionsViewController?.setSliderMax()
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
