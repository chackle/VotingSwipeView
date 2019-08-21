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
  
  var angledSide = Direction.neutral
  var fillColor = UIColor.white
  
  func setup(withAngledSide angledSide: Direction, andFillColor fillColor: UIColor) {
    self.angledSide = angledSide
    self.fillColor = fillColor
    self.layoutIfNeeded()
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext(), self.angledSide != .neutral  else { return }
    context.beginPath()
    switch self.angledSide {
    case .right:
      context.move(to: CGPoint(x: 0.0, y: 0.0))
      context.addLine(to: CGPoint(x: bounds.size.width, y: 0))
      context.addLine(to: CGPoint(x: bounds.size.width * 0.9, y: bounds.size.height))
      context.addLine(to: CGPoint(x: 0, y: bounds.size.height))
    case .left:
      context.move(to: CGPoint(x: 0.1 * bounds.size.width, y: 0.0))
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
}
