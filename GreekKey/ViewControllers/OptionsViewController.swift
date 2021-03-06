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
        
        setSliderMax()
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
    
    func setSliderMax() -> Void {
        if let bounds = resultsViewController?.imageView.bounds {
            let maxBlockSize = GreekKeyBorder.maxBlockSize( forImageSize: bounds.size )
            
            blockSizeSlider.maxValue = Double(maxBlockSize)
        }
    }
    
    func createBorder() -> GreekKeyBorder? {
        guard let rvc = resultsViewController else { return nil }
        
        let blockSize = CGFloat( blockSizeSlider.integerValue )
        let fgColor = foregroundColorWell.color.cgColor
        let bgColor = backgroundColorWell.color.cgColor
        
        return GreekKeyBorder(
            bounds: rvc.imageView.bounds, blockSize: blockSize, fgColor: fgColor, bgColor: bgColor
        )
    }
    
    func updateBorder() -> Void {
        guard let rvc = resultsViewController else { return }
        guard let border = createBorder() else { return }
        guard let image = border.draw() else { return }
        
        lastImage = image
        rvc.setImage( image: image )
        
        DispatchQueue.main.async {
            self.horizontalCountLabel.stringValue = "\(border.cells.width)"
            self.verticalCountLabel.stringValue = "\(border.cells.height)"
        }
    }
}
