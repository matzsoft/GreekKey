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
        
        xBlocks      = width / Int( generator.blockSize )
        yBlocks      = height / Int( generator.blockSize )
        xCells       = generator.cellCount( blockCount: xBlocks )
        yCells       = generator.cellCount( blockCount: yBlocks )
        borderWidth  = Int( generator.blockSize ) * generator.blocksUsed( blockCount: xBlocks )
        borderHeight = Int( generator.blockSize ) * generator.blocksUsed( blockCount: yBlocks )
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
            width: generator.blockSize * ( CGFloat(xCells) * generator.minWidth + 1 ),
            height: generator.blockSize * ( CGFloat(yCells) * generator.minWidth + 1 )
        ) )
        
        // Create cells across the bottom
        context.scaleBy( x: CGFloat( generator.blockSize ), y: CGFloat( generator.blockSize ) )
        context.saveGState()
        generator.botLeft( context: context )
        for _ in 1 ... xCells { generator.horizontal( context: context ) }
        generator.botRight( context: context )
        
        // Create cells up the right
        for _ in 1 ... yCells { generator.vertical( context: context ) }
        
        // Create cells up the left
        context.restoreGState()
        context.translateBy( x: 0, y: CGFloat( generator.midWidth ) )
        for _ in 1 ... yCells { generator.vertical( context: context ) }
        generator.topLeft( context: context )
        
        // Create cells across the top
        for _ in 1 ... xCells { generator.horizontal( context: context ) }
        generator.topRight( context: context )
        
        context.setLineWidth( 1 )
        context.setLineCap( .square )
        context.strokePath()
        return context.makeImage()
    }
}
