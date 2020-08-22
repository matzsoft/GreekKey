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
        
        context.setFillColor( bgColor )
        context.fill( CGRect( x: 0, y: 0, width: context.width, height: context.height ) )
        context.setStrokeColor( fgColor )

        return context
    }
    
    
    func makeImage( context: CGContext? ) -> CGImage {
        context?.setLineWidth( 2 )
        context?.setLineCap( .square )
        context?.strokePath()
        guard let image = context?.makeImage() else {
            fatalError( "Unable to create image" )
        }
        
        return image
    }
    
    
    func greekKeyCell( row: Int, col: Int, nrows: Int, ncols: Int ) -> CGImage {
        switch ( row, col ) {
        case ( 0, 0 ):
            return topLeft
        case ( 0, ncols - 1 ):
            return topRight
        case ( 0, _ ):
            return horizontal
        case ( nrows - 1, 0 ):
            return botLeft
        case ( nrows - 1, ncols - 1 ):
            return botRight
        case ( nrows - 1, _ ):
            return horizontal
        case ( _, 0 ):
            return vertical
        case ( _, ncols - 1 ):
            return vertical
        default:
            return horizontal
        }
    }
    
    
    func bendHorizontal( context: CGContext? ) -> Void {
        context?.beginPath()
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
    
    
    lazy var topLeft: CGImage = {
        let context = setupContext( width: maxWidth, height: maxWidth )
        
        bendVertical( context: context )
        context?.move(    to: CGPoint( x:  5, y: 13 ) )
        context?.addLine( to: CGPoint( x: 17, y: 13 ) )
        context?.addLine( to: CGPoint( x: 17, y:  5 ) )

        return makeImage( context: context )
    }()
    
    
    lazy var topRight: CGImage = {
        let context = setupContext( width: midWidth, height: maxWidth )
        
        bendHorizontal( context: context )
        context?.move(    to: CGPoint( x:  3, y: 1 ) )
        context?.addLine( to: CGPoint( x: 11, y: 1 ) )
        context?.addLine( to: CGPoint( x: 11, y: 3 ) )

        return makeImage( context: context )
    }()
    
    
    lazy var horizontal: CGImage = {
        let context = setupContext( width: minWidth, height: maxWidth )
        
        bendHorizontal( context: context )

        return makeImage( context: context )
    }()
    
    
    lazy var botLeft: CGImage = {
        let context = setupContext( width: maxWidth, height: midWidth )
        
        context?.saveGState()
        context?.translateBy( x: 6, y: 0 )
        bendHorizontal( context: context )
        context?.restoreGState()
        context?.addLines( between: [ CGPoint( x: 5, y: 5 ), CGPoint( x: 5, y: 15 ) ] )

        return makeImage( context: context )
    }()
    
    
    lazy var botRight: CGImage = {
        let context = setupContext( width: midWidth, height: midWidth )
        
        context?.saveGState()
        context?.translateBy( x: -2, y: 4 )
        bendVertical( context: context )
        context?.restoreGState()
        context?.addLines( between: [ CGPoint( x: 1, y: 5 ), CGPoint( x: 3, y: 5 ) ] )

        return makeImage( context: context )
    }()
    
    
    lazy var vertical: CGImage = {
        let context = setupContext( width: maxWidth, height: minWidth )
        
        bendVertical( context: context )

        return makeImage( context: context )
    }()
}
