//
//  GreekKeyCells.swift
//  GreekKey
//
//  Created by Mark Johnson on 7/29/19.
//  Copyright © 2019 matzsoft. All rights reserved.
//

import Foundation

class GreekKeyCells {
    let blockWidth: Int
    let fgColor:    CGColor
    let bgColor:    CGColor
    let minWidth:   Int
    let midWidth:   Int
    let maxWidth:   Int
    let colorSpace: CGColorSpace
    var context:    CGContext?

    init( blockWidth: Int, fgColor: CGColor, bgColor: CGColor ) {
        self.blockWidth = blockWidth
        self.fgColor    = fgColor
        self.bgColor    = bgColor
        
        minWidth   = 6
        midWidth   = 8
        maxWidth   = 9
        colorSpace = CGColorSpace( name: CGColorSpace.sRGB )!
    }
    

    func setupContext( width: Int, height: Int ) -> Void {
        let userWidth = blockWidth * width
        let userHeight = blockWidth * height
        
        guard let context = CGContext( data: nil, width: userWidth, height: userHeight,
                                       bitsPerComponent: 8, bytesPerRow: 4 * userWidth, space: colorSpace,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue )
        else { return }
            
        context.interpolationQuality = .high
        context.setAllowsAntialiasing( true )
        context.scaleBy( x: CGFloat(blockWidth), y: CGFloat(blockWidth) )
        
        context.setFillColor( bgColor )
        context.fill( CGRect( x: 0, y: 0, width: context.width, height: context.height ) )
        context.setFillColor( fgColor )

        self.context = context
    }
    
    
    func makeImage() -> CGImage {
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
    
    
    func bendHorizontal() -> Void {
        context?.beginPath()
        context?.move(    to: CGPoint( x: 0, y: 2 ) )
        context?.addLine( to: CGPoint( x: 4, y: 2 ) )
        context?.addLine( to: CGPoint( x: 4, y: 5 ) )
        context?.addLine( to: CGPoint( x: 2, y: 5 ) )
        context?.addLine( to: CGPoint( x: 2, y: 6 ) )
        context?.addLine( to: CGPoint( x: 5, y: 6 ) )
        context?.addLine( to: CGPoint( x: 5, y: 2 ) )
        context?.addLine( to: CGPoint( x: 6, y: 2 ) )
        context?.addLine( to: CGPoint( x: 6, y: 7 ) )
        context?.addLine( to: CGPoint( x: 1, y: 7 ) )
        context?.addLine( to: CGPoint( x: 1, y: 4 ) )
        context?.addLine( to: CGPoint( x: 3, y: 4 ) )
        context?.addLine( to: CGPoint( x: 3, y: 3 ) )
        context?.addLine( to: CGPoint( x: 0, y: 3 ) )
        context?.closePath();
        context?.fillPath()
    }


    func bendVertical() -> Void {
        context?.saveGState()
        context?.translateBy( x: CGFloat( maxWidth / 2 ), y: CGFloat( minWidth / 2 ) )
        context?.rotate( by: -CGFloat.pi / 2 )
        context?.translateBy( x: CGFloat( -maxWidth / 2 ), y: CGFloat( -minWidth / 2 ) )
        context?.translateBy( x: 1, y: -1 )
        bendHorizontal()
        context?.restoreGState()
    }
    
    
    lazy var topLeft: CGImage = {
        setupContext( width: maxWidth, height: maxWidth )
        context?.saveGState()
        bendVertical()
        context?.restoreGState()
        context?.fill( CGRect( x: 0, y: 0, width: 1, height: 9 ) )
        context?.fill( CGRect( x: 0, y: 8, width: 9, height: 1 ) )
        context?.fill( CGRect( x: 2, y: 6, width: 7, height: 1 ) )
        context?.fill( CGRect( x: 8, y: 2, width: 1, height: 5 ) )
        context?.fill( CGRect( x: 8, y: 0, width: 1, height: 1 ) )

        return makeImage()
    }()
    
    
    lazy var topRight: CGImage = {
        setupContext( width: midWidth, height: maxWidth )
        bendHorizontal()
        context?.fill( CGRect( x: 0, y: 8, width: 8, height: 1 ) )
        context?.fill( CGRect( x: 7, y: 0, width: 1, height: 9 ) )
        context?.fill( CGRect( x: 1, y: 0, width: 5, height: 1 ) )
        context?.fill( CGRect( x: 5, y: 1, width: 1, height: 1 ) )

        return makeImage()
    }()
    
    
    lazy var horizontal: CGImage = {
        setupContext( width: minWidth, height: maxWidth )
        bendHorizontal()
        context?.fill( CGRect( x: 0, y: 0, width: 6, height: 1 ) )
        context?.fill( CGRect( x: 0, y: 8, width: 6, height: 1 ) )

        return makeImage()
    }()
    
    
    lazy var botLeft: CGImage = {
        setupContext( width: maxWidth, height: midWidth )
        context?.saveGState()
        context?.translateBy( x: 3, y: 0 )
        bendHorizontal()
        context?.restoreGState()
        context?.fill( CGRect( x: 0, y: 0, width: 9, height: 1 ) )
        context?.fill( CGRect( x: 0, y: 0, width: 1, height: 8 ) )
        context?.fill( CGRect( x: 2, y: 2, width: 1, height: 6 ) )

        return makeImage()
    }()
    
    
    lazy var botRight: CGImage = {
        setupContext( width: midWidth, height: midWidth )
        context?.saveGState()
        context?.translateBy( x: -1, y: 2 )
        bendVertical()
        context?.restoreGState()
        context?.fill( CGRect( x: 0, y: 0, width: 8, height: 1 ) )
        context?.fill( CGRect( x: 7, y: 0, width: 1, height: 8 ) )
        context?.fill( CGRect( x: 0, y: 2, width: 1, height: 1 ) )

        return makeImage()
    }()
    
    
    lazy var vertical: CGImage = {
        setupContext( width: maxWidth, height: minWidth )
        bendVertical()
        context?.fill( CGRect( x: 0, y: 0, width: 1, height: 6 ) )
        context?.fill( CGRect( x: 8, y: 0, width: 1, height: 6 ) )

        return makeImage()
    }()
}
