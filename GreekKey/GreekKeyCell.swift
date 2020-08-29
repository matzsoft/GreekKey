//
//  GreekKeyCell.swift
//  GreekKey
//
//  Created by Mark Johnson on 8/26/20.
//  Copyright © 2020 matzsoft. All rights reserved.
//

import Foundation

class GreekKeyCell {
    static var lowerLeft: GreekKeyCell {
        let width = CGFloat( 7 )
        let height = CGFloat( 6 )
        
        return GreekKeyCell( width: width, height: height ) {
            context in

            context.addLines( between: [ CGPoint( x: 0.5, y: 0.0 ), CGPoint( x: 0.5, y: 6.0 ) ] )
            context.translateBy( x: 1, y: 0 )
            self.bendHorizontal( context: context )
            context.translateBy( x: width - 1, y: 0 )
        }
    }
    
    static var horizontal: GreekKeyCell {
        let width = CGFloat( 6 )
        let height = CGFloat( 5 )
        
        return GreekKeyCell( width: width, height: height ) {
            context in

            self.bendHorizontal( context: context )
            context.translateBy( x: width, y: 0 )
        }
    }

    static var lowerRight: GreekKeyCell {
        let width = CGFloat( 6 )
        let height = CGFloat( 6 )
        
        return GreekKeyCell( width: width, height: height ) {
            context in
            
            context.addLines( between: [ CGPoint( x: 0.0, y: 0.5 ), CGPoint( x: 1.0, y: 0.5 ) ] )
            context.translateBy( x: 1, y: 0 )
            self.bendVertical( context: context )

            context.translateBy( x: 0, y: height )
        }
    }
    
    static var vertical: GreekKeyCell {
        let width = CGFloat( 5 )
        let height = CGFloat( 6 )
        
        return GreekKeyCell( width: width, height: height ) {
            context in
            
            self.bendVertical( context: context )
            context.translateBy( x: 0, y: height )
        }
    }
    
    static var upperLeft: GreekKeyCell {
        let width = CGFloat( 7 )
        let height = CGFloat( 7 )
        
        return GreekKeyCell( width: width, height: height ) {
            context in
            
            self.bendVertical( context: context )
            context.addLines( between: [ CGPoint( x: 0.0, y: 6.5 ), CGPoint( x: 7.0, y: 6.5 ) ] )
            context.addLines( between: [ CGPoint( x: 6.5, y: 6.0 ), CGPoint( x: 6.5, y: 2.0 ) ] )
            context.translateBy( x: width, y: 2 )
        }
    }
    
    static var upperRight: GreekKeyCell {
        let width = CGFloat( 6 )
        let height = CGFloat( 7 )
        
        return GreekKeyCell(width: width, height: height ) {
            context in
            
            self.bendHorizontal( context: context )
            context.addLines( between: [ CGPoint( x: 5.5, y: 0.0 ), CGPoint( x: 5.5, y: -2.0 ) ] )
            context.addLines( between: [ CGPoint( x: 5.0, y: -1.5 ), CGPoint( x: 1.0, y: -1.5 ) ] )
        }
    }
    
    let width:  CGFloat
    let height: CGFloat
    let draw:   ( CGContext ) -> Void
    
    private init( width: CGFloat, height: CGFloat, draw: @escaping ( CGContext ) -> Void ) {
        self.width  = width
        self.height = height
        self.draw   = draw
    }
    
    private static func bendHorizontal( context: CGContext ) -> Void {
        context.addLines( between: [ CGPoint( x: 0.0, y: 0.5 ), CGPoint( x: 4.0, y: 0.5 ) ] )
        context.addLines( between: [ CGPoint( x: 3.5, y: 1.0 ), CGPoint( x: 3.5, y: 3.0 ) ] )
        context.addLines( between: [ CGPoint( x: 3.0, y: 2.5 ), CGPoint( x: 1.0, y: 2.5 ) ] )
        context.addLines( between: [ CGPoint( x: 1.5, y: 3.0 ), CGPoint( x: 1.5, y: 5.0 ) ] )
        context.addLines( between: [ CGPoint( x: 2.0, y: 4.5 ), CGPoint( x: 6.0, y: 4.5 ) ] )
        context.addLines( between: [ CGPoint( x: 5.5, y: 4.0 ), CGPoint( x: 5.5, y: 0.0 ) ] )
    }
    

    private static func bendVertical( context: CGContext ) -> Void {
        context.saveGState()
        context.rotate( by: -CGFloat.pi / 2 )
        context.translateBy( x: -6, y: 0 )                  // should the 6 be a let constant?
        bendHorizontal( context: context )
        context.restoreGState()
    }
}
