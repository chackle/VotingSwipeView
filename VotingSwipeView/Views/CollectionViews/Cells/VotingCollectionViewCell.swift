//
//  VotingCollectionViewCell.swift
//  VotingSwipeView
//
//  Created by Michael Green on 20/08/2019.
//  Copyright © 2019 Michael Green. All rights reserved.
//

import UIKit

class VotingCollectionViewCell: UICollectionViewCell {

  private let lowestWidthRatio = CGFloat(0.3)
  private let lowestHeightRatio = CGFloat(0.25)
  
  @IBOutlet weak var panGestureView: UIView!
  @IBOutlet weak var homeView: TrapeziumView!
  @IBOutlet weak var awayView: TrapeziumView!
  @IBOutlet weak var leftSideWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var rightSideWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var centerViewHeightConstraint: NSLayoutConstraint!
  private var pageWidth: CGFloat {
    return self.contentView.bounds.width
  }
  private var currentSettledSide = Direction.neutral
  
  func setup() {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(VotingCollectionViewCell.handlePan(sender:)))
    self.panGestureView.addGestureRecognizer(gestureRecognizer)
    self.homeView.setup(withAngledSide: .right, andFillColor: .yellow)
    self.awayView.setup(withAngledSide: .left, andFillColor: .purple)
  }
  
  @objc func handlePan(sender: UIPanGestureRecognizer) {
    let settledSide = self.currentSettledSide
    
    // We increase the hitbox for the opposite states
    let middleRatio = settledSide == .neutral ? CGFloat(0.2) : CGFloat(0.8)
    
    let sideRatio = (1 - middleRatio) / 2
    let widthThreshold = self.panGestureView.bounds.width / 3
    let translation = sender.translation(in: self.panGestureView)
    var xTranslation = translation.x * 2
    switch settledSide {
    case .left:
      xTranslation = xTranslation + (widthThreshold * 3 - widthThreshold * sideRatio)
      break
    case .neutral:
      break
    case .right:
      xTranslation = xTranslation - (widthThreshold * 3 - widthThreshold * sideRatio)
      break
    }
    let direction: Direction = xTranslation < 0 ? .left : (xTranslation > 0 ? .right : .neutral)
    let absoluteXTranslation = abs(xTranslation)
    let expansionRatio = 1 - (absoluteXTranslation / (self.pageWidth + self.lowestWidthRatio * self.pageWidth))
    let heightExpansionRatio = self.lowestHeightRatio + (absoluteXTranslation / self.pageWidth)
    let midXPoint = self.awayView.frame.origin.x
    let homeAlpha = (midXPoint / (self.pageWidth / 2)) - (1 - (midXPoint - (midXPoint * self.lowestWidthRatio)) / (self.pageWidth - self.pageWidth * self.lowestWidthRatio))
    let awayAlpha = 1 - ((midXPoint / (self.pageWidth / 2)) - (1 - (midXPoint - (midXPoint * self.lowestWidthRatio)) / (self.pageWidth - self.pageWidth * self.lowestWidthRatio)) * 2)
    switch sender.state {
    case .changed:
      switch direction {
      case .left:
        self.homeView.alpha = homeAlpha
        self.awayView.alpha = 1
        self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: expansionRatio)
        self.leftSideWidthConstraint.priority = UILayoutPriority.defaultHigh
        self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: 1)
        self.rightSideWidthConstraint.priority = UILayoutPriority.defaultLow
        self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: heightExpansionRatio)
        break
      case .right:
        self.homeView.alpha = 1
        self.awayView.alpha = awayAlpha
        self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: 1)
        self.leftSideWidthConstraint.priority = UILayoutPriority.defaultLow
        self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: expansionRatio)
        self.rightSideWidthConstraint.priority = UILayoutPriority.defaultHigh
        self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: heightExpansionRatio)
        break
      case .neutral:
        break
      }
      break
    case .ended:
      self.currentSettledSide = self.currentViewPosition()
      switch self.currentSettledSide {
      case .left:
        UIView.animate(withDuration: 0.3) {
          self.homeView.alpha = 1
          self.awayView.alpha = 0
          self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: 1)
          self.leftSideWidthConstraint.priority = UILayoutPriority.defaultLow
          self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: self.lowestWidthRatio)
          self.rightSideWidthConstraint.priority = UILayoutPriority.defaultHigh
          self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: 1)
          self.panGestureView.layoutIfNeeded()
        }
        break
      case .neutral:
        UIView.animate(withDuration: 0.3) {
          self.homeView.alpha = 1
          self.awayView.alpha = 1
          self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: 1)
          self.leftSideWidthConstraint.priority = UILayoutPriority.defaultHigh
          self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: 1)
          self.rightSideWidthConstraint.priority = UILayoutPriority.defaultHigh
          self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: self.lowestHeightRatio)
          self.panGestureView.layoutIfNeeded()
        }
        break
      case .right:
        UIView.animate(withDuration: 0.3) {
          self.homeView.alpha = 0
          self.awayView.alpha = 1
          self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: self.lowestWidthRatio)
          self.leftSideWidthConstraint.priority = UILayoutPriority.defaultHigh
          self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: 1)
          self.rightSideWidthConstraint.priority = UILayoutPriority.defaultLow
          self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: 1)
          self.panGestureView.layoutIfNeeded()
        }
        break
      }
      break
    default:
      break
    }
  }
  
  private func currentViewPosition() -> Direction {
    let middleRatio = self.currentSettledSide == .neutral ? CGFloat(0.2) : CGFloat(0.8)
    let sideRatio = (1 - middleRatio) / 2
    let widthThreshold = self.panGestureView.bounds.width / 3
    let centerXPoint = self.awayView.frame.origin.x
    if centerXPoint < widthThreshold + widthThreshold * sideRatio {
      return Direction.right
    } else if centerXPoint > widthThreshold * 2 - widthThreshold * sideRatio {
      return Direction.left
    } else {
      return Direction.neutral
    }
  }
}

extension NSLayoutConstraint {
  /**
   Change multiplier constraint
   
   - parameter multiplier: CGFloat
   - returns: NSLayoutConstraint
   */
  func with(multiplier:CGFloat) -> NSLayoutConstraint {
    
    NSLayoutConstraint.deactivate([self])
    
    let newConstraint = NSLayoutConstraint(
      item: firstItem as AnyObject,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant)
    
    newConstraint.priority = priority
    newConstraint.shouldBeArchived = self.shouldBeArchived
    newConstraint.identifier = self.identifier
    
    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
  }
}

enum Direction {
  case left
  case right
  case neutral
}

