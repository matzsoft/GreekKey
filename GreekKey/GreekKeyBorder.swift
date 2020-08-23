//
//  GreekKeyBorder.swift
//  junk2
//
//  Created by Mark Johnson on 7/29/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Foundation

class GreekKeyBorder {
    let generator:    GreekKeyCells
    let width:        Int
    let height:       Int
    let xBlocks:      Int
    let yBlocks:      Int
    let xCells:       Int
    let yCells:       Int
    let borderWidth:  Int
    let borderHeight: Int
    let leftMargin:   Int
    let bottomMargin: Int
    
    init( generator: GreekKeyCells, width: Int, height: Int ) {
        self.generator = generator
        self.width = width
        self.height = height
        
        xBlocks      = width / generator.blockSize
        yBlocks      = height / generator.blockSize
        xCells       = ( xBlocks - 2 * generator.maxWidth + 1 ) / generator.minWidth
        yCells       = ( yBlocks - 2 * generator.maxWidth + 1 ) / generator.minWidth
        borderWidth  = generator.blockSize * ( xCells * generator.minWidth + 2 * generator.maxWidth - 1 )
        borderHeight = generator.blockSize * ( yCells * generator.minWidth + 2 * generator.maxWidth - 1 )
        leftMargin   = ( width - borderWidth ) / 2
        bottomMargin = ( height - borderHeight ) / 2
    }
    
    func drawBounds( context: CGContext, thickness: CGFloat, rect: CGRect ) -> Void {
        let halfWidth = thickness / 2
        
        context.setLineWidth( thickness )
        context.stroke( CGRect(
            x: rect.minX + halfWidth,
            y: rect.minY + halfWidth,
            width: rect.width - thickness,
            height: rect.height - thickness
        ) )
    }

    func draw() -> CGImage? {
        guard xCells > 0 && yCells > 0 else { return nil }
        guard let context = CGContext( data: nil, width: width, height: height, bitsPerComponent: 8,
                                       bytesPerRow: 4 * width, space: generator.colorSpace,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue )
            else { return nil }
        
        context.interpolationQuality = .high
        context.setAllowsAntialiasing( true )
        context.translateBy( x: CGFloat( leftMargin ), y: CGFloat( bottomMargin ) )
        
        context.setStrokeColor( generator.bgColor )
        drawBounds(
            context: context,
            thickness: CGFloat( generator.midWidth * generator.blockSize ),
            rect: CGRect( x: 0, y: 0, width: borderWidth, height: borderHeight )
        )
        context.setStrokeColor( generator.fgColor )
        drawBounds(
            context: context,
            thickness: CGFloat( generator.blockSize ),
            rect: CGRect( x: 0, y: 0, width: borderWidth, height: borderHeight )
        )
        drawBounds( context: context, thickness: CGFloat( generator.blockSize ), rect: CGRect(
            x: generator.midWidth * generator.blockSize,
            y: generator.midWidth * generator.blockSize,
            width: generator.blockSize * ( xCells * generator.minWidth + 1 ),
            height: generator.blockSize * ( yCells * generator.minWidth + 1 )
        ) )
        
        var x = 0
        var y = 0
        let botL = generator.botLeft
        let topL = generator.topLeft
        let topR = generator.topRight
        let botR = generator.botRight
        let horz = generator.horizontal
        let vert = generator.vertical
        
        // Create cells across the bottom
        context.draw( botL, in: CGRect( x: x, y: y, width: botL.width, height: botL.height ) )
        x += botL.width
        
        for _ in 1 ... xCells {
            context.draw( horz, in: CGRect( x: x, y: y, width: horz.width, height: horz.height ) )
            x += horz.width
        }
        
        context.draw( botR, in: CGRect( x: x, y: y, width: botR.width, height: botR.height ) )
        
        // Create cells up the left
        x = 0
        y = y + botL.height
        for _ in 1 ... yCells {
            context.draw( vert, in: CGRect( x: x, y: y, width: vert.width, height: vert.height ) )
            y += vert.height
        }
        
        context.draw( topL, in: CGRect( x: x, y: y, width: topL.width, height: topL.height ) )
        
        // Create cells across the top
        x = topL.width
        for _ in 1 ... xCells {
            context.draw( horz, in: CGRect( x: x, y: y, width: horz.width, height: horz.height ) )
            x += horz.width
        }
        
        context.draw( topR, in: CGRect( x: x, y: y, width: topR.width, height: topR.height ) )
        
        // Create cells up the right
        x += topR.width - vert.width
        y = botR.height
        for _ in 1 ... yCells {
            context.draw( vert, in: CGRect( x: x, y: y, width: vert.width, height: vert.height ) )
            y += vert.height
        }
        
        return context.makeImage()
    }
}
