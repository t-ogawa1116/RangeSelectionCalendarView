//
//  CollectionReusableView.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/10/30.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit


/// セクションヘッダー
class CollectionReusableView: UICollectionReusableView {
    var textLabel : UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UILabelを生成.
        textLabel = UILabel(frame: CGRect(x:0, y:10, width:frame.width, height:frame.height))
        textLabel?.text = ""
        textLabel?.textAlignment = NSTextAlignment.center
        textLabel?.font = UIFont(name: "Arial", size: 22)
        
        self.addSubview(textLabel!)
    }
}
