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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let resultsWindowController = NSApplication.shared.mainWindow?.windowController
        
        resultsViewController = resultsWindowController?.contentViewController as? ResultsViewController
        resultsViewController?.optionsViewController = self
        
        foregroundColorWell.color = NSColor.black
        backgroundColorWell.color = NSColor.white
        
        createBorder()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func sliderClicked(_ sender: NSSliderCell) {
        let currentValue = blockSizeSlider.integerValue
        
        createBorder()
        DispatchQueue.main.async {
            self.blockSizeLabel?.stringValue = "Block Size = \(currentValue)"
        }
    }
    
    @IBAction func foregroundChanged(_ sender: Any) {
        createBorder()
    }
    
    @IBAction func backgroundChanged(_ sender: Any) {
        createBorder()
    }
    
    func createBorder() -> Void {
        if let rvc = resultsViewController {
            let blockSize = blockSizeSlider.integerValue
            let fgColor = foregroundColorWell.color.cgColor
            let bgColor = backgroundColorWell.color.cgColor
            let width = rvc.imageView.bounds.width
            let height = rvc.imageView.bounds.height
            let generator = GreekKeyCells( blockWidth: blockSize, fgColor: fgColor, bgColor: bgColor )
            let border = GreekKeyBorder( generator: generator, width: Int(width), height: Int(height) )
            
            rvc.setImage( border: border )
            
            DispatchQueue.main.async {
                self.horizontalCountLabel.stringValue = "\(border.xCells)"
                self.verticalCountLabel.stringValue = "\(border.yCells)"
            }
        }
    }
}
