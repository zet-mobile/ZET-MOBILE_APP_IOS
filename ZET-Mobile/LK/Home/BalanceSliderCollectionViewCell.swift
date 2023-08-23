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
    
    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "BalanceBack")
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .clear
        iv.autoresizesSubviews = true
        
        iv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return iv
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "Your_balance")
        titleOne.numberOfLines = 0
        titleOne.textColor = .white
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 40, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var balance: UILabel = {
        let user_name = UILabel()
        user_name.text = ""
        user_name.numberOfLines = 0
        user_name.textColor = .white
        user_name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        user_name.font = UIFont.boldSystemFont(ofSize: 25)
        user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        user_name.textAlignment = .left
        user_name.frame = CGRect(x: 20, y: 65, width: 200, height: 28)
        user_name.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return user_name
    }()
    
    lazy var popolnit: UIButton = {
        let popolnit = UIButton()
        //popolnit.setImage(#imageLiteral(resourceName: "Popolnit"), for: UIControl.State.normal)
        popolnit.backgroundColor = UIColor(red: 1, green: 0.871, blue: 0, alpha: 1)
        popolnit.setTitle("+ \(defaultLocalizer.stringForKey(key: "Top_up_balance"))", for: .normal)
        popolnit.setTitleColor(.black, for: .normal)
        popolnit.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        popolnit.frame = CGRect(x: UIScreen.main.bounds.size.width - 200, y: 40, width: 140, height: 35)
        popolnit.layer.cornerRadius = popolnit.frame.height / 2
        popolnit.addTarget(self, action: #selector(addBalanceOption), for: UIControl.Event.touchUpInside)
        
        return popolnit
    }()
    
    lazy var titleTarif: UILabel = {
        let titleTarif = UILabel()
        titleTarif.text = ""
        titleTarif.numberOfLines = 0
        titleTarif.textColor = .white
        titleTarif.font = UIFont.boldSystemFont(ofSize: 18)
        titleTarif.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleTarif.textAlignment = .left
        //titleTarif.frame = CGRect(x: 20, y: 60, width: 200, height: 20)
        titleTarif.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleTarif
    }()
    
    lazy var settings: UIButton = {
        let settings = UIButton()
        settings.setImage(UIImage(named: "Setting"), for: .normal)
        settings.frame = CGRect(x: titleTarif.text!.count * 10 + 30, y: 100, width: 30, height: 30)
        settings.addTarget(self, action: #selector(openTarifView), for: UIControl.Event.touchUpInside)
        settings.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return settings
    }()
    
    lazy var titleNumber: UILabel = {
        let titleNumber = UILabel()
        titleNumber.text = ""
        titleNumber.numberOfLines = 0
        titleNumber.textColor = .white
        titleNumber.font = UIFont.systemFont(ofSize: 18)
        titleNumber.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleNumber.textAlignment = .left
        titleNumber.frame = CGRect(x: 20, y: 155, width: 200, height: 20)
        titleNumber.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleNumber
    }()
    
    lazy var prereg: UIButton = {
        let prereg = UIButton()
        //prereg.setImage(UIImage(named: "preregFalse"), for: .normal)
        prereg.frame = CGRect(x: titleNumber.text!.count * 10 + 30, y: 152, width: 25, height: 25)
       // prereg.addTarget(self, action: #selector(showPrergInfo), for: UIControl.Event.touchUpInside)
        prereg.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return prereg
    }()
    
    lazy var preregInfo: UILabel = {
        let preregInfo = UILabel()
        preregInfo.isHidden = true
      //  preregInfo.backgroundColor = colorLightDarkGray
        preregInfo.text = ""
        preregInfo.numberOfLines = 0
        preregInfo.textColor = colorBlackWhite
        preregInfo.font = UIFont.systemFont(ofSize: 13)
        preregInfo.lineBreakMode = NSLineBreakMode.byWordWrapping
        preregInfo.textAlignment = .center
        //preregInfo.frame = CGRect(x: 20, y: 190, width: CGFloat(preregInfo.text!.count * 10 + 20), height: 45)
        preregInfo.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return preregInfo
    }()
    
    lazy var spisanie: UILabel = {
        let spisanie = UILabel()
        spisanie.text = ""
        spisanie.numberOfLines = 0
        spisanie.textColor = .white
        spisanie.font = UIFont.systemFont(ofSize: 18)
        spisanie.lineBreakMode = NSLineBreakMode.byWordWrapping
        spisanie.textAlignment = .left
        spisanie.frame = CGRect(x: 20, y: 130, width: 300, height: 20)
        spisanie.autoresizesSubviews = true
        spisanie.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return spisanie
    }()
    
    //for prereg info
    @objc func showPrergInfo(_ sender: UIButton){
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
        
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        image.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 210)
        contentView.addSubview(image)
        contentView.sendSubviewToBack(image)
        
        white_view_back = UIView(frame: CGRect(x: 15, y: 185, width: UIScreen.main.bounds.size.width - 60, height: 65))
        white_view_back.layer.cornerRadius = 15
        white_view_back.backgroundColor = contentColor
        white_view_back.layer.shadowRadius = 10
        white_view_back.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        white_view_back.layer.shadowOpacity = 1
        white_view_back.layer.shadowOffset = .zero
        white_view_back.isHidden = true
        
        //white_view_back.layer.borderColor = UIColor.darkGray.cgColor
        //white_view_back.layer.borderWidth = 0.2
      
        contentView.addSubview(titleOne)
        contentView.addSubview(balance)
        contentView.addSubview(popolnit)
        contentView.addSubview(titleTarif)
        contentView.addSubview(settings)
        contentView.addSubview(prereg)
        contentView.addSubview(titleNumber)
        contentView.addSubview(spisanie)

        contentView.addSubview(white_view_back)
        contentView.addSubview(preregInfo)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
