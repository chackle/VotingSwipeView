//
//  VotingCollectionView.swift
//  VotingSwipeView
//
//  Created by Michael Green on 20/08/2019.
//  Copyright © 2019 Michael Green. All rights reserved.
//

import Foundation
import UIKit

class VotingCollectionView: UICollectionView {
  
  func setup() {
    let nib = UINib(nibName: "VotingCollectionViewCell", bundle: nil)
    self.register(nib, forCellWithReuseIdentifier: "VotingCollectionViewCell")
    self.delegate = self
    self.dataSource = self
  }
}

extension VotingCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VotingCollectionViewCell", for: indexPath) as! VotingCollectionViewCell
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? VotingCollectionViewCell {
      cell.setup()
    }
  }
  
}
