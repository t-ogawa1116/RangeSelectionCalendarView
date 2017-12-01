//
//  DateCollectionViewCell.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/10/30.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit

enum ColorPosition {
    case Center
    case Right
    case Left
}

/// 日付表示Cell
class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var rightHalfView: UIView!
    @IBOutlet weak var leftHalfView: UIView!
    @IBOutlet weak var circleView: CircleView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    private func initLayout(){
        self.rightHalfView.isHidden = true
        self.leftHalfView.isHidden = true
    }
    
    public func updateCircleView(halfColor : UIColor, position : ColorPosition) {
        if position == .Right {
            self.contentView.backgroundColor = UIColor.clear
            rightHalfView.isHidden = false
            rightHalfView.backgroundColor = halfColor
            leftHalfView.isHidden = true
        }else if position == .Left {
            self.contentView.backgroundColor = UIColor.clear
            leftHalfView.isHidden = false
            leftHalfView.backgroundColor = halfColor
            rightHalfView.isHidden = true
        }else {
            leftHalfView.isHidden = true
            rightHalfView.isHidden = true
            self.contentView.backgroundColor = halfColor
        }
    }
    
}
