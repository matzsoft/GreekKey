//
//  GreekKeyCells.swift
//  GreekKey
//
//  Created by Mark Johnson on 7/29/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Foundation

class GreekKeyCells {
    static let minWidth   = 6
    static let midWidth   = 8
    static let maxWidth   = 9
    static let colorSpace = CGColorSpace( name: CGColorSpace.sRGB )!
    
    let blockSize: Int
    let fgColor:   CGColor
    let bgColor:   CGColor
    
    var minWidth:   Int          { return GreekKeyCells.minWidth }
    var midWidth:   Int          { return GreekKeyCells.midWidth }
    var maxWidth:   Int          { return GreekKeyCells.maxWidth }
    var colorSpace: CGColorSpace { return GreekKeyCells.colorSpace }

    init( blockSize: Int, fgColor: CGColor, bgColor: CGColor ) {
        self.blockSize = blockSize
        self.fgColor   = fgColor
        self.bgColor   = bgColor
    }
    

    static func maxBlockSize( forImageSize: Int ) -> Int {
        return forImageSize / ( maxWidth + minWidth + midWidth )
    }
    
    static func minImageSize( forBlockSize bs: Int ) -> Int {
        return bs * maxWidth + bs * minWidth + bs * midWidth
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
        context.move(    to: CGPoint( x: 0.5, y: 2.5 ) )
        context.addLine( to: CGPoint( x: 3.5, y: 2.5 ) )
        context.addLine( to: CGPoint( x: 3.5, y: 4.5 ) )
        context.addLine( to: CGPoint( x: 1.5, y: 4.5 ) )
        context.addLine( to: CGPoint( x: 1.5, y: 6.5 ) )
        context.addLine( to: CGPoint( x: 5.5, y: 6.5 ) )
        context.addLine( to: CGPoint( x: 5.5, y: 2.5 ) )
    }


    func bendVertical( context: CGContext ) -> Void {
        context.saveGState()
        context.translateBy( x: CGFloat( maxWidth ) / 2, y: CGFloat( minWidth ) / 2 )
        context.rotate( by: -CGFloat.pi / 2 )
        context.translateBy( x: CGFloat( -maxWidth ) / 2, y: CGFloat( -minWidth ) / 2 )
        context.translateBy( x: 1.5, y: -1.5 )
        bendHorizontal( context: context )
        context.restoreGState()
    }
    
    
    func topLeft( context: CGContext ) -> Void {
        bendVertical( context: context )
        context.move(    to: CGPoint( x: 2.5, y: 6.5 ) )
        context.addLine( to: CGPoint( x: 8.5, y: 6.5 ) )
        context.addLine( to: CGPoint( x: 8.5, y: 2.5 ) )
        context.translateBy( x: CGFloat( maxWidth ), y: 0 )
    }
    
    
    func topRight( context: CGContext ) -> Void {
        bendHorizontal( context: context )
        context.addLine( to: CGPoint( x: 5.5, y: 0.5 ) )
        context.addLine( to: CGPoint( x: 1.5, y: 0.5 ) )
        context.translateBy( x: 0, y: CGFloat( -minWidth ) )
    }
    
    
    func horizontal( context: CGContext ) -> Void {
        bendHorizontal( context: context )

        context.translateBy( x: CGFloat( minWidth ), y: 0 )
    }
    
    
    func botLeft( context: CGContext ) -> Void {
        context.saveGState()
        context.translateBy( x: 3, y: 0 )
        bendHorizontal( context: context )
        context.addLines( between: [ CGPoint( x: -0.5, y: 2.5 ), CGPoint( x: -0.5, y: 7.5 ) ] )
        context.restoreGState()

        context.translateBy( x: CGFloat( maxWidth ), y: 0 )
    }
    
    
    func botRight( context: CGContext ) -> Void {
        context.saveGState()
        context.translateBy( x: -1, y: 2 )
        bendVertical( context: context )
        context.addLine( to: CGPoint( x: 1.5, y: 0.5 ) )
        context.restoreGState()

        context.translateBy( x: -1, y: CGFloat( midWidth ) )
    }
    
    
    func vertical( context: CGContext ) -> Void {
        bendVertical( context: context )

        context.translateBy( x: 0, y: CGFloat( minWidth ) )
    }
}
