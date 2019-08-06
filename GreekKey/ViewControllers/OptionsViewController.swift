//
//  OptionsViewController.swift
//  GreekKey
//
//  Created by Mark Johnson on 8/1/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {
    @IBOutlet weak var blockSizeLabel: NSTextField!
    @IBOutlet weak var blockSizeSlider: NSSlider!
    @IBOutlet weak var foregroundColorWell: NSColorWell!
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    @IBOutlet weak var horizontalCountLabel: NSTextField!
    @IBOutlet weak var verticalCountLabel: NSTextField!
    
    var resultsViewController: ResultsViewController?
    var lastImage: CGImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let resultsWindowController = NSApplication.shared.mainWindow?.windowController
        
        resultsViewController = resultsWindowController?.contentViewController as? ResultsViewController
        resultsViewController?.optionsViewController = self
        
        foregroundColorWell.color = NSColor.black
        backgroundColorWell.color = NSColor.white
        
        updateBorder()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func sliderClicked(_ sender: NSSliderCell) {
        let currentValue = blockSizeSlider.integerValue
        
        updateBorder()
        DispatchQueue.main.async {
            self.blockSizeLabel?.stringValue = "Block Size = \(currentValue)"
        }
    }
    
    @IBAction func foregroundChanged(_ sender: Any) {
        updateBorder()
    }
    
    @IBAction func backgroundChanged(_ sender: Any) {
        updateBorder()
    }
    
    func export() {
        guard let image = lastImage else { return }
        
        let savePanel = NSSavePanel()
        
        savePanel.allowedFileTypes = [ "png" ]
        if savePanel.runModal() == .OK {
            guard let exportedURL = savePanel.url else { return }
            let url = exportedURL as CFURL
            
            if let dest = CGImageDestinationCreateWithURL( url, "public.png" as CFString, 1, nil ) {
                CGImageDestinationAddImage( dest, image, nil )
                CGImageDestinationFinalize( dest )
            }
        }
    }
    
    func createBorder() -> GreekKeyBorder? {
        guard let rvc = resultsViewController else { return nil }
        
        let blockSize = blockSizeSlider.integerValue
        let fgColor = foregroundColorWell.color.cgColor
        let bgColor = backgroundColorWell.color.cgColor
        let width = rvc.imageView.bounds.width
        let height = rvc.imageView.bounds.height
        let generator = GreekKeyCells( blockSize: blockSize, fgColor: fgColor, bgColor: bgColor )
        
        return GreekKeyBorder( generator: generator, width: Int(width), height: Int(height) )
    }
    
    func updateBorder() -> Void {
        guard let rvc = resultsViewController else { return }
        guard let border = createBorder() else { return }
        guard let image = border.draw() else { return }
        
        lastImage = image
        rvc.setImage( image: image )
        
        DispatchQueue.main.async {
            self.horizontalCountLabel.stringValue = "\(border.xCells)"
            self.verticalCountLabel.stringValue = "\(border.yCells)"
        }
    }
}
