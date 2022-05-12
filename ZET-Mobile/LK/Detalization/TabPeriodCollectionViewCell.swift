//
//  TabPeriodCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/30/21.
//

import UIKit

protocol CellTapPeriodActionDelegate {
    func didTapped(for cell: TabPeriodCollectionViewCell)
}

class TabPeriodCollectionViewCell: UICollectionViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var actionDelegate: CellTapPeriodActionDelegate?
    
    lazy var myPeriod: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.backgroundColor = .red
        
        //title.frame = CGRect(x: 20, y: 10, width: title.text!.count * 10, height: 30)
        return title
    }()
    
    lazy var oneDay: UILabel = {
        let title = UILabel()
        title.text = "Сутки"
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: (myPeriod.text!.count * 10) + 40, y: 10, width: title.text!.count * 10, height: 30)
        return title
    }()
    
    lazy var week: UILabel = {
        let title = UILabel()
        title.text = "Неделя"
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: (myPeriod.text!.count * 10) + (oneDay.text!.count * 10) + 40, y: 10, width: title.text!.count * 10, height: 30)
        return title
    }()
    
    lazy var month: UILabel = {
        let title = UILabel()
        title.text = "Месяц"
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: (myPeriod.text!.count * 10) + (oneDay.text!.count * 10) + (week.text!.count * 10) + 40, y: 10, width: title.text!.count * 10, height: 30)
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        myPeriod.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseTap))
        myPeriod.addGestureRecognizer(tap)
        
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addSubview(myPeriod)
        //contentView.addSubview(oneDay)
        //contentView.addSubview(week)
        //contentView.addSubview(month)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func chooseTap() {
        actionDelegate?.didTapped(for: self)
    }
}
