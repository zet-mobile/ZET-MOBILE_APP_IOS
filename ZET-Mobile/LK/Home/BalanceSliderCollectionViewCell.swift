//
//  BalanceSliderCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/3/21.
//

import UIKit

protocol CellBalanceActionDelegate{
    func didSettingTapped(for cell: BalanceSliderCollectionViewCell)
    func didAddBalance(for cell: BalanceSliderCollectionViewCell)
}

class BalanceSliderCollectionViewCell: UICollectionViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var actionDelegate: CellBalanceActionDelegate?
    
    var taped = false
    
    var white_view_back = UIView()
    
    let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "BalanceBack")
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.backgroundColor = .clear
        backgroundImage.autoresizesSubviews = true
        backgroundImage.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return backgroundImage
    }()
    
    lazy var yourBalanceTitle: UILabel = {
        let yourBalanceTitle = UILabel()
        yourBalanceTitle.text = defaultLocalizer.stringForKey(key: "Your_balance")
        yourBalanceTitle.numberOfLines = 0
        yourBalanceTitle.textColor = .white
        yourBalanceTitle.font = UIFont.systemFont(ofSize: 16)
        yourBalanceTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        yourBalanceTitle.textAlignment = .left
       // yourBalanceTitle.frame = CGRect(x: contentView.bounds.minX + 23.72 , y: contentView.bounds.minY + 20 , width: 300, height: 20)
        yourBalanceTitle.autoresizesSubviews = true
        yourBalanceTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return yourBalanceTitle
    }()
    
    
    
    
    lazy var balanceValue: UILabel = {
        let balanceValue = UILabel()
        balanceValue.text = ""
        balanceValue.numberOfLines = 0
        balanceValue.textColor = .white
        balanceValue.font = UIFont.preferredFont(forTextStyle: .subheadline)
        balanceValue.font = UIFont.boldSystemFont(ofSize: 25)
        balanceValue.lineBreakMode = NSLineBreakMode.byWordWrapping
        balanceValue.textAlignment = .left
       // balanceValue.frame = CGRect(x: yourBalanceTitle.bounds.minX, y: yourBalanceTitle.bounds.maxY + 4 , width: 200, height: 28)
        balanceValue.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return balanceValue
    }()
    
    lazy var topUpBalance: UIButton = {
        let topUpBalance = UIButton()
        topUpBalance.backgroundColor = UIColor(red: 1, green: 0.871, blue: 0, alpha: 1)
        topUpBalance.setTitle("+ \(defaultLocalizer.stringForKey(key: "Top_up_balance"))", for: .normal)
        topUpBalance.setTitleColor(.black, for: .normal)
        topUpBalance.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        //topUpBalance.frame = CGRect(x: contentView.bounds.minX + 213, y: contentView.bounds.minY + 20, width: 140, height: 35)
        topUpBalance.layer.cornerRadius = 15
        topUpBalance.addTarget(self, action: #selector(addBalanceOption), for: UIControl.Event.touchUpInside)
        return topUpBalance
    }()
    
    lazy var tariffTitle: UILabel = {
        let tariffTitle = UILabel()
        tariffTitle.text = ""
        tariffTitle.numberOfLines = 0
        tariffTitle.textColor = .white
        tariffTitle.font = UIFont.boldSystemFont(ofSize: 18)
        tariffTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        tariffTitle.textAlignment = .left
        tariffTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return tariffTitle
    }()
    
    lazy var settingsButton: UIButton = {
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "Setting"), for: .normal)
        settingsButton.frame = CGRect(x: tariffTitle.text!.count * 10 + 30, y: 100, width: 30, height: 30)
        settingsButton.addTarget(self, action: #selector(openTarifView), for: UIControl.Event.touchUpInside)
        settingsButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return settingsButton
    }()
    
    lazy var numberTitle: UILabel = {
        let numberTitle = UILabel()
        numberTitle.text = ""
        numberTitle.numberOfLines = 0
        numberTitle.textColor = .white
        numberTitle.font = UIFont.systemFont(ofSize: 18)
        numberTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        numberTitle.textAlignment = .left
        numberTitle.frame = CGRect(x: 20, y: 155, width: 200, height: 20)
        numberTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return numberTitle
    }()
    
    lazy var prereg: UIButton = {
        let prereg = UIButton()
        prereg.frame = CGRect(x: numberTitle.text!.count * 10 + 30, y: 152, width: 25, height: 25)
        prereg.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return prereg
    }()
    
    lazy var preregInfo: UILabel = {
        let preregInfo = UILabel()
        preregInfo.isHidden = true
        preregInfo.text = ""
        preregInfo.numberOfLines = 0
        preregInfo.textColor = colorBlackWhite
        preregInfo.font = UIFont.systemFont(ofSize: 13)
        preregInfo.lineBreakMode = NSLineBreakMode.byWordWrapping
        preregInfo.textAlignment = .center
        preregInfo.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return preregInfo
    }()
    
    lazy var paymentDate: UILabel = {
        let paymentDate = UILabel()
        paymentDate.text = ""
        paymentDate.numberOfLines = 0
        paymentDate.textColor = .white
        paymentDate.font = UIFont.systemFont(ofSize: 18)
        paymentDate.lineBreakMode = NSLineBreakMode.byWordWrapping
        paymentDate.textAlignment = .left
        paymentDate.frame = CGRect(x: 20, y: 130, width: 300, height: 20)
        paymentDate.autoresizesSubviews = true
        paymentDate.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return paymentDate
    }()
    
    @objc func showPreregInfo(_ sender: UIButton){
        sender.showAnimation {
            if(self.taped)
            {
                self.preregInfo.isHidden = true
                self.white_view_back.isHidden = true
                self.taped = false
                
            }
            else
            {
                self.preregInfo.isHidden = false
                self.white_view_back.isHidden = false
                self.taped = true
            }
        }
        
    }
    
    @objc func openTarifView(_ sender: UIButton){
        sender.showAnimation { [self] in
            actionDelegate?.didSettingTapped(for: self)
        }
        
    }
    
    @objc func addBalanceOption(_ sender: UIButton){
        sender.showAnimation { [self] in
            actionDelegate?.didAddBalance(for: self)
        }
        
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        yourBalanceTitle.translatesAutoresizingMaskIntoConstraints = false
        balanceValue.translatesAutoresizingMaskIntoConstraints = false
        topUpBalance.translatesAutoresizingMaskIntoConstraints = false
        tariffTitle.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false

     
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        backgroundImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 210)
        contentView.addSubview(backgroundImage)
        contentView.sendSubviewToBack(backgroundImage)
        
        white_view_back = UIView(frame: CGRect(x: 15, y: 185, width: UIScreen.main.bounds.size.width - 60, height: 65))
        white_view_back.layer.cornerRadius = 15
        white_view_back.backgroundColor = contentColor
        white_view_back.layer.shadowRadius = 10
        white_view_back.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        white_view_back.layer.shadowOpacity = 1
        white_view_back.layer.shadowOffset = .zero
        white_view_back.isHidden = true


        
        yourBalanceTitle.addSubview(balanceValue)
        contentView.addSubview(yourBalanceTitle)
      //  contentView.addSubview(balanceValue)
        contentView.addSubview(topUpBalance)
        contentView.addSubview(tariffTitle)
        contentView.addSubview(settingsButton)
        contentView.addSubview(prereg)
        contentView.addSubview(numberTitle)
        contentView.addSubview(paymentDate)
        contentView.addSubview(white_view_back)
        contentView.addSubview(preregInfo)
        NSLayoutConstraint.activate([yourBalanceTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                     yourBalanceTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23.72),
                                     
                                     balanceValue.topAnchor.constraint(equalTo: yourBalanceTitle.bottomAnchor, constant: 4),
                                     balanceValue.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23.72),
                                     
                                     topUpBalance.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                     topUpBalance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                                     topUpBalance.heightAnchor.constraint(equalToConstant: 30),
                                     topUpBalance.widthAnchor.constraint(equalToConstant: 106),
                                     
                                     tariffTitle.topAnchor.constraint(equalTo: yourBalanceTitle.bottomAnchor, constant: 55),
                                     tariffTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23.72),
                                     
                                     settingsButton.topAnchor.constraint(equalTo: yourBalanceTitle.bottomAnchor, constant: 55),
                                     settingsButton.leadingAnchor.constraint(equalTo: tariffTitle.trailingAnchor, constant: 6) 

                                     
])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
