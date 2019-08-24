//
//  AdaptVotingPointsCell.swift
//  AdaptVotingGearView
//
//  Created by Fabricio Oliveira on 2019-08-22.
//  Copyright © 2019 Strafe AB. All rights reserved.
//

import UIKit

class AdaptVotingPointsCell: UICollectionViewCell {
    
  @IBOutlet weak var labelPoints: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    labelPoints.text = "99999"
  }
}
