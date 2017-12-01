//
//  CircleView.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/11/17.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit

/// 円の描画
/// 日付を選択された際に表示する円
class CircleView: UIView {
    
    override func draw(_ rect: CGRect) {
        // 初期化
        let circlePath = UIBezierPath(arcCenter: self.center,
                                      radius: CGFloat(self.frame.width / 2),
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(Double.pi * 2),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        // 円内の色
        shapeLayer.fillColor = UIColor.blue.withAlphaComponent(1.0).cgColor
        // 円線の色
        shapeLayer.strokeColor = UIColor.clear.cgColor
        
        self.layer.mask = shapeLayer
        self.backgroundColor = UIColor.blue
    }
    
    public func updateColor(color : UIColor){
        self.backgroundColor = color
    }
    
    
}
