//
//  CalendarViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 12/2/21.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    let calendar_view = CalendarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width - 10, height: UIScreen.main.bounds.size.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = true
       
        calendar_view.layer.cornerRadius = 10
        view.addSubview(calendar_view)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

class CalendarView: UIView, FSCalendarDataSource, FSCalendarDelegate {
    
    fileprivate weak var calendar: FSCalendar!
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 20, height: 20)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = false
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title_calendar: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.text = "Выберите период"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        
        return title
    }()
    
    
    lazy var connect: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 70 + (UIScreen.main.bounds.size.width) + 60 + 20, width: UIScreen.main.bounds.size.width - 20, height: 50)
        button.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
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
        backgroundColor = .white
     
        /*let calendar = FSCalendar(frame: CGRect(x: 20, y: 70, width: UIScreen.main.bounds.size.width - 40, height: 300))
        calendar.dataSource = self
        calendar.delegate = self*/
        
        let calendar = CalendarView(frame: CGRect(x: 20, y: 70, width: UIScreen.main.bounds.size.width - 40, height: 300))
        self.addSubview(calendar)
        //self.calendar = calendar
        
        self.addSubview(title_calendar)
        self.addSubview(close)
        self.addSubview(connect)

    }
}

