//
//  TrapezeView.swift
//  VotingView
//
//  Created by Fabricio Oliveira on 2019-08-21.
//  Copyright © 2019 Strafe AB. All rights reserved.
//

import Foundation
import UIKit

@objc enum Direction: Int {
  case right = 0
  case left = 1
}

class TrapeziumView : UIView {
  
  @IBInspectable open var angle: Double {
    get {
      return self.angleRad
    }
    set(number) {
      self.angleRad = number.degreesToRadians
    }
  }
  
  @IBInspectable var directionValue: Int {
    get {
      return self.direction.rawValue
    }
    set(shapeIndex) {
      self.direction = Direction(rawValue: shapeIndex) ?? .right
    }
  }
  
  @IBInspectable open var fillColor: UIColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
  
  private var touchesEnable = true
  private var direction: Direction = .right
  private var angleRad: Double = .pi
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.beginPath()
    switch direction {
    case .right:
      context.move(to: CGPoint(x: 0.0, y: 0.0))
      context.addLine(to: CGPoint(x: 0.0, y: frame.size.height))
      context.addLine(to: CGPoint(x: frame.size.width / CGFloat(angleRad), y: frame.size.height))
      context.addLine(to: CGPoint(x: frame.size.width, y: 0.0))
    case .left:
      context.move(to: CGPoint(x: frame.size.width, y: 0.0))
      context.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
      context.addLine(to: CGPoint(x: 0.0, y: frame.size.height))
      context.addLine(to: CGPoint(x: frame.size.width - (frame.size.width / CGFloat(angleRad)), y: 0.0))
    }
    context.closePath()
    context.setFillColor(fillColor.cgColor)
    context.fillPath()
  }

}

class DoubleTrapeziumView : UIView {
  
  @IBInspectable open var angle: Double {
    get {
      return self.angleRad
    }
    set(number) {
      self.angleRad = number.degreesToRadians
    }
  }
  
  @IBInspectable var directionValue: Int {
    get {
      return self.direction.rawValue
    }
    set(shapeIndex) {
      self.direction = Direction(rawValue: shapeIndex) ?? .right
    }
  }
  
  @IBInspectable open var fillColor: UIColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
  
  private var touchesEnable = true
  private var direction: Direction = .right
  private var angleRad: Double = .pi
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.beginPath()

    context.move(to: CGPoint(x: 0.0, y: 0.0))
    context.addLine(to: CGPoint(x: 0.0, y: frame.size.height))
    context.addLine(to: CGPoint(x: (frame.size.width / 2) / CGFloat(angleRad), y: frame.size.height))
    context.addLine(to: CGPoint(x: (frame.size.width / 2) * CGFloat(angleRad), y: 0.0))

  
    context.closePath()
    context.setFillColor(fillColor.cgColor)
    context.fillPath()
    
    context.beginPath()

    context.move(to: CGPoint(x: frame.size.width, y: 0.0))
    context.addLine(to: CGPoint(x: (frame.size.width / 2) * CGFloat(angleRad), y: 0.0))
    context.addLine(to: CGPoint(x: (frame.size.width / 2) / CGFloat(angleRad), y: frame.size.height))
    context.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))

    context.closePath()
    context.setFillColor(UIColor.red.cgColor)
    context.fillPath()
    
  }
  
}

extension FloatingPoint {
  var degreesToRadians: Self { return self * .pi / 180 }
  var radiansToDegrees: Self { return self * 180 / .pi }
}
