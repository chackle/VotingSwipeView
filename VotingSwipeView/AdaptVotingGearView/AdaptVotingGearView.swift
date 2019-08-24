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
  @IBOutlet weak var labelTiePoints: UILabel!
  @IBOutlet weak var labelAwayPoints: UILabel!
  
  
  @IBOutlet weak var constraintCollectionGear: NSLayoutConstraint!
  @IBOutlet weak var constraintCollectionGearLeading: NSLayoutConstraint!
  @IBOutlet weak var constraintCollectionGearHeight: NSLayoutConstraint!
  
  //@IBOutlet weak var constraintCollectionHome: NSLayoutConstraint!
  //@IBOutlet weak var constraintCollectionAway: NSLayoutConstraint!
  
  @IBOutlet weak var constraintTie: NSLayoutConstraint!
  @IBOutlet weak var constraintRatioHomeToAway: NSLayoutConstraint!
  @IBOutlet weak var constraintRatioAwayToHome: NSLayoutConstraint!
  
  private var votingMode: EnumVotingMode = .none {
    didSet {
      self.animateToVoting(mode: self.votingMode)
    }
  }
  
  private var canTie = false
  private var expansionRatio: CGFloat = 1.0
  

  private var tieNormalSizeConstant: CGFloat {
    return canTie ? self.bounds.width * self.normalSizeRatio: 0.0
  }
  
  private var tieSmallSizeConstant: CGFloat {
    return canTie ? self.bounds.width * self.smallSizeRatio: 0.0
  }
  
  private var tieBigSizeConstant: CGFloat {
    return canTie ? bigSizeConstant: 0.0
  }
  
  private var bigSizeConstant: CGFloat {
    return self.bounds.width * self.bigSizeRatio
  }
  
  private var normalSizeRatio: CGFloat  {
    return (canTie ? 0.333:0.5)
  }
  
  private var bigSizeRatio: CGFloat  {
    return (canTie ? 0.45:0.80)
  }
  
  private var smallSizeRatio: CGFloat {
    let divider: CGFloat = canTie == true ? 0.5:1.0
    return ((1.0 - bigSizeRatio) * divider)
  }
  
  private let minimumRatio: CGFloat = 0.3
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
    self.layoutSubviews()
  }
  
  func setup() {
    Bundle.main.loadNibNamed("AdaptVotingGearView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    self.constraintRatioHomeToAway = self.constraintRatioHomeToAway.with(multiplier: expansionRatio.clamped(to: self.minimumRatio...self.maximumRatio))
    self.constraintRatioHomeToAway.priority = UILayoutPriority.defaultHigh
    self.constraintRatioAwayToHome = self.constraintRatioAwayToHome.with(multiplier: 1)
    self.constraintRatioAwayToHome.priority = UILayoutPriority.defaultLow

    self.constraintCollectionGearLeading.constant = self.bounds.width * self.leadingConstant
    self.updateConstraints()
    UIView.animate(withDuration: 0.3) {
      self.collectionGear.alpha = alpha
      self.collectionHome.alpha = alpha
      self.collectionTie.alpha = self.canTie ? alpha:0.0
      self.collectionAway.alpha = 0.0
      self.constraintCollectionGearHeight.constant = self.collectionAway.frame.height * alpha.clamped(to: 0.0...1.0)
    }
  }
  
  func selectingHome(expansionRatio: CGFloat, alpha: CGFloat) {
    self.expansionRatio = expansionRatio
    self.constraintRatioAwayToHome = self.constraintRatioAwayToHome.with(multiplier: expansionRatio.clamped(to: self.minimumRatio...self.maximumRatio))
    self.constraintRatioAwayToHome.priority = UILayoutPriority.defaultHigh
    self.constraintRatioHomeToAway = self.constraintRatioHomeToAway.with(multiplier: 1)
    self.constraintRatioHomeToAway.priority = UILayoutPriority.defaultLow

    self.constraintCollectionGearLeading.constant = 0.0
    self.updateConstraints()
    UIView.animate(withDuration: 0.3) {
      self.collectionGear.alpha = alpha
      self.collectionAway.alpha = alpha
      self.collectionTie.alpha = self.canTie ? alpha:0.0
      self.collectionHome.alpha = 0.0
      self.constraintCollectionGearHeight.constant = self.collectionHome.frame.height * alpha.clamped(to: 0.0...1.0)
    }
  }
  
  func selectedNone() {
    self.constraintCollectionGear.constant = self.bigSizeConstant
    self.constraintCollectionGearLeading.constant = 0.0
    self.constraintCollectionGearHeight.constant = 0.0
    self.constraintRatioHomeToAway = self.constraintRatioHomeToAway.with(multiplier: 1.0)
    self.constraintRatioAwayToHome = self.constraintRatioAwayToHome.with(multiplier: 1.0)
    self.constraintRatioHomeToAway.priority = .defaultHigh
    self.constraintRatioAwayToHome.priority = .defaultHigh
    self.constraintTie.constant = self.tieNormalSizeConstant
    self.updateConstraints()
    UIView
      .animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
        self.collectionHome.alpha = 0.0
        self.collectionTie.alpha = 0.0
        self.collectionAway.alpha = 0.0
        self.collectionGear.alpha = 0.0
        
      }, completion: { (completion) in
        
      })
  }
  
  
  func selectedAway() {
    self.selectingAway(expansionRatio: self.minimumRatio, alpha: 1.0)
  }
  
  func selectedHome() {
    self.selectingHome(expansionRatio: self.minimumRatio, alpha: 1.0)
  }
  
  private func selectedTie() {
    
    //    UIView.animate(withDuration: 0.1, animations: {
    //
    //     // self.constraintCollectionAway = self.constraintCollectionAway.with(multiplier: self.smallSizeRatio)
    //
    //      self.constraintCollectionHome = self.constraintCollectionHome.with(multiplier: self.smallSizeRatio)
    //
    //      self.constraintCollectionGear = self.constraintCollectionGear.with(multiplier: self.bigSizeRatio)
    //
    //      self.constraintCollectionGearLeading.constant = self.bounds.width * self.smallSizeRatio
    //
    //      self.updateConstraints()
    //
    //    }) { (completed) in
    //
    //      UIView
    //        .animate(withDuration: 0.2, delay: 0.1, options: [], animations: {
    //          self.collectionHome.alpha = 1.0
    //          self.collectionAway.alpha = 1.0
    //          self.collectionTie.alpha = 0.0
    //          self.collectionGear.alpha = 1.0
    //          self.collectionGear.frame = self.collectionTie.frame
    //
    //        }, completion: { (completion) in
    //
    //        })
    //    }
    
  }
  
  
}


extension AdaptVotingGearView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdaptVotingPointsCell", for: indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
  }
  
}

extension AdaptVotingGearView {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    DispatchQueue.main.async {
      self.reloadLayouts()
    }
  }
  
  private func reloadLayouts() {
    self.collectionHome.collectionViewLayout.invalidateLayout()
    self.collectionAway.collectionViewLayout.invalidateLayout()
    self.collectionTie.collectionViewLayout.invalidateLayout()
    self.collectionGear.collectionViewLayout.invalidateLayout()

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
