//
//  CalenderView.swift
//  CalenderView
//
//  Created by 小川　卓也 on 2017/10/30.
//  Copyright © 2017年 小川　卓也. All rights reserved.
//

import UIKit


/// 親元のView (ViewControllerは本クラスをaddSubしてください)
@IBDesignable
class CalendarView: UIView, XibInstantiatable {
    // *** UI *** //
    @IBOutlet weak var collectionView: CalendarCollectionView!
    
    // *** public Propaty *** //
    // IB //
    // カレンダーViewの背景色
    @IBInspectable var calendarViewBackgroundClor : UIColor = UIColor.white {
        didSet {
            collectionView?.backgroundColor = calendarViewBackgroundClor
        }
    }

    // DisplayTypeのCustomMonthを設定した際に「○ヶ月」の値を入れてください
    // 初期値は半年後
    @IBInspectable var customMonthAgo : Int = Const.CalendarConst.HalfYear {
        didSet {
            initLayout()
            collectionView?.reloadData()
        }
    }
    
    // DisplayTypeのCustomYearを設定した際に「○年」の値を入れてください
    // 初期値は1年
    @IBInspectable var customYearAgo : Int = Const.CalendarConst.OneYear {
        didSet {
            initLayout()
            collectionView?.reloadData()
        }
    }
    
    // 最大選択期間(日) TapモードがDoubleModeのみ有効
    @IBInspectable var maximumSelectionPeriod : Int = 31 {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    //  * 各種色設定 * //
    // 祝日の文字色
    @IBInspectable var holidayColor : UIColor = Const.CalendarConst.HolidayColor {
        didSet {
            collectionView?.holidayColor = holidayColor
            collectionView?.reloadData()
        }
    }
    
    @IBInspectable var weekdayColor : UIColor = Const.CalendarConst.WeekdayColor {
        didSet {
            collectionView?.weekdayColor = weekdayColor
            collectionView?.reloadData()
        }
    }
    
    @IBInspectable var saturedayColor : UIColor = Const.CalendarConst.SaturDayColor {
        didSet {
            collectionView?.saturedayColor = saturedayColor
            collectionView?.reloadData()
        }
    }

    // 選択した際の色
    @IBInspectable var circleColor : UIColor = UIColor.blue.withAlphaComponent(1.0) {
        didSet {
            collectionView?.circleColor = circleColor
            collectionView?.reloadData()
        }
    }
    
    // 選択した際のImage
    @IBInspectable var circleImage : UIImage! = nil {
        didSet {
            collectionView?.circleImage! = circleImage
            collectionView?.reloadData()
        }
    }
    
    // 選択間の色
    @IBInspectable var whileSelectedColor : UIColor = UIColor.blue.withAlphaComponent(0.2) {
        didSet {
            collectionView?.whileSelectedColor = whileSelectedColor
            collectionView?.reloadData()
        }
    }
    
    // Default
    var displayType : Const.CalendarConst.DisplayType = Const.CalendarConst.DisplayType.HalfYear
    // Rootの背景色
    var viewBackgroundColor : UIColor = UIColor.white
    
    // 祝日データ
    var customHolidays = [Date]()
    // 曜日のどこを活性させるか
    var displayWeekType = Const.CalendarConst.DisplayWeekType.All
    // Tapモード
    var tapMode : Const.CalendarConst.TapType = Const.CalendarConst.TapType.DoubleMode
 
    // Delegate
    var delegate : CalrendarViewDelegate?
       
    // ** Override ** //

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instantiate()
        initLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        instantiate()
        initLayout()
    }
    
    // *** Private *** //
    
    /// Layout初期化
    private func initLayout(){
//        let view = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?.first as! UIView
//        view.frame = self.bounds
        
        collectionView?.backgroundColor = calendarViewBackgroundClor
        collectionView?.calenderModels = getInitDates()
        collectionView?.displayWeekType = displayWeekType
        collectionView?.tapMode = tapMode
        collectionView?.holidayColor = holidayColor
        collectionView?.weekdayColor = weekdayColor
        collectionView?.saturedayColor = saturedayColor
        collectionView?.circleColor = circleColor
        collectionView?.circleImage = circleImage
        collectionView?.whileSelectedColor = whileSelectedColor
        collectionView?.calendarDelegate = self

        //view.addSubview(collectionView!)
        //self.addSubview(collectionView!)
    }
    
