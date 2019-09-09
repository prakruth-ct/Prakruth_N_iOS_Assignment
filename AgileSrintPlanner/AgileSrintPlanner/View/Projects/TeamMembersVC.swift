//
//  TeamMembersVC.swift
//  AgileSrintPlanner
//
//  Created by Prakruth Nagaraj on 09/09/19.
//  Copyright © 2019 Prakruth Nagaraj. All rights reserved.
//

import UIKit

class TeamMembersVC: BaseVC {
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension TeamMembersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
