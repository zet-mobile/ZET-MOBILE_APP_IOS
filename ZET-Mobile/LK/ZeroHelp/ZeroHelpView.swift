//
//  ZeroHelpView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/29/21.
//

import UIKit

class ZeroHelpView: UIView {

    lazy var bannerImage: UIImageView = {
        let bannerImage = UIImageView()
        bannerImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 160)
        bannerImage.contentMode = .scaleAspectFit
        return bannerImage
    }()
    
    lazy var balanceAndPackagesTitle: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "BALANCE_AND_PACKAGES")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 170, width: 300, height: 28)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var balanceValue: UILabel = {
        let balanceValue = UILabel()
        balanceValue.text = ""
        balanceValue.numberOfLines = 0
        balanceValue.textColor = colorBlackWhite
        balanceValue.font = UIFont.preferredFont(forTextStyle: .subheadline)
        balanceValue.font = UIFont.boldSystemFont(ofSize: 24)
        balanceValue.lineBreakMode = NSLineBreakMode.byWordWrapping
        balanceValue.textAlignment = .right
        balanceValue.frame = CGRect(x: UIScreen.main.bounds.size.width - 220, y: 170, width: 200, height: 28)
        balanceValue.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return balanceValue
    }()
    
    let walletImage: UIImageView = {
        let walletImage = UIImageView()
        walletImage.image = UIImage(named: "wallet")
        walletImage.contentMode = .scaleAspectFill
        walletImage.backgroundColor = .clear
        walletImage.frame = CGRect(x: 20, y: 10, width: 25, height: 25)
        return walletImage
    }()
    
    lazy var expensesTitle: UILabel = {
        let expensesTitle = UILabel()
        expensesTitle.text = defaultLocalizer.stringForKey(key: "EXPENSES_FOR_3_MONTHS")
        expensesTitle.numberOfLines = 2
        expensesTitle.textColor = colorBlackWhite
        expensesTitle.font = UIFont.systemFont(ofSize: 16)
        expensesTitle.textAlignment = .left
        expensesTitle.frame = CGRect(x: 60, y: 0, width: 150, height: 55)
        return expensesTitle
    }()
    
    lazy var expensesValue: UILabel = {
        let expensesValue = UILabel()
        expensesValue.text = ""
        expensesValue.numberOfLines = 1
        expensesValue.textColor = .orange
        expensesValue.font = UIFont.boldSystemFont(ofSize: 18)
        expensesValue.textAlignment = .right
        return expensesValue
    }()
    
    lazy var line: UILabel = {
        let line = UILabel()
        line.frame = CGRect(x: 20, y: 55, width: UIScreen.main.bounds.size.width - 70, height: 2)
        line.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return line
    }()
    
    let calendarImage: UIImageView = {
        let calendarImage = UIImageView()
        calendarImage.image = UIImage(named: "Calendar")
        calendarImage.contentMode = .scaleAspectFill
        calendarImage.backgroundColor = .clear
        calendarImage.frame = CGRect(x: 20, y: 67, width: 25, height: 25)
        return calendarImage
    }()
    
    lazy var daysInNetworkTitle: UILabel = {
        let daysInNetworkTitle = UILabel()
        daysInNetworkTitle.text = defaultLocalizer.stringForKey(key: "DAYS_IN_NETWORK")
        daysInNetworkTitle.numberOfLines = 2
        daysInNetworkTitle.textColor = colorBlackWhite
        daysInNetworkTitle.font = UIFont.systemFont(ofSize: 16)
        daysInNetworkTitle.textAlignment = .left
        daysInNetworkTitle.frame = CGRect(x: 60, y: 57, width: 150, height: 55)
        return daysInNetworkTitle
    }()
    
    lazy var daysInNetworkValue: UILabel = {
        let daysInNetworkValue = UILabel()
        daysInNetworkValue.text = ""
        daysInNetworkValue.numberOfLines = 1
        daysInNetworkValue.textColor = .orange
        daysInNetworkValue.font = UIFont.boldSystemFont(ofSize: 18)
        daysInNetworkValue.textAlignment = .right
        return daysInNetworkValue
    }()
    
    lazy var Line2: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 92, width: UIScreen.main.bounds.size.width - 70, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    
    
    lazy var newPackageTitle: UILabel = {
        let newPackageTitle = UILabel()
        newPackageTitle.text = defaultLocalizer.stringForKey(key: "NEW_PACKAGE")
        newPackageTitle.numberOfLines = 0
        newPackageTitle.textColor = colorBlackWhite
        newPackageTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        newPackageTitle.font = UIFont.systemFont(ofSize: 17)
        newPackageTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        newPackageTitle.textAlignment = .center
        return newPackageTitle
    }()
    
    lazy var tab1Line: UILabel = {
        let title = UILabel()
        title.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        return title
    }()
    
    lazy var queryHistoryTitle: UILabel = {
        let queryHistoryTitle = UILabel()
        queryHistoryTitle.text = defaultLocalizer.stringForKey(key: "QUERY_HISTORY")
        queryHistoryTitle.numberOfLines = 0
        queryHistoryTitle.textColor = .gray
        queryHistoryTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        queryHistoryTitle.font = UIFont.systemFont(ofSize: 17)
        queryHistoryTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        queryHistoryTitle.textAlignment = .center
        return queryHistoryTitle
    }()
    
    lazy var tab2Line: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        return title
    }()
    
    let statusList = UIView(frame: CGRect(x: 20, y: 210, width: UIScreen.main.bounds.size.width - 40, height: 110))

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        statusList.backgroundColor = colorGrayWhite
        statusList.layer.cornerRadius = 20
        statusList.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        statusList.layer.shadowOpacity = 1
        statusList.layer.shadowOffset = .zero
        statusList.layer.shadowRadius = 10
        
        statusList.addSubview(walletImage)
        statusList.addSubview(expensesTitle)
        statusList.addSubview(line)
        statusList.addSubview(expensesValue)
        
        statusList.addSubview(calendarImage)
        statusList.addSubview(daysInNetworkTitle)
        statusList.addSubview(daysInNetworkValue)
        
        self.addSubview(statusList)
       
        let zeroHelpView = UIView(frame: CGRect(x: 0, y: 260, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        zeroHelpView.backgroundColor = contentColor
        self.addSubview(zeroHelpView)
        self.sendSubviewToBack(zeroHelpView)
        
        self.addSubview(bannerImage)
        self.addSubview(balanceAndPackagesTitle)
        self.addSubview(balanceValue)
        self.addSubview(newPackageTitle)
        self.addSubview(queryHistoryTitle)
        self.addSubview(tab1Line)
        self.addSubview(tab2Line)
    }
}

