//
//  CircleView.swift
//  whereaboats
//
//  Created by Michael on 2016-10-07.
//  Copyright © 2016 Michael Gubik. All rights reserved.
//

import UIKit

class CircleView : UIView {
    var color: CGColor? {
        didSet {
            drawRingFittingInsideView()
        }
    }
    
    override func awakeFromNib() {
        drawRingFittingInsideView()
    }

    internal func drawRingFittingInsideView() {
        let halfSize : CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize, y:halfSize),
            radius: CGFloat( 3.625 ),
            startAngle: CGFloat(0),
            endAngle: CGFloat(CGFloat.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = color ?? UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0
    
        for sublayer in layer.sublayers ?? [] {
            sublayer.removeFromSuperlayer()
        }
        layer.addSublayer(shapeLayer)
    }
}
