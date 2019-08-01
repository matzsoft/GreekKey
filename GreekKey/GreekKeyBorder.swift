//
//  GreekKeyBorder.swift
//  junk2
//
//  Created by Mark Johnson on 7/29/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Foundation

func greekKeyBorder( generator: GreekKeyCells, width: Int, height: Int ) -> CGImage? {
    guard let context = CGContext( data: nil, width: width, height: height, bitsPerComponent: 8,
                                   bytesPerRow: 4 * width, space: generator.colorSpace,
                                   bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue )
        else { return nil }
    
    context.interpolationQuality = .high
    context.setAllowsAntialiasing( true )
    
    let xBlocks = width / generator.blockWidth
    let yBlocks = height / generator.blockWidth
    let xCells = ( xBlocks - 2 * generator.maxWidth + 1 ) / generator.minWidth
    let yCells = ( yBlocks - 2 * generator.maxWidth + 1 ) / generator.minWidth
    let borderWidth = generator.blockWidth * ( xCells * generator.minWidth + 2 * generator.maxWidth - 1 )
    let borderHeight = generator.blockWidth * ( yCells * generator.minWidth + 2 * generator.maxWidth - 1 )
    let leftMargin = ( width - borderWidth ) / 2
    let bottomMargin = ( height - borderHeight ) / 2
    
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

    return context.makeImage()
}
