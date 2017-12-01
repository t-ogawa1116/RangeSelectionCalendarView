//
//  CalendarCollectionView.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/10/30.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit

class CalendarCollectionView: UICollectionView {
    
    // *** Public Propaty *** //
    // カレンダーモデルの配列
    public var calenderModels = Array<[CalendarModel]>()
    // どの日に的を絞って表示させるか
    public var displayWeekType = Const.CalendarConst.DisplayWeekType.All
    // Delegate
    public var calendarDelegate : CalendarDelegate?
    // 祝日の配列
    public var customHoliday = [Date]()
    // 最大選択期間(日)
    public var maximumSelectionPeriod : Int = 31
    // 単一選択か複数選択か選択しないか
    public var tapMode : Const.CalendarConst.TapType = Const.CalendarConst.TapType.DoubleMode
    // 各種色設定
    public var holidayColor : UIColor = Const.CalendarConst.HolidayColor
    public var weekdayColor : UIColor = Const.CalendarConst.WeekdayColor
    public var saturedayColor : UIColor = Const.CalendarConst.SaturDayColor
    
    // 選択した際の色
    public var circleColor : UIColor = UIColor.blue.withAlphaComponent(1.0)
    // 選択した際のImage
    public var circleImage : UIImage? = nil
    // 選択間の色
    public var whileSelectedColor : UIColor = UIColor.blue.withAlphaComponent(0.2)
    
    
    // *** Private Propaty *** //
    private let dateManager = DateManager()
    private let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    private var startCalendarModel : CalendarModel? = nil
    private var finishCalendarModel : CalendarModel? = nil
    
