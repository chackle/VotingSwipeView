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
  @IBOutlet weak var adaptVotingGearView: AdaptVotingGearView!

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
    self.contentView.addGestureRecognizer(gestureRecognizer)
    let color = UIColor(red: 255/255.0, green: 155/255.0, blue: 0, alpha: 1.0)
    self.homeView.setup(withAngledSide: .right, andFillColor: color)
    self.awayView.setup(withAngledSide: .left, andFillColor: color)
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
    
   // let location = sender.location(in: self.panGestureView)
   // let percentage = 1.0 - (location.x / (self.panGestureView.bounds.size.width / 2))

    //print(percentage)
    //let midXPoint = self.awayView.frame.origin.x

   // let homeAlpha = 1 - abs(((midXPoint / (self.pageWidth / 2)) - (1 - (midXPoint - (midXPoint * self.lowestWidthRatio)) / (self.pageWidth - self.pageWidth * (self.lowestWidthRatio)) * 2)))
    
    //let awayAlpha = 1 - abs(((midXPoint / (self.pageWidth / 2)) - (1 - (midXPoint - (midXPoint * self.lowestWidthRatio)) / (self.pageWidth - self.pageWidth * self.lowestWidthRatio)) * 2))
    
    ///print("home \(homeAlpha) - awayAlpha \(awayAlpha)")

    switch sender.state {
    case .changed:
      switch direction {
      case .left:
        //print(expansionRatio)
        let alpha = (expansionRatio - lowestWidthRatio).clamped(to: 0...1)
        self.homeView.alpha = alpha
        self.awayView.alpha = 1
        self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: expansionRatio)
        self.leftSideWidthConstraint.priority = UILayoutPriority.defaultHigh
        self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: 1)
        self.rightSideWidthConstraint.priority = UILayoutPriority.defaultLow
        self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: heightExpansionRatio)
        self.adaptVotingGearView.selectingAway(expansionRatio: expansionRatio, alpha: 1 - alpha)

        break
      case .right:
        let alpha = (expansionRatio - lowestWidthRatio).clamped(to: 0...1)
        self.homeView.alpha = 1
        self.awayView.alpha = alpha
        self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: 1)
        self.leftSideWidthConstraint.priority = UILayoutPriority.defaultLow
        self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: expansionRatio)
        self.rightSideWidthConstraint.priority = UILayoutPriority.defaultHigh
        self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: heightExpansionRatio)
        self.adaptVotingGearView.selectingHome(expansionRatio: expansionRatio, alpha: 1 - alpha)

        break
      case .neutral:
        break
      }
      break
    case .ended:
      self.currentSettledSide = self.currentViewPosition()
      switch self.currentSettledSide {
      case .left:
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
          self.homeView.alpha = 1
          self.awayView.alpha = 0
          self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: 1)
          self.leftSideWidthConstraint.priority = UILayoutPriority.defaultLow
          self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: self.lowestWidthRatio)
          self.rightSideWidthConstraint.priority = UILayoutPriority.defaultHigh
          self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: 1)
          self.adaptVotingGearView.selectedHome()
          self.adaptVotingGearView.layoutIfNeeded()
          self.panGestureView.layoutIfNeeded()
        }, completion: nil)
        break
      case .neutral:
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
          self.homeView.alpha = 1
          self.awayView.alpha = 1
          self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: 1)
          self.leftSideWidthConstraint.priority = UILayoutPriority.defaultHigh
          self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: 1)
          self.rightSideWidthConstraint.priority = UILayoutPriority.defaultHigh
          self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: self.lowestHeightRatio)
          self.adaptVotingGearView.selectedNone()
          self.adaptVotingGearView.layoutIfNeeded()
          self.panGestureView.layoutIfNeeded()
        }, completion: nil)
        break
      case .right:
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
          self.homeView.alpha = 0
          self.awayView.alpha = 1
          self.leftSideWidthConstraint = self.leftSideWidthConstraint.with(multiplier: self.lowestWidthRatio)
          self.leftSideWidthConstraint.priority = UILayoutPriority.defaultHigh
          self.rightSideWidthConstraint = self.rightSideWidthConstraint.with(multiplier: 1)
          self.rightSideWidthConstraint.priority = UILayoutPriority.defaultLow
          self.centerViewHeightConstraint = self.centerViewHeightConstraint.with(multiplier: 1)
          self.adaptVotingGearView.selectedAway()
          self.adaptVotingGearView.layoutIfNeeded()
          self.panGestureView.layoutIfNeeded()

        }, completion: nil)
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

enum Direction {
  case left
  case right
  case neutral
}


extension VotingCollectionViewCell: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return true
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
