//
//  CalendarViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 12/2/21.
//

import UIKit
import Koyomi

var fromDate = ""
var to_Date = ""
var date_count = 0

class CalendarViewController: UIViewController, UICollectionViewDelegate {

    var calendar_view = CalendarView()

    var fromD = ""
    var toD = ""
    var dateC = 0
    
    fileprivate let invalidPeriodLength = 90
    
    let koyomi: Koyomi = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = Koyomi(frame: .zero, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ouyt")
        modalPresentationCapturesStatusBarAppearance = false
        
        view.backgroundColor = colorGrayWhite
        
        calendar_view = CalendarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        
        koyomi.frame = CGRect(x: 20, y : 120, width: UIScreen.main.bounds.size.width - 40, height: 210)
        koyomi.backgroundColor = .clear
        koyomi.circularViewDiameter = 0.2
        koyomi.calendarDelegate = self
        //koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        koyomi.weeks = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
        koyomi.style = .standard
        koyomi.dayPosition = .center
        koyomi.weekdayColor = colorBlackWhite
        koyomi.weekColor = .gray
        koyomi.otherMonthColor = .gray
        //koyomi.isHiddenOtherMonth = true
    
        koyomi.selectionMode = .sequence(style: .semicircleEdge)
        koyomi.selectedStyleColor = UIColor(red: 1.00, green: 0.68, blue: 0.40, alpha: 1.00)
        koyomi
            .setDayFont(size: 14)
            .setWeekFont(size: 10)
        calendar_view.addSubview(koyomi)
        calendar_view.layer.cornerRadius = 10
        
        
        let dateFormatter1 = DateFormatter()
        let date = Date()
        dateFormatter1.dateFormat = "LLLL yyyy"
        dateFormatter1.locale = Locale(identifier: defaultLocalizer.stringForKey(key: "locale_lang"))
        
        calendar_view.month.text = dateFormatter1.string(from: date)
        
        calendar_view.prev_button.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        calendar_view.next_button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        calendar_view.cancel.addTarget(self, action: #selector(dismissCalendar), for: .touchUpInside)
        calendar_view.ok.addTarget(self, action: #selector(dismissCalendar), for: .touchUpInside)
        calendar_view.close.addTarget(self, action: #selector(dismissCalendar), for: .touchUpInside)
        view.addSubview(calendar_view)
        
        calendar_view.ok.isEnabled = false
        calendar_view.ok.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("lop")
        koyomi.calendarDelegate = self
        print(dateC)
        print(fromD)
        print(toD)
        fromDate = fromD
        to_Date = toD
        date_count = dateC
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
}

extension CalendarViewController: KoyomiDelegate {
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        print("You Selected: \(date)")
       // calendar_view.ok.isEnabled = true
      //  calendar_view.ok.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
    }
    
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
        print(dateString)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = DateFormatter.Style.long
        dateFormatter1.dateFormat = "MM/yyyy"
        let date = dateFormatter1.date(from: dateString)
        dateFormatter1.dateFormat = "LLLL yyyy"
        dateFormatter1.locale = Locale(identifier: defaultLocalizer.stringForKey(key: "locale_lang"))
        
        calendar_view.month.text = dateFormatter1.string(from: date!)
    }
    
    @objc(koyomi:shouldSelectDates:to:withPeriodLength:)
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        /*if length > invalidPeriodLength {
            print("More than \(invalidPeriodLength) days are invalid period.")
            return false
        }*/
        
        var toDay = Calendar.current.startOfDay(for: Date())
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd.MM.yyyy"
        dateFormatter1.locale = Locale(identifier: defaultLocalizer.stringForKey(key: "locale_lang"))
        
        /*if date == nil  && toDate == nil {
            calendar_view.ok.isEnabled = false
            calendar_view.ok.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        }*/
        
        if date != nil && Calendar.current.startOfDay(for: date!) <= toDay {
            if date! < Calendar.current.dateWith2(year: 2023, month: 1, day: 2)!{
                print("hi  date2")
                calendar_view.ok.isEnabled = false
                calendar_view.ok.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
            }
            else {
                fromDate = dateFormatter1.string(from: date!)
                fromD = dateFormatter1.string(from: date!)
                calendar_view.ok.isEnabled = true
                calendar_view.ok.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                if date != nil  && toDate != nil {
                    if  Calendar.current.startOfDay(for: date!) >= toDay ||  Calendar.current.startOfDay(for: toDate!) >= toDay {
                        print("kkkkk")
                        calendar_view.ok.isEnabled = false
                        calendar_view.ok.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
                    }
                    else  {
                        calendar_view.ok.isEnabled = true
                        calendar_view.ok.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
                    }
                    
                }
            }
            
        }
        else {
            calendar_view.ok.isEnabled = false
            calendar_view.ok.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        }
        
        if toDate != nil {
            to_Date = dateFormatter1.string(from: toDate!)
            date_count = length
            toD = dateFormatter1.string(from: toDate!)
            dateC = length
        }
        else {
            to_Date = ""
            toD = ""
        }
        
        print(date_count)
        print(fromDate)
        print(to_Date)
        return true
    }
    
    @objc func nextMonth() {
        print("hello")
        let month: MonthType = {
            return .next
        }()
        koyomi.display(in: month)
    }
    
    @objc func prevMonth() {
        
        print(koyomi.currentDateString())
        print(koyomi.currentDateFormat)
        let isoDate = koyomi.currentDateString()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/yyyy"
        let date = dateFormatter.date(from: isoDate)!
        
        let month: MonthType = {
            
            if date > Calendar.current.dateWith(year: 2023, month: 1) ?? Date.distantFuture {
                print("ok")
                return .previous
            } else {
                print("no ok")
                return .current
            }

        }()
        koyomi.display(in: month)
    }
    
    @objc func dismissCalendar(_ sender: UIButton) {
        sender.showAnimation { [self] in
            
            dismiss(animated: true)
        }
    }
    
}


class CalendarView: UIView {
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 20, height: 20)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title_calendar: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.text = defaultLocalizer.stringForKey(key: "choose_period")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        
        return title
    }()
    
    lazy var prev_button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 40, y: 90, width: 8, height: 15)
        button.setImage(#imageLiteral(resourceName: "prev"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var next_button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 48, y: 90, width: 8, height: 15)
        button.setImage(#imageLiteral(resourceName: "next"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var month: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 0
        title.textColor = .gray
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 50, y: 80, width: UIScreen.main.bounds.size.width - 100, height: 30)
        return title
    }()
    
    lazy var ok: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 350, width: UIScreen.main.bounds.size.width - 40, height: 45)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Choosed"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        button.isUserInteractionEnabled = true
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var cancel: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 400, width: UIScreen.main.bounds.size.width - 40, height: 45)
        button.backgroundColor = .clear
        button.setTitle(defaultLocalizer.stringForKey(key: "Cancel"), for: .normal)
        button.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        button.isUserInteractionEnabled = true
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        
        self.addSubview(title_calendar)
        self.addSubview(close)
        self.addSubview(prev_button)
        self.addSubview(next_button)
        self.addSubview(month)
        self.addSubview(ok)
        self.addSubview(cancel)

    }
}

extension Calendar {
    func dateWith(year: Int, month: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        return date(from: dateComponents)
    }
    
    func dateWith2(year: Int, month: Int, day: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return date(from: dateComponents)
    }
}
