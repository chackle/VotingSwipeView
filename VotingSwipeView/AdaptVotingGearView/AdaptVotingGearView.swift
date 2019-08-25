//
//  AdaptVotingGearView.swift
//  AdaptVotingGearView
//
//  Created by Fabricio Oliveira on 2019-08-22.
//  Copyright © 2019 Strafe AB. All rights reserved.
//

import UIKit

enum EnumVotingMode: Int {
  case none
  case home
  case tie
  case away
}

class AdaptVotingGearView: UIView {
  
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var collectionGear: UICollectionView!
  @IBOutlet weak var collectionHome: UICollectionView!
  @IBOutlet weak var collectionTie: UICollectionView!
  @IBOutlet weak var collectionAway: UICollectionView!
  
  @IBOutlet weak var labelHomeName: UILabel!
  @IBOutlet weak var labelAwayName: UILabel!
  @IBOutlet weak var labelTieName: UILabel!
  
  @IBOutlet weak var imageViewHomeLogo: UIImageView!
  @IBOutlet weak var imageViewTieLogo: UIImageView!
  @IBOutlet weak var imageViewAwayLogo: UIImageView!
  
  @IBOutlet weak var labelHomePoints: UILabel!
  @IBOutlet weak var labelAwayPoints: UILabel!
  @IBOutlet weak var labelTiePoints: UILabel!

  @IBOutlet weak var constraintCollectionGear: NSLayoutConstraint!
  @IBOutlet weak var constraintCollectionGearLeading: NSLayoutConstraint!
  @IBOutlet weak var constraintCollectionGearHeight: NSLayoutConstraint!
  
  @IBOutlet weak var constraintTie: NSLayoutConstraint!
  @IBOutlet weak var constraintRatioHomeToAway: NSLayoutConstraint!
  @IBOutlet weak var constraintRatioAwayToHome: NSLayoutConstraint!
  
  @IBOutlet weak var constraintHomeHeight: NSLayoutConstraint!
  @IBOutlet weak var viewGear: UIView!
  @IBOutlet weak var viewAway: UIView!
  @IBOutlet weak var viewHome: UIView!
  @IBOutlet weak var viewTie: UIView!
  
  private var votingMode: EnumVotingMode = .none {
    didSet {
      animateToVoting(mode: self.votingMode)
    }
  }
  
  private var canTie = false
  private var expansionRatio: CGFloat = 1.0
  
  private var heightConstantRight: CGFloat {
    return 1 + ((1 - expansionRatio) * 0.6)
  }
  
  private var heightConstantLeft: CGFloat {
    return 1 + ((1 - expansionRatio) * 0.4)
  }
  
  private var tieNormalSizeConstant: CGFloat {
    return canTie ? bounds.width * normalSizeRatio: 0.0
  }
  
  private var tieSmallSizeConstant: CGFloat {
    return canTie ? bounds.width * smallSizeRatio: 0.0
  }
  
  private var tieBigSizeConstant: CGFloat {
    return canTie ? bigSizeConstant: 0.0
  }
  
  private var bigSizeConstant: CGFloat {
    return (bounds.width * bigSizeRatio)
  }
  
  private var normalSizeRatio: CGFloat  {
    return (canTie ? 0.333:0.5)
  }
  
  private var bigSizeRatio: CGFloat  {
    return (canTie ? 0.45:0.8)
  }
  
  private var smallSizeRatio: CGFloat {
    let divider: CGFloat = canTie == true ? 0.5:1.0
    return ((1.0 - bigSizeRatio) * divider)
  }
  
  private let minimumRatio: CGFloat = 0.25
  private let maximumRatio: CGFloat = 1.0
  
  private var leadingConstant: CGFloat {
    let divider: CGFloat = canTie == true ? 0.5:1.0
    let multiplier: CGFloat = canTie == true ? 2:1.0
    return ((1.0 - bigSizeRatio) * divider * multiplier)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    reloadLayouts()
  }
  
