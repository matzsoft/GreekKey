//
//  GreekKeyCells.swift
//  GreekKey
//
//  Created by Mark Johnson on 7/29/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Foundation

class GreekKeyCells {
    static let minWidth   = CGFloat( 6 )
    static let maxWidth   = CGFloat( 7 )
    static let colorSpace = CGColorSpace( name: CGColorSpace.sRGB )!
    
    let blockSize: CGFloat
    let fgColor:   CGColor
    let bgColor:   CGColor
    
    var minWidth:   CGFloat      { return GreekKeyCells.minWidth }
    var maxWidth:   CGFloat      { return GreekKeyCells.maxWidth }
    var colorSpace: CGColorSpace { return GreekKeyCells.colorSpace }

    init( blockSize: CGFloat, fgColor: CGColor, bgColor: CGColor ) {
        self.blockSize = blockSize
        self.fgColor   = fgColor
        self.bgColor   = bgColor
    }
    

    static func maxBlockSize( forImageSize: CGFloat ) -> CGFloat {
        return forImageSize / ( maxWidth + minWidth + minWidth )
    }
    
    static func minImageSize( forBlockSize bs: CGFloat ) -> CGFloat {
        return bs * maxWidth + bs * minWidth + bs * minWidth
    }
    
    func cellCount( blockCount: Int ) -> Int {
        return ( blockCount - Int( maxWidth ) - Int( minWidth ) ) / Int( minWidth )
    }
    
    func blocksUsed( blockCount: Int ) -> Int {
        return blockCount - ( blockCount - Int( maxWidth ) - Int( minWidth ) ) % Int( minWidth )
    }
        

    func setupContext( width: Int, height: Int ) -> CGContext {
        guard let context = CGContext( data: nil, width: width, height: height,
                                       bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue )
        else { fatalError( "Can't create CGContext for drawing." ) }
            
        context.interpolationQuality = .high
        context.setAllowsAntialiasing( true )
        
        context.setStrokeColor( fgColor )

        return context
    }
    
    
    func bendHorizontal( context: CGContext ) -> Void {
        context.move(    to: CGPoint( x: 0.5, y: 0.5 ) )
        context.addLine( to: CGPoint( x: 3.5, y: 0.5 ) )
        context.addLine( to: CGPoint( x: 3.5, y: 2.5 ) )
        context.addLine( to: CGPoint( x: 1.5, y: 2.5 ) )
        context.addLine( to: CGPoint( x: 1.5, y: 4.5 ) )
        context.addLine( to: CGPoint( x: 5.5, y: 4.5 ) )
        context.addLine( to: CGPoint( x: 5.5, y: 0.5 ) )
    }


    func bendVertical( context: CGContext ) -> Void {
        context.saveGState()
        context.rotate( by: -CGFloat.pi / 2 )
        context.translateBy( x: -minWidth, y: 0 )
        bendHorizontal( context: context )
        context.restoreGState()
    }
    
    
    func topLeft( context: CGContext ) -> Void {
        bendVertical( context: context )
        context.move(    to: CGPoint( x: 0.5, y: 6.5 ) )
        context.addLine( to: CGPoint( x: 6.5, y: 6.5 ) )
        context.addLine( to: CGPoint( x: 6.5, y: 2.5 ) )
        context.translateBy( x: maxWidth, y: 2 )
    }
    
    
    func topRight( context: CGContext ) -> Void {
        bendHorizontal( context: context )
        context.addLine( to: CGPoint( x: 5.5, y: -1.5 ) )
        context.addLine( to: CGPoint( x: 1.5, y: -1.5 ) )
    }
    
    
    func horizontal( context: CGContext ) -> Void {
        bendHorizontal( context: context )

        context.translateBy( x: minWidth, y: 0 )
    }
    
    
    func botLeft( context: CGContext ) -> Void {
        context.addLines( between: [ CGPoint( x: 0.5, y: 0.5 ), CGPoint( x: 0.5, y: 5.5 ) ] )
        context.translateBy( x: 1, y: 0 )
        bendHorizontal( context: context )

        context.translateBy( x: minWidth, y: 0 )
    }
    
    
    func botRight( context: CGContext ) -> Void {
        context.translateBy( x: 1, y: 0 )
        bendVertical( context: context )
        context.addLine( to: CGPoint( x: -0.5, y: 0.5 ) )

        context.translateBy( x: 0, y: minWidth )
    }
    
    
    func vertical( context: CGContext ) -> Void {
        bendVertical( context: context )

        context.translateBy( x: 0, y: minWidth )
    }
}
