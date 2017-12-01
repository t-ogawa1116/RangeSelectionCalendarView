//
//  CalenderModel.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/10/30.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit

/// 平日 / 土 / 日祝
///
/// - Weekday: 平日
/// - Satureday: 土曜
/// - Holiday: 日曜 / 祝日
enum WeekType {
    case weekday
    case satureday
    case holiday
}


/// カレンダー用モデルクラス
class CalendarModel: NSObject {
    var keyDate : Date = Date()
    var isStartSelected = false
    var isFinishSelected = false
    var isPastDays = false
    var year : Int = 1900
    var month : Int = 1
    var day : Int = 1
    var weekType : WeekType = WeekType.weekday
    var date : Date = Date(){
        didSet {
            self.year = date.year
            self.month = date.month
            self.day = date.day
            self.weekType = convertWeekType(date: date)
        }
    }
    
    // *** Init *** //
    override init() {
        super.init()
    }
    
    // *** Private Method *** //
    
    /// 日付からTypeに変換
    ///
    /// - Parameter date: Date
    /// - Returns: WeekType
    private func convertWeekType (date : Date) -> WeekType {
        let index = date.weekIndex
        if index >= 1 && index <= 5 {
            return WeekType.weekday
        }else if index == 0 {
            return WeekType.holiday
        }else {
            return WeekType.satureday
        }
    }
    
}
