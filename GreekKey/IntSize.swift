//
//  IntSize.swift
//  GreekKey
//
//  Created by Mark Johnson on 8/28/20.
//  Copyright © 2020 matzsoft. All rights reserved.
//

import Foundation

struct IntSize {
    var width: Int
    var height: Int
    
    internal init( width: Int, height: Int ) {
        self.width = width
        self.height = height
    }
    
    internal init( width: CGFloat, height: CGFloat ) {
        self.init( width: Int( width ), height: Int( height ) )
    }
    
    internal init( size: CGSize ) {
        self.init( width: size.width, height: size.height )
    }
    
    internal init( rect: CGRect ) {
        self.init( width: rect.width, height: rect.height )
    }
}

func *( multiplier: Int, multiplicand: IntSize ) -> IntSize {
    return IntSize( width: multiplier * multiplicand.width, height: multiplier * multiplicand.height )
}

