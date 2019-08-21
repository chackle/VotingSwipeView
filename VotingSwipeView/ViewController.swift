//
//  ViewController.swift
//  VotingSwipeView
//
//  Created by Michael Green on 20/08/2019.
//  Copyright © 2019 Michael Green. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: VotingCollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.collectionView.contentInset = UIEdgeInsets(top: -48, left: 0, bottom: -20, right: 0)
    self.collectionView.setup()
  }
}

