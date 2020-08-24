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
    
    
    func setupContext( width: Int, height: Int ) -> CGContext? {
        let userWidth  = blockSize * width
        let userHeight = blockSize * height
        
        guard let context = CGContext( data: nil, width: userWidth, height: userHeight,
                                       bitsPerComponent: 8, bytesPerRow: 4 * userWidth, space: colorSpace,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue )
        else { return nil }
            
        context.interpolationQuality = .high
        context.setAllowsAntialiasing( true )
        context.scaleBy( x: CGFloat(blockSize) / 2, y: CGFloat(blockSize) / 2 )
        
        context.setStrokeColor( fgColor )

        return context
    }
    
    
    func makeImage( context: CGContext? ) -> CGPath {
        context?.setLineWidth( 2 )
        context?.setLineCap( .square )
//        context?.strokePath()
        context?.replacePathWithStrokedPath()
//        guard let image = context?.makeImage() else {
//            fatalError( "Unable to create image" )
//        }
        
        return context!.path!
    }
    
    
    func bendHorizontal( context: CGContext? ) -> Void {
        context?.move(    to: CGPoint( x:  1, y:  5 ) )
        context?.addLine( to: CGPoint( x:  7, y:  5 ) )
        context?.addLine( to: CGPoint( x:  7, y:  9 ) )
        context?.addLine( to: CGPoint( x:  3, y:  9 ) )
        context?.addLine( to: CGPoint( x:  3, y: 13 ) )
        context?.addLine( to: CGPoint( x: 11, y: 13 ) )
        context?.addLine( to: CGPoint( x: 11, y:  5 ) )
    }


    func bendVertical( context: CGContext? ) -> Void {
        context?.saveGState()
        context?.translateBy( x: CGFloat( maxWidth ), y: CGFloat( minWidth ) )
        context?.rotate( by: -CGFloat.pi / 2 )
        context?.translateBy( x: CGFloat( -maxWidth ), y: CGFloat( -minWidth ) )
        context?.translateBy( x: 3, y: -3 )
        bendHorizontal( context: context )
        context?.restoreGState()
    }
    
    
    func topLeft( context: CGContext ) -> Void {
        bendVertical( context: context )
        context.move(    to: CGPoint( x:  5, y: 13 ) )
        context.addLine( to: CGPoint( x: 17, y: 13 ) )
        context.addLine( to: CGPoint( x: 17, y:  5 ) )
        context.translateBy( x: CGFloat( 2 * maxWidth ), y: 0 )
    }
    
    
    func topRight( context: CGContext ) -> Void {
        bendHorizontal( context: context )
        context.addLine( to: CGPoint( x: 11, y: 1 ) )
        context.addLine( to: CGPoint( x:  3, y: 1 ) )
        context.translateBy( x: 0, y: CGFloat( -2 * minWidth ) )
    }
    
    
    func horizontal( context: CGContext ) -> Void {
        bendHorizontal( context: context )

        context.translateBy( x: CGFloat( 2 * minWidth ), y: 0 )
    }
    
    
    func botLeft( context: CGContext ) -> Void {
        context.saveGState()
        context.translateBy( x: 6, y: 0 )
        bendHorizontal( context: context )
        context.addLines( between: [ CGPoint( x: -1, y: 5 ), CGPoint( x: -1, y: 15 ) ] )
        context.restoreGState()

        context.translateBy( x: CGFloat( 2 * maxWidth ), y: 0 )
    }
    
    
    func botRight( context: CGContext ) -> Void {
        context.saveGState()
        context.translateBy( x: -2, y: 4 )
        bendVertical( context: context )
        context.addLine( to: CGPoint( x: 3, y: 1 ) )
        context.restoreGState()

        context.translateBy( x: -2, y: CGFloat( 2 * midWidth ) )
    }
    
    
    func vertical( context: CGContext ) -> Void {
        bendVertical( context: context )

        context.translateBy( x: 0, y: CGFloat( 2 * minWidth ) )
    }
}
