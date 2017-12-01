//
//  Constants.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/10/31.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit

struct Const {
    struct CalendarConst {
        static let xibFileName = "CalendarView"
        
        // 半年後
        static let HalfYear = 6
        // 1年後
        static let OneYear = 1
        
        // セル内にあるラベルの文字色
        static let SaturDayColor = UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
        static let HolidayColor = UIColor(red: 220.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
        static let WeekdayColor = UIColor.gray

        // どこまでカレンダー表示するか。
        enum DisplayType {
            // 半年先まで
            case HalfYear
            // 1年後まで
            case OneYear
            // カスタム(ヶ月)
            case CustomMonth
            // カスタム(年)
            case CustomYear
        }
        
        
        /// 活性させるタイプ
        ///
        /// - All: 全て
        /// - OnlyWeekDays: 平日のみ
        /// - OnlyHoliday: 土日祝のみ
        enum DisplayWeekType {
            // 全て
            case All
            // 平日のみ
            case OnlyWeekDays
            // 土日祝のみ
            case OnlyHoliday
        }
        
        
        /// Tapタイプ
        ///
        /// - SingleMode: 1回タップモード
        /// - DoubleMode: 2回タップモード
        /// - NotTapMode: タップなし
        enum TapType {
            case SingleMode
            case DoubleMode
            case NotTapMode
        }

    }
}



