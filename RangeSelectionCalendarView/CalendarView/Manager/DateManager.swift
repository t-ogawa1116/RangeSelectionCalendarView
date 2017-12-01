//
//  DateManager.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/10/30.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit

class DateManager: NSObject {
    
     //表記する月の配列
    var currentMonth = [Int : [NSDate]]()
    var numberOfCells = [Int : Int]()
    
    //月ごとのセルの数を返すメソッド
    func daysAcquisition(date : Date) -> Int {
        
        var numberOfItems = 0
        
        //取得した月に週がいくつあるかを取得　in(その月)にof(週)が何個あるか
        let dateRange = NSCalendar.current.range(of: .weekOfMonth, in: .month, for: date)
        
        //その月の始まりが日曜日かどうかで場合分け
        numberOfItems = dateRange!.count * date.daysPerWeek
        
        let count = numberOfCells.filter(){$0.key == date.month}.count
        if count.isEmpty() {
            numberOfCells[date.month] = numberOfItems
        }
        
        return numberOfItems
    }
    
    //月の初日を取得
    func firstDateOfMonth(date : Date) -> Date {
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from:date)
        components.day = 1
        
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }
    
    
    /// 表記する日にちを取得
    ///
    /// - Parameters:
    ///   - numberOfItem: セル数
    ///   - date: 日程
    func dateForCellAtIndexPath(numberOfItem: Int, date : Date) {
        var currentMonthOfDates = [NSDate]()
        // 「月の初日が週の何日目か」を計算
        let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth(date: date))
        
        for i in 0 ..< numberOfItem {
            var dateComponents = DateComponents()
            
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)

            // 表示する月の初日から計算した差を引いた日付を取得
            let calcDate = Calendar.current.date(byAdding: dateComponents as DateComponents, to: firstDateOfMonth(date: date) as Date)!

            // 配列に追加
            currentMonthOfDates.append(calcDate as NSDate)
        }
        
        // 配列をメンバーに保持させる。
        let count = currentMonth.filter(){$0.key == date.month}.count
        if count.isEmpty() {
            currentMonth[date.month] = currentMonthOfDates
        }
    }
    
    
    /// セルに表示する文字を変更する
    ///
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - date: Date
    /// - Returns: String
    func conversionDateFormat(indexPath: IndexPath, date : Date) -> String {
        // 辞書型からセルの数を取得
        let numberOfItems = numberOfCells[date.month]
        dateForCellAtIndexPath(numberOfItem: numberOfItems!, date: date)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        
        let currentMonthOfDates = currentMonth[date.month]
        if (currentMonthOfDates?.count)! <= indexPath.row {
            return ""
        }
        
        return formatter.string(from: currentMonthOfDates![indexPath.row] as Date)
    }
}
