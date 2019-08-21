//
//  TrapeziumView.swift
//  VotingSwipeView
//
//  Created by Michael Green on 21/08/2019.
//  Copyright © 2019 Michael Green. All rights reserved.
//

import Foundation
import UIKit

class TrapeziumView: UIView {
  
  private let slantFactor = CGFloat(0.1)
  private var shapeLayer: CAShapeLayer?
  
  var angledSide = Direction.neutral
  var fillColor = UIColor.white
  
  func setup(withAngledSide angledSide: Direction, andFillColor fillColor: UIColor) {
    self.angledSide = angledSide
    self.fillColor = fillColor
    self.layer.masksToBounds = false
    self.clipsToBounds = false
    self.layoutIfNeeded()
    //self.updateLayer()
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext(), self.angledSide != .neutral  else { return }
    context.beginPath()
    switch self.angledSide {
    case .right:
      context.move(to: CGPoint(x: 0.0, y: 0.0))
      context.addLine(to: CGPoint(x: bounds.size.width, y: 0))
      context.addLine(to: CGPoint(x: bounds.size.width * (1 - self.slantFactor), y: bounds.size.height))
      context.addLine(to: CGPoint(x: 0, y: bounds.size.height))
    case .left:
      context.move(to: CGPoint(x: self.slantFactor * bounds.size.width, y: 0.0))
      context.addLine(to: CGPoint(x: bounds.size.width, y: 0))
      context.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
      context.addLine(to: CGPoint(x: 0, y: bounds.size.height))
    case .neutral:
      return
    }
    context.closePath()
    context.setFillColor(fillColor.cgColor)
    context.fillPath()
  }
  
//  func updateLayer() {
//    let path = CGMutablePath()
//    switch self.angledSide {
//    case .right:
//      path.move(to: CGPoint(x: 0.0, y: 0.0))
//      path.addLine(to: CGPoint(x: bounds.size.width * (1 + self.slantFactor), y: 0))
//      path.addLine(to: CGPoint(x: bounds.size.width * (1 - self.slantFactor), y: bounds.size.height))
//      path.addLine(to: CGPoint(x: 0, y: bounds.size.height))
//    case .left:
//      path.move(to: CGPoint(x: self.slantFactor * bounds.size.width, y: 0.0))
//      path.addLine(to: CGPoint(x: bounds.size.width, y: 0))
//      path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
//      path.addLine(to: CGPoint(x: -self.slantFactor * self.bounds.size.width, y: bounds.size.height))
//    case .neutral:
//      return
//    }
//    path.closeSubpath()
//
//    if self.shapeLayer == nil {
//      self.shapeLayer = CAShapeLayer()
//      self.shapeLayer?.fillColor = self.fillColor.cgColor
//      self.shapeLayer?.fillRule = .nonZero
//      self.layer.addSublayer(self.shapeLayer!)
//    }
//    self.shapeLayer?.path = path
//  }
}
