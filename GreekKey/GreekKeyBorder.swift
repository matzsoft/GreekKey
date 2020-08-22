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
    
    func drawBounds( context: CGContext, rect: CGRect ) -> Void {
        let halfWidth = CGFloat( generator.blockSize ) / 2
        
        context.setStrokeColor( generator.fgColor )
        context.setLineWidth( CGFloat( generator.blockSize ) )
        context.stroke( CGRect(
            x: rect.minX + halfWidth,
            y: rect.minY + halfWidth,
            width: rect.width - CGFloat( generator.blockSize ),
            height: rect.height - CGFloat( generator.blockSize )
        ) )
    }

    func draw() -> CGImage? {
        guard let context = CGContext( data: nil, width: width, height: height, bitsPerComponent: 8,
                                       bytesPerRow: 4 * width, space: generator.colorSpace,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue )
            else { return nil }
        
        context.interpolationQuality = .high
        context.setAllowsAntialiasing( true )
        
        guard xCells > 0 && yCells > 0 else { return nil }
        
        var x = leftMargin
        var y = bottomMargin
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
        x = leftMargin
        y = y + botL.height
        for _ in 1 ... yCells {
            context.draw( vert, in: CGRect( x: x, y: y, width: vert.width, height: vert.height ) )
            y += vert.height
        }
        
        context.draw( topL, in: CGRect( x: x, y: y, width: topL.width, height: topL.height ) )
        
        // Create cells across the top
        x = leftMargin + topL.width
        for _ in 1 ... xCells {
            context.draw( horz, in: CGRect( x: x, y: y, width: horz.width, height: horz.height ) )
            x += horz.width
        }
        
        context.draw( topR, in: CGRect( x: x, y: y, width: topR.width, height: topR.height ) )
        
        // Create cells up the right
        x += topR.width - vert.width
        y = bottomMargin + botR.height
        for _ in 1 ... yCells {
            context.draw( vert, in: CGRect( x: x, y: y, width: vert.width, height: vert.height ) )
            y += vert.height
        }
        
        drawBounds( context: context, rect: CGRect(
            x: leftMargin,
            y: bottomMargin,
            width: borderWidth,
            height: borderHeight
        ) )
        drawBounds( context: context, rect: CGRect(
            x: leftMargin + generator.midWidth * generator.blockSize,
            y: bottomMargin + generator.midWidth * generator.blockSize,
            width: generator.blockSize * ( xCells * generator.minWidth + 1 ),
            height: generator.blockSize * ( yCells * generator.minWidth + 1 )
        ) )
        
        return context.makeImage()
    }
}