    // *** Override *** //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initRegister()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initRegister()
    }

    // *** Private *** //

    /// 初期化
    func initRegister() {
        self.delegate = self
        self.dataSource = self

        let nib = UINib(nibName: "DateCollectionViewCell", bundle: Bundle(for: type(of: self)))
        
        self.register(nib, forCellWithReuseIdentifier: "Cell")
        self.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Section")
        
        self.adaptBeautifulGrid(numberOfGridsPerRow: 7, gridLineSpace: 0)
    }
    
    /// セルのラベルの文字色を取得
    ///
    /// - Parameter row: IndexPath.row
    /// - Returns: UIColor
    private func cellTextLabelColor(row : Int) -> UIColor {
        if row % 7 == 0 {
            // 日曜日
            if displayWeekType == Const.CalendarConst.DisplayWeekType.All || displayWeekType == Const.CalendarConst.DisplayWeekType.OnlyHoliday {
                // 表示タイプが「全て」もしくは「祝日のみ」の場合
                return holidayColor
            } else {
                // 表示タイプが「平日のみ」の場合
                return holidayColor.withAlphaComponent(0.5)
            }
        } else if row % 7 == 6 {
            // 土曜日
            if displayWeekType == Const.CalendarConst.DisplayWeekType.All || displayWeekType == Const.CalendarConst.DisplayWeekType.OnlyHoliday {
                // 表示タイプが「全て」もしくは「祝日のみ」の場合
                return saturedayColor
            } else {
                // 表示タイプが「平日のみ」の場合
                return saturedayColor.withAlphaComponent(0.5)
            }
        } else {
            if displayWeekType == Const.CalendarConst.DisplayWeekType.All || displayWeekType == Const.CalendarConst.DisplayWeekType.OnlyWeekDays {
                return weekdayColor
            } else {
                return weekdayColor.withAlphaComponent(0.5)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(section % 2) {
        case 0:
            // 曜日用
            return Date().daysPerWeek
        case 1:
            // カレンダー用
            return self.calenderModels[Int(floor(Double(section / 2)))].count
            
        default:
            print("error")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : DateCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! DateCollectionViewCell
        // 色は初期化
        cell.dayLabel?.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.updateCircleView(halfColor: UIColor.clear, position: .Center)
        cell.circleView?.backgroundColor = circleColor
        
        if circleImage != nil {
            let circleImageView = UIImageView.init(frame: (cell.circleView?.frame)!)
            circleImageView.tag = indexPath.row
            circleImageView.image = circleImage
            cell.circleView?.addSubview(circleImageView)
        } else {
            cell.circleView?.subviews.forEach {
                if $0 is UIImageView {
                    $0.removeFromSuperview()
                }
            }
        }
        
        // Section毎にCellのプロパティを変える.
        switch(indexPath.section % 2){
        case 0:
            // 土日祝
            cell.circleView?.isHidden = true
            cell.backgroundColor = UIColor.clear
            cell.dayLabel?.text = weekArray[indexPath.row]
            cell.dayLabel?.textColor = cellTextLabelColor(row: indexPath.row)
            cell.contentView.backgroundColor = UIColor.clear
        case 1:
            
            let calendarModel = self.calenderModels[Int(floor(Double(indexPath.section / 2)))][indexPath.row] as CalendarModel
            
            // 日付設定
            cell.dayLabel?.text = String(calendarModel.day)
            cell.dayLabel?.textColor = cellTextLabelColor(row: indexPath.row)
            
            // カスタムの祝日設定
            let count = customHoliday.filter {
                $0.month == calendarModel.month && $0.day == calendarModel.day
            }.count
            if count.isEmpty() {
                cell.dayLabel?.textColor = holidayColor
                calendarModel.weekType = WeekType.Holiday
                if displayWeekType == Const.CalendarConst.DisplayWeekType.OnlyWeekDays && (cell.dayLabel?.textColor.components.alpha)! >= CGFloat(1) {
                    cell.dayLabel?.textColor = cell.dayLabel?.textColor.withAlphaComponent(0.5)
                }
            }

            // 表示している月じゃなかった場合
            if calendarModel.month != calendarModel.keyDate.month && (cell.dayLabel?.textColor.components.alpha)! >= CGFloat(1) {
                cell.dayLabel?.textColor = cell.dayLabel?.textColor.withAlphaComponent(0.5)
            }
            
            // 今日より前の場合
            if calendarModel.date <= Date()  && (cell.dayLabel?.textColor.components.alpha)! >= CGFloat(1) {
                cell.dayLabel?.textColor = cell.dayLabel?.textColor.withAlphaComponent(0.5)
                calendarModel.isPastDays = true
            } else {
                calendarModel.isPastDays = false
            }
            
            // 選択されていたら
            if (startCalendarModel?.date == calendarModel.date || finishCalendarModel?.date == calendarModel.date) &&
                calendarModel.date.month == calendarModel.keyDate.month {
                
                cell.circleView?.isHidden = false
                cell.dayLabel.textColor = UIColor.white
            } else {
                cell.circleView?.isHidden = true
            }
            
            // 選択範囲に入っていたら
            if startCalendarModel != nil && finishCalendarModel != nil && calendarModel.date.month == calendarModel.keyDate.month {
                if ((startCalendarModel?.date)! <= calendarModel.date && (finishCalendarModel?.date)! >= calendarModel.date) ||
                    ((startCalendarModel?.date)! >= calendarModel.date && (finishCalendarModel?.date)! <= calendarModel.date) {

                    cell.dayLabel.textColor = UIColor.white
                    
                    if startCalendarModel?.date == calendarModel.date || finishCalendarModel?.date == calendarModel.date {
                        cell.circleView?.isHidden = false
                        
                        if startCalendarModel?.date == calendarModel.date {
                            cell.updateCircleView(halfColor: whileSelectedColor, position: .Right)
                        } else {
                            cell.updateCircleView(halfColor: whileSelectedColor, position: .Left)
                        }
                    } else {
                        cell.updateCircleView(halfColor: whileSelectedColor, position: .Center)
                    }
                } else {

                    cell.updateCircleView(halfColor: UIColor.clear, position: .Center)
                }
            }
            
            //
            if startCalendarModel != nil && tapMode == Const.CalendarConst.TapType.DoubleMode {
                // maximumSelectionPeriod加算した日付より未来か
                let addDate = startCalendarModel?.date.added(day: maximumSelectionPeriod)
                // 今日の日付より前の場合は、グレーアウト。
                let minusDate = startCalendarModel?.date.added(day: -maximumSelectionPeriod)
                
                if addDate! < calendarModel.date {
                    cell.dayLabel?.textColor = cell.dayLabel?.textColor.withAlphaComponent(0.5)
                }
                
                if minusDate! > calendarModel.date {
                    cell.dayLabel?.textColor = cell.dayLabel?.textColor.withAlphaComponent(0.5)
                }
            }
            
        default:
            print("section error")
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    //Sectionの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 曜日も入れるため、月数分入れる
        return (calenderModels.count - 1 ) * 2
    }
}


// MARK: - UICollectionViewDelegate
extension CalendarCollectionView : UICollectionViewDelegate {
    //選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let calendarModel = self.calenderModels[Int(floor(Double(indexPath.section / 2)))][indexPath.row]
        
        if displayWeekType == Const.CalendarConst.DisplayWeekType.OnlyHoliday {
            if calendarModel.weekType == WeekType.Weekday {
                return
            }
        } else if displayWeekType == Const.CalendarConst.DisplayWeekType.OnlyWeekDays {
            if calendarModel.weekType != WeekType.Weekday {
                return
            }
        } else if displayWeekType == Const.CalendarConst.DisplayWeekType.All {
            // 特になし
        }
        
        if calendarModel.isPastDays || tapMode == Const.CalendarConst.TapType.NotTapMode {
            // 過去の日もしくはタップイベントなしの場合は返す。
            if startCalendarModel != nil && finishCalendarModel != nil {
                // 2つ選択されてたら初期化
                startCalendarModel = nil
                finishCalendarModel = nil
                self.calenderModels.forEach {
                    $0.forEach {
                        $0.isStartSelected = false
                        $0.isFinishSelected = false
                    }
                }
                self.reloadData()
            }
            return
        }
        
        if startCalendarModel == nil {
            calendarModel.isStartSelected = true
            startCalendarModel = calendarModel
            self.calendarDelegate?.didSelectStartDate(date: calendarModel.date)

        } else if finishCalendarModel == nil {
            
            if tapMode == Const.CalendarConst.TapType.SingleMode {
                // すでに2つ選んでいた場合は初期化させる。
                startCalendarModel = nil
                finishCalendarModel = nil
                self.calenderModels.forEach {
                    $0.forEach {
                        $0.isStartSelected = false
                        $0.isFinishSelected = false
                    }
                }
                calendarModel.isStartSelected = true
                startCalendarModel = calendarModel
                self.calendarDelegate?.didSelectStartDate(date: calendarModel.date)
            } else if (tapMode == Const.CalendarConst.TapType.DoubleMode) {
                let addDate = startCalendarModel?.date.added(day: maximumSelectionPeriod)
                let minusDate = startCalendarModel?.date.added(day: -maximumSelectionPeriod)

                // Startと同じ日付の場合、Startより前の日付の場合、StartのmaximumSelectionPeriod足した日付より後の日付だった場合
                if (startCalendarModel?.date)! == calendarModel.date || addDate! < calendarModel.date || minusDate! > calendarModel.date {
                    return
                }
                
                calendarModel.isFinishSelected = true
                finishCalendarModel = calendarModel
                // 日付確認
                // どっちのが未来か。
                if (startCalendarModel?.date)! > calendarModel.date {
                    // StartはFinishより未来の場合
                    self.calendarDelegate?.didSelectDoubleDate(startDate: calendarModel.date, endDate: (startCalendarModel?.date)!)
                } else {
                    self.calendarDelegate?.didSelectDoubleDate(startDate: (startCalendarModel?.date)!, endDate: calendarModel.date)
                }
            }
            
        } else {
            // すでに2つ選んでいた場合は初期化させる。
            startCalendarModel = nil
            finishCalendarModel = nil
            self.calenderModels.forEach {
                $0.forEach {
                    $0.isStartSelected = false
                    $0.isFinishSelected = false
                }
            }
        }
        
        self.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarCollectionView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize {
        // 7等分
        let width = collectionView.frame.size.width / CGFloat(7)
        // 横幅と同じ
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Section", for: indexPath) as! CollectionReusableView
        
        if indexPath.section % 2 != 0 {
            return headerView
        }
        
        let calendarModel = self.calenderModels[Int(floor(Double(indexPath.section / 2)))][0] as CalendarModel
        headerView.textLabel?.text = calendarModel.keyDate.string(format: "yyyy/MM")
        headerView.textLabel?.textColor = UIColor.gray
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section % 2 == 0 {
            return CGSize(width: self.frame.width, height: 50)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