  func setup() {
    Bundle.main.loadNibNamed("AdaptVotingGearView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionHome.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionTie.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionGear.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionAway.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionHome.register(UINib(nibName: "AdaptVotingLogoCell", bundle: nil), forCellWithReuseIdentifier: "AdaptVotingLogoCell")
    collectionHome.register(UINib(nibName: "AdaptVotingPointsCell", bundle: nil), forCellWithReuseIdentifier: "AdaptVotingPointsCell")
    collectionTie.register(UINib(nibName: "AdaptVotingLogoCell", bundle: nil), forCellWithReuseIdentifier: "AdaptVotingLogoCell")
    collectionTie.register(UINib(nibName: "AdaptVotingPointsCell", bundle: nil), forCellWithReuseIdentifier: "AdaptVotingPointsCell")
    collectionAway.register(UINib(nibName: "AdaptVotingLogoCell", bundle: nil), forCellWithReuseIdentifier: "AdaptVotingLogoCell")
    collectionAway.register(UINib(nibName: "AdaptVotingPointsCell", bundle: nil), forCellWithReuseIdentifier: "AdaptVotingPointsCell")
    collectionGear.register(UINib(nibName: "AdaptVotingPointsCell", bundle: nil), forCellWithReuseIdentifier: "AdaptVotingPointsCell")
    votingMode = .none
  }
  
  private func animateToVoting(mode: EnumVotingMode) {
    collectionHome.alpha = 0.0
    collectionTie.alpha = 0.0
    collectionAway.alpha = 0.0
    collectionGear.alpha = 0.0
    select(mode: mode)
  }
  
  private func select(mode: EnumVotingMode) {
    DispatchQueue.main.async {
      switch mode {
      case .none:
        self.selectedNone()
      case .home:
        self.selectedHome()
      case .away:
        self.selectedAway()
      case .tie:
        self.selectedTie()
      }
    }
  }
  
  func selectingAway(expansionRatio: CGFloat, alpha: CGFloat) {
    self.expansionRatio = expansionRatio
    constraintRatioHomeToAway = constraintRatioHomeToAway.with(multiplier: expansionRatio.clamped(to: smallSizeRatio...bigSizeRatio))
    constraintRatioHomeToAway.priority = UILayoutPriority.defaultHigh
    constraintRatioAwayToHome = constraintRatioAwayToHome.with(multiplier: 1)
    constraintRatioAwayToHome.priority = UILayoutPriority.defaultLow
    constraintCollectionGearLeading.constant = bounds.width * leadingConstant
    collectionGear.alpha = alpha
    collectionHome.alpha = alpha
    collectionTie.alpha = canTie ? alpha:0.0
    collectionAway.alpha = 0.0
    constraintHomeHeight = constraintHomeHeight.with(multiplier: heightConstantRight)
    reloadLayouts()
  }
  
  func selectingHome(expansionRatio: CGFloat, alpha: CGFloat) {
    self.expansionRatio = expansionRatio
    constraintRatioAwayToHome = constraintRatioAwayToHome.with(multiplier: expansionRatio.clamped(to: smallSizeRatio...bigSizeRatio))
    constraintRatioAwayToHome.priority = UILayoutPriority.defaultHigh
    constraintRatioHomeToAway = constraintRatioHomeToAway.with(multiplier: 1)
    constraintRatioHomeToAway.priority = UILayoutPriority.defaultLow
    constraintCollectionGearLeading.constant = 0.0
    collectionGear.alpha = alpha
    collectionAway.alpha = alpha
    collectionTie.alpha = canTie ? alpha:0.0
    collectionHome.alpha = 0.0
    constraintHomeHeight = constraintHomeHeight.with(multiplier: heightConstantRight)
    reloadLayouts()
  }
  
  func selectedNone() {
    expansionRatio = minimumRatio
    constraintCollectionGear.constant = bigSizeConstant
    constraintCollectionGearLeading.constant = 0.0
    constraintRatioHomeToAway = constraintRatioHomeToAway.with(multiplier: 1.0)
    constraintRatioAwayToHome = constraintRatioAwayToHome.with(multiplier: 1.0)
    constraintRatioHomeToAway.priority = .defaultHigh
    constraintRatioAwayToHome.priority = .defaultHigh
    constraintTie.constant = tieNormalSizeConstant
    constraintHomeHeight = constraintHomeHeight.with(multiplier: 1.0)
    collectionHome.alpha = 0.0
    collectionTie.alpha = 0.0
    collectionAway.alpha = 0.0
    collectionGear.alpha = 0.0
    reloadLayouts()
  }
  
  
  func selectedAway() {
    expansionRatio = minimumRatio
    constraintRatioHomeToAway = constraintRatioHomeToAway.with(multiplier: expansionRatio)
    constraintCollectionGearLeading.constant = bounds.width * leadingConstant
    collectionGear.alpha = 1.0
    collectionHome.alpha = 1.0
    collectionTie.alpha = canTie ? 1.0:0.0
    collectionAway.alpha = 0.0
    constraintHomeHeight = constraintHomeHeight.with(multiplier: heightConstantRight)
    reloadLayouts()
  }
  
  func selectedHome() {
    expansionRatio = minimumRatio
    constraintRatioAwayToHome = constraintRatioAwayToHome.with(multiplier: expansionRatio)
    constraintCollectionGearLeading.constant = 0.0
    collectionGear.alpha = 1.0
    collectionAway.alpha = 1.0
    collectionTie.alpha = canTie ? 1.0:0.0
    collectionHome.alpha = 0.0
    constraintHomeHeight = constraintHomeHeight.with(multiplier: heightConstantRight)
    reloadLayouts()
  }
  
  private func selectedTie() {
    expansionRatio = minimumRatio
    constraintRatioAwayToHome = constraintRatioAwayToHome.with(multiplier: 1.0)
    constraintRatioHomeToAway = constraintRatioHomeToAway.with(multiplier: 1.0)
    constraintRatioHomeToAway.priority = .defaultHigh
    constraintRatioAwayToHome.priority = .defaultHigh
    constraintTie.constant = bigSizeConstant
    constraintCollectionGearLeading.constant = bounds.width * smallSizeRatio
    collectionGear.alpha = 1.0
    collectionAway.alpha = 1.0
    collectionTie.alpha = 0.0
    collectionHome.alpha = 1.0
    constraintHomeHeight = constraintHomeHeight.with(multiplier: heightConstantRight)
    reloadLayouts()
  }
}


extension AdaptVotingGearView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath.row)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdaptVotingPointsCell", for: indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
    UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 50)
  }
  
}

extension AdaptVotingGearView {
  
  private func reloadLayouts() {
//    collectionTie.layoutIfNeeded()
//    collectionGear.layoutIfNeeded()
//    collectionHome.layoutIfNeeded()
//    collectionAway.layoutIfNeeded()
//    collectionHome.collectionViewLayout.invalidateLayout()
//    collectionAway.collectionViewLayout.invalidateLayout()
//    collectionTie.collectionViewLayout.invalidateLayout()
//    collectionGear.collectionViewLayout.invalidateLayout()
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

extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}

extension Strideable where Stride: SignedInteger {
  func clamped(to limits: CountableClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}
