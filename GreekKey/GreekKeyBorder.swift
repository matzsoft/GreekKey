//
//  GreekKeyBorder.swift
//  junk2
//
//  Created by Mark Johnson on 7/29/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Foundation

class GreekKeyBorder {
    let blockSize: CGFloat
    let fgColor:   CGColor
    let bgColor:   CGColor
    let bounds:    IntSize
    let blocks:    IntSize
    let used:      IntSize
    let cells:     IntSize
    let border:    IntSize
    let margin:    CGSize

    static func maxBlockSize( forImageSize imageSize: CGSize ) -> CGFloat {
        let xCorners = GreekKeyCell.lowerLeft.width + GreekKeyCell.lowerRight.width
        let xMin     = xCorners + GreekKeyCell.horizontal.width + 4
        let xSize    = imageSize.width / xMin
        
        let yCorners = GreekKeyCell.lowerLeft.height + GreekKeyCell.upperLeft.height
        let yMin     = yCorners + GreekKeyCell.vertical.height + 4
        let ySize    = imageSize.height / yMin

        return min( xSize, ySize )
    }
    
    static func minImageSize( forBlockSize blockSize: CGFloat ) -> CGSize {
        let xCorners = GreekKeyCell.lowerLeft.width + GreekKeyCell.lowerRight.width
        let xMin     = xCorners + GreekKeyCell.horizontal.width + 4

        let yCorners = GreekKeyCell.lowerLeft.height + GreekKeyCell.upperLeft.height
        let yMin     = yCorners + GreekKeyCell.vertical.height + 4

        return CGSize( width: blockSize * xMin, height: blockSize * yMin )
    }
    
    static func blocksUsed( blockCount: IntSize ) -> IntSize {
        let width       = blockCount.width
        let height      = blockCount.height
        let xCorners    = Int( GreekKeyCell.lowerLeft.width ) + Int( GreekKeyCell.lowerRight.width )
        let yCorners    = Int( GreekKeyCell.lowerLeft.height ) + Int( GreekKeyCell.upperLeft.height )
        let xBlocksUsed = width - ( width - 4 - xCorners ) % Int( GreekKeyCell.horizontal.width )
        let yBlocksUsed = height - ( height - 4 - yCorners ) % Int( GreekKeyCell.vertical.height )

        return IntSize( width: xBlocksUsed, height: yBlocksUsed )
    }
        
    static func cellCount( blockCount: IntSize ) -> IntSize {
        let width    = blockCount.width
        let height   = blockCount.height
        let xCorners = Int( GreekKeyCell.lowerLeft.width ) + Int( GreekKeyCell.lowerRight.width )
        let yCorners = Int( GreekKeyCell.lowerLeft.height ) + Int( GreekKeyCell.upperLeft.height )
        let xCount   = ( width - 4 - xCorners ) / Int( GreekKeyCell.horizontal.width )
        let yCount   = ( height - 4 - yCorners ) / Int( GreekKeyCell.vertical.height )

        return IntSize( width: xCount, height: yCount )
    }
    
    init( bounds boundsRect: CGRect, blockSize: CGFloat, fgColor: CGColor, bgColor: CGColor ) {
        self.blockSize = blockSize
        self.fgColor   = fgColor
        self.bgColor   = bgColor
        self.bounds    = IntSize( rect: boundsRect )

        blocks = IntSize( width: bounds.width / Int( blockSize ), height: bounds.height / Int( blockSize ) )
        used   = GreekKeyBorder.blocksUsed( blockCount: blocks )
        cells  = GreekKeyBorder.cellCount( blockCount: blocks )
        border = Int( blockSize ) * used
        margin = CGSize(
            width: ( bounds.width - border.width ) / 2, height: ( bounds.height - border.height ) / 2
        )
    }
    
    func drawBounds( context: CGContext, thickness: CGFloat, rect: CGRect ) -> Void {
        let halfWidth = thickness / 2
        
        context.setLineWidth( thickness )
        context.addRect( CGRect(
            x: rect.minX + halfWidth,
            y: rect.minY + halfWidth,
            width: rect.width - thickness,
            height: rect.height - thickness
        ) )
    }

    func draw() -> CGImage? {
        guard cells.width > 0 && cells.height > 0 else { return nil }
        guard let context = CGContext( data: nil, width: bounds.width, height: bounds.height,
                                       bitsPerComponent: 8, bytesPerRow: 4 * bounds.width,
                                       space: CGColorSpace( name: CGColorSpace.sRGB )!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue )
            else { return nil }
        
        context.interpolationQuality = .high
        context.setAllowsAntialiasing( true )
        context.translateBy( x: margin.width, y: margin.height )
        context.scaleBy( x: blockSize, y: blockSize )

        context.setStrokeColor( bgColor )
        drawBounds(
            context: context,
            thickness: GreekKeyCell.horizontal.height + 2,
            rect: CGRect( x: 1, y: 1, width: used.width - 2, height: used.height - 2 )
        )
        context.strokePath()
        context.setStrokeColor( fgColor )
        addPath( context: context )
        
        context.setLineWidth( 1 )
        context.setLineCap( .butt )
        context.strokePath()
        return context.makeImage()
    }
    
    func addPath( context: CGContext ) -> Void {
        drawBounds(
            context: context,
            thickness: 1,
            rect: CGRect( x: 0, y: 0, width: used.width, height: used.height )
        )
        drawBounds( context: context, thickness: 1, rect: CGRect(
            x: GreekKeyCell.vertical.width + 3,
            y: GreekKeyCell.horizontal.height + 3,
            width: CGFloat(cells.width) * GreekKeyCell.horizontal.width + 1,
            height: CGFloat(cells.height) * GreekKeyCell.vertical.height + 1
        ) )
        
        // Create cells across the bottom
        context.translateBy( x: 2, y: 2 )
        context.saveGState()
        GreekKeyCell.lowerLeft.draw( context )
        for _ in 1 ... cells.width { GreekKeyCell.horizontal.draw( context ) }
        GreekKeyCell.lowerRight.draw( context )
        
        // Create cells up the right
        for _ in 1 ... cells.height { GreekKeyCell.vertical.draw( context ) }

        // Create cells up the left
        context.restoreGState()
        context.translateBy( x: 0, y: GreekKeyCell.lowerLeft.height )
        for _ in 1 ... cells.height { GreekKeyCell.vertical.draw( context ) }
        GreekKeyCell.upperLeft.draw( context )
        
        // Create cells across the top
        for _ in 1 ... cells.width { GreekKeyCell.horizontal.draw( context ) }
        GreekKeyCell.upperRight.draw( context )
    }
}
