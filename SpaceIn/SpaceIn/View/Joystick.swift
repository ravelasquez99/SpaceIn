//
//  CDJoystick.swift
//  CDJoystick
//
//  Created by Cole Dunsby on 2015-12-21.
//  Copyright © 2016 Cole Dunsby. All rights reserved.
//
import UIKit

public struct CDJoystickData: CustomStringConvertible {
    
    /// (-1.0, -1.0) at bottom left to (1.0, 1.0) at top right
    public var velocity: CGPoint = .zero
    
    /// 0 at top middle to 6.28 radians going around clockwise
    public var angle: CGFloat = 0.0
    
    public var description: String {
        return "velocity: \(velocity), angle: \(angle)"
    }
}

@IBDesignable
public class CDJoystick: UIView {
    
    @IBInspectable public var substrateColor: UIColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1) { didSet { setNeedsDisplay() }}
    @IBInspectable public var substrateBorderColor: UIColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1) { didSet { setNeedsDisplay() }}
    @IBInspectable public var substrateBorderWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() }}
    
    @IBInspectable public var stickSize: CGSize = CGSize(width: 50, height: 50) { didSet { setNeedsDisplay() }}
    @IBInspectable public var stickColor: UIColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1) { didSet { setNeedsDisplay() }}
    @IBInspectable public var stickBorderColor: UIColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1) { didSet { setNeedsDisplay() }}
    @IBInspectable public var stickBorderWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() }}
    
    @IBInspectable public var fade: CGFloat = 1.0 { didSet { setNeedsDisplay() }}
    
    public var trackingHandler: ((CDJoystickData) -> Void)?
    
    private var data = CDJoystickData()
    private var stickView = UIView(frame: .zero)
    private var displayLink: CADisplayLink?
    
    private var tracking = false {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.alpha = self.tracking ? 1.0 : self.fade
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        displayLink = CADisplayLink(target: self, selector: #selector(listen))
        displayLink?.add(to: .current, forMode: .commonModes)
    }
    
    public func listen() {
        guard tracking else { return }
        trackingHandler?(data)
    }
    
    public override func draw(_ rect: CGRect) {
        alpha = fade
        
        layer.backgroundColor = substrateColor.cgColor
        layer.borderColor = substrateBorderColor.cgColor
        layer.borderWidth = substrateBorderWidth
        layer.cornerRadius = bounds.width / 2
        
        stickView.frame = CGRect(origin: .zero, size: stickSize)
        stickView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        stickView.layer.backgroundColor = stickColor.cgColor
        stickView.layer.borderColor = stickBorderColor.cgColor
        stickView.layer.borderWidth = stickBorderWidth
        stickView.layer.cornerRadius = stickSize.width / 2
        
        if let superview = stickView.superview {
            superview.bringSubview(toFront: stickView)
        } else {
            addSubview(stickView)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tracking = true
        
        UIView.animate(withDuration: 0.1) {
            self.touchesMoved(touches, with: event)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let centerXPosition = bounds.size.width / 2
        let centerYPosition = bounds.size.height / 2
        let newPoint = CGPoint(x: location.x - centerXPosition, y: centerYPosition - location.y)
        //print("new point: \(newPoint)")
        
        let hypoteneuse = sqrt(pow(newPoint.x, 2) + pow(newPoint.y, 2))
        
        let innerCircleHeight = self.stickView.frame.height
        let outerCircleHeight = self.frame.height
        
        let padding = outerCircleHeight - self.substrateBorderWidth - innerCircleHeight - self.stickView.layer.borderWidth - 12.5
        
        if hypoteneuse <= padding && hypoteneuse >= padding / 2 {
            print("we are moving from to x:\(newPoint.x) y: \(newPoint.y)) ")
            stickView.center = CGPoint(x: newPoint.x + centerXPosition, y: centerYPosition - newPoint.y)
        } else if hypoteneuse > padding {
            print("we are big")
            let bearingRadians = atan2(newPoint.y, newPoint.x) // get bearing in radians
            var bearingDegrees = bearingRadians * CGFloat((180.0 / M_PI)) // convert to degrees
            bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)) // correct discontinuity
            //print("degrees ==== \(bearingDegrees)")
            
            var degrees = bearingRadians * CGFloat((180.0 / M_PI))
            degrees = degrees < 0 ? degrees + 180 : degrees
            
            let sinOF = sin(bearingRadians)
            
            let generatedY =  padding * sinOF
            let generatedX = padding * cos(bearingRadians)
            
            let finalPoint = CGPoint(x: generatedX + centerXPosition, y: centerYPosition - generatedY)
            stickView.center = finalPoint

        }
        
        let x = clamp(newPoint.x, lower: -bounds.size.width / 2, upper: bounds.size.width / 2) / (bounds.size.width / 2)
        let y = clamp(newPoint.y, lower: -bounds.size.height / 2, upper: bounds.size.height / 2) / (bounds.size.height / 2)
        
        data = CDJoystickData(velocity: CGPoint(x: x, y: y), angle: -atan2(x, y) + CGFloat(M_PI))
    }
    
    func xLimit(y: CGFloat, padding: CGFloat) -> CGFloat {
        
        let paddingSq = pow(padding, 2)
        let ySq = pow(y, 2)
        let difference = paddingSq - ySq
        
        return sqrt(abs(difference))
    }
    
    func yLimit(x: CGFloat, padding: CGFloat) -> CGFloat {
        
        return sqrt(abs(pow(padding, 2) - pow(x, 2)))
    }
    
    func limitedCoordinate(x: CGFloat, y: CGFloat, padding: CGFloat) -> CGPoint {
        
        var newX = x
        var newY = y
        
        let xLim = xLimit(y: y, padding: padding)
        if abs(x) > xLim {
            
            if x < 0 {
                newX = xLim * -1
            } else {
                newX = xLim
            }
        }
        
        let yLim = yLimit(x: x, padding: padding)
        if abs(y) > yLim {
            
            if y < 0 {
                newY = yLim * -1
            } else {
                newY = yLim
            }
        }
        
        return CGPoint(x: CGFloat(newX), y: CGFloat(newY))
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        reset()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        reset()
    }
    
    private func reset() {
        tracking = false
        data = CDJoystickData()
        
        UIView.animate(withDuration: 0.25) {
            self.stickView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        }
    }
    
    private func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }
}