    /// 日付計算
    ///
    /// - Returns: モデルの配列
    private func getInitDates () -> Array<[CalendarModel]>{
        let startDate = Date()
        var selectedDate = Date()
        var sectionCalendarModels = Array<[CalendarModel]>()
        
        if displayType == Const.CalendarConst.DisplayType.HalfYear || displayType == Const.CalendarConst.DisplayType.CustomMonth {
            selectedDate = selectedDate.added(month: customMonthAgo)
        }
        else if displayType == Const.CalendarConst.DisplayType.OneYear || displayType == Const.CalendarConst.DisplayType.CustomYear{
            selectedDate = selectedDate.added(year: customYearAgo)
        }
        
        let startDateComponents = NSCalendar.current.dateComponents([.year ,.month], from:startDate)
        let currentDateComponents = NSCalendar.current.dateComponents([.year ,.month], from:selectedDate)
        //作成月と現在の月が違う時はその分表示    components.monthではなれた月分
        let components = NSCalendar.current.dateComponents([.year,.month], from: startDateComponents, to: currentDateComponents)
        let numberOfMonth = components.month! + components.year! * 12
        
        let dateManager = DateManager()
        // 離れている月分カウントアップ
        for i in 0 ..< numberOfMonth + 1 {

            var calendarModels : [CalendarModel] = []
            
            let firstDate = startDate.fixed(month: Date().month + i, day: 1)
            
            let _ : Int = firstDate.numberOfDaysForMonth
            
            let _ = dateManager.daysAcquisition(date: firstDate)
            dateManager.dateForCellAtIndexPath(numberOfItem: dateManager.numberOfCells[firstDate.month]!, date: firstDate)
            
            let monthDate = dateManager.currentMonth[firstDate.month]! as [Date]
            for j in 0 ..< monthDate.count {
                let calendarModel = CalendarModel()
                calendarModel.keyDate = firstDate
                calendarModel.date = monthDate[j]
                calendarModels.append(calendarModel)
            }
            
            sectionCalendarModels.append(calendarModels)
        }
        
        return sectionCalendarModels
    }
}


// MARK: - CalendarCollectionView Delegate
extension CalendarView : CalendarDelegate {
    
    func didSelectStartDate(date: Date) {
        self.delegate?.didSelectStartDate(date: date)
    }
    
    func didSelectDoubleDate(startDate: Date, endDate: Date) {
        self.delegate?.didSelectDoubleDate(startDate: startDate, endDate: endDate)
    }
}


// MARK: - CalendarViewのExtension
extension CalendarView {
    // *** Method Chain *** //
    
    
    // *** Public *** //
    
    public func displayType(customDisplayType : Const.CalendarConst.DisplayType) -> CalendarView {
        displayType = customDisplayType
        
        return self
    }
    
    public func viewBackgroundColor(customViewBackGroundColor : UIColor) -> CalendarView {
        viewBackgroundColor = customViewBackGroundColor
        
        return self
    }
    
    public func calendarViewBackgroundColor(customCalendarViewBackgroundColor : UIColor) -> CalendarView {
        calendarViewBackgroundClor = customCalendarViewBackgroundColor
        
        return self
    }
    
    public func customHolidays(holidays : [Date]) -> CalendarView {
        customHolidays = holidays
        
        return self
    }
    
    public func customMonthAgo(monthAgo : Int) -> CalendarView {
        customMonthAgo = monthAgo
        
        return self
    }
    
    public func customYearAgo(yearAgo : Int) -> CalendarView {
        customYearAgo = yearAgo
        
        return self
    }
    
    public func displayWeekType(weekType : Const.CalendarConst.DisplayWeekType) -> CalendarView{
        displayWeekType = weekType
        
        return self
    }
    
    public func delegate(calendarViewDelegate : CalrendarViewDelegate) -> CalendarView {
        delegate = calendarViewDelegate
        
        return self
    }
    
    
    
    // *** Public *** //
    
    /// DisplayWeekTypeの変更メソッド
    ///
    /// - Parameter weekType: DisplayWeekType
    public func chengeDisplayWeekType(weekType : Const.CalendarConst.DisplayWeekType) {
        displayWeekType = weekType
        collectionView?.displayWeekType = weekType
        
        collectionView?.reloadData()
    }
    
    
    /// 祝日の更新
    ///
    /// - Parameter holiday: Holidays
    public func updateCustomHoliday(holiday : [Date]) {
        customHolidays = holiday
        collectionView?.customHoliday = holiday
        
        collectionView?.reloadData()
    }
    
    
    /// 単一選択か複数選択か
    ///
    /// - Parameter tapMode: TapMode
    public func updateTapMode(tapMode : Const.CalendarConst.TapType) {
        self.tapMode = tapMode
        self.collectionView?.tapMode = tapMode
        
        self.collectionView?.reloadData()
    }
    
    
}
