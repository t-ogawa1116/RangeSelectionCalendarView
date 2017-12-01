//
//  CalenderDelegate.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/10/31.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit

/// CollectionViewからViewに返すDelegate
protocol CalendarDelegate: class {
    
    /// 日付選択した際に返す
    ///
    /// - Parameter date: 選択された日付
    func didSelectStartDate(date : Date)
    
    /// 2つの日付を選択された際に返す
    ///
    /// - Parameters:
    ///   - startDate: 開始日
    ///   - endDate: 終了日
    func didSelectDoubleDate(startDate : Date, endDate : Date)
}

/// ViewController側に返すDelegate
@objc protocol CalrendarViewDelegate {
    
    /// 日付を選択した際に返す
    ///
    /// - Parameter date: 選択された日付
    func didSelectStartDate(date : Date)
    /// 2つの日付を選択された際に返す
    ///
    /// - Parameters:
    ///   - startDate: 開始日
    ///   - endDate: 終了日
    func didSelectDoubleDate(startDate : Date, endDate : Date)
}
