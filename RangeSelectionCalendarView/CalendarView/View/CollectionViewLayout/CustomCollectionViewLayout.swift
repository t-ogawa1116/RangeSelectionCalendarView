//
//  File.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/11/17.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        // CollectionViewのレイアウトを生成.
        self.sectionInset = UIEdgeInsetsMake(0,0,0,0)
        self.headerReferenceSize = CGSize(width: (self.collectionView?.frame.width)!, height: 50)
        self.itemSize = CGSize(width:(self.collectionView?.frame.width)! / 7, height:50)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
