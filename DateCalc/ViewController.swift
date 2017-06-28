//
//  ViewController.swift
//  DateCalc
//
//  Created by MJ Kim on 2017. 6. 28..
//  Copyright © 2017년 VOIDLINK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var todayFormatLbl: UILabel!
    @IBOutlet weak var weekLbl: UILabel!
    @IBOutlet weak var intervalDaysLbl: UILabel!
    @IBOutlet weak var calcDateLbl: UILabel!
    @IBOutlet weak var dateArrLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 오늘날짜 표시
        todayLbl.text = getToday()
        todayFormatLbl.text = getToday(format: "yyyy/MM/dd")
        
        // x주전 날짜 +2하면 2주후 날짜, -2하면 2주전 날짜
        weekLbl.text = String(describing: getSomeWeekDate(week: 2))
        
        // 날짜수
        intervalDaysLbl.text = String(describing: getIntervalDays(date: getSomeWeekDate(week: 3)))
        
        
        calcDateLbl.text = String(describing: getCalcDate(year:-4,month:-3,day:0,hour:0,min:30,sec:0,baseDate: "2016-07-01 00:00:00"))
        
        let startDt = "2017-06-20"
        var dt: [String] = getDaysArray(start: startDt, max: 18)
        dateArrLbl.text = String(describing:dt.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 오늘날짜 서식 지정
    // - parameter format: 서식(옵션)
    // - return 오늘 날짜
    func getToday(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let now = Date()
        let formmater = DateFormatter()
        formmater.dateFormat = format
        return formmater.string(from: now as Date)
    }
    
    // X주전/후 날짜 구하기
    // - parameter week: n (주단위)
    // - returns 계산된 날짜
    func getSomeWeekDate(week: Double) -> Date {
        let now = Date()
        let resultDate: Date
        
        if week > 0 {
            resultDate = Date(timeInterval: 604800 * week, since: now as Date)
        } else {
            resultDate = Date(timeInterval: -604800 * fabs(week), since: now as Date)
        }
        
        return resultDate
    }

    // 두개의 날짜 사이 일자 구하기
    // - parameter date: 날짜
    // - parameter anotherDay: 다른날짜(옵션이며 미지정시 당일날짜)
    // - return 계산된 일자수
    func getIntervalDays(date: Date?, anotherDay: Date? = nil) -> Double {
        
        var interval: Double!
        
        if anotherDay == nil {
            interval = date?.timeIntervalSinceNow
        } else {
            interval = date?.timeIntervalSince(anotherDay!)
        }
        
        let r = interval / 86400
        
        return floor(r)
    }
    
    // 년, 월, 일, 시, 분, 초단위 날짜 계산
    // - parameter year: 년도
    // - parameter month: 월
    // - parameter day: 일
    // - parameter hour: 시
    // - parameter min: 분
    // - parameter sec: 초
    // - parameter baseDate: 기준일자
    // - return 계산된 결과날짜
    func getCalcDate(year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Int, baseDate: String? = nil) -> Date {
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var components = DateComponents()
        components.setValue(year, for: Calendar.Component.year)
        components.setValue(month, for: Calendar.Component.month)
        components.setValue(day, for: Calendar.Component.day)
        components.setValue(hour, for: Calendar.Component.hour)
        components.setValue(min, for: Calendar.Component.minute)
        components.setValue(sec, for: Calendar.Component.second)
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let base: Date?
        
        if let _ = baseDate {
            if let _ = formatter.date(from: baseDate!) {
                base = formatter.date(from: baseDate!)!
            } else {
                print("baseDate날짜 변환 실패")
                base = Date()
            }
        } else {
            base = Date()
        }
        return calendar.date(byAdding: components, to: base!)!
    }

    // 기준일자로부터 당일까지 날짜 배열로 받기
    // - parameter start: 기준일자
    // - parameter max: 최대값
    // - return: 날짜 배열값
    func getDaysArray(start: String, max: Int) -> [String] {
        
        var result: [String] = []
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = formatter.string(from: Date())
        let startDay = formatter.date(from: start)!
        
        var components = DateComponents()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        for i in 0 ..< max {
            components.setValue(i, for: Calendar.Component.day)
            let week = calendar.date(byAdding: components, to: startDay)!
            let weekStr = formatter.string(from: week)
            if weekStr > today {
                break
            } else {
                result.append(weekStr)
            }
        }
        return result
    }
}

