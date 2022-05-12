//
//  ServicesTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/4/21.
//

import UIKit

protocol CellActionDelegate{
    func didServiceConnect(for cell: ServicesTableViewCell)
    func didServiceReconnect(for cell: ServicesConnectTableViewCell)
}

class ServicesTableViewCell: UITableViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var actionDelegate: CellActionDelegate?
    
        let ico_image = UIImageView()
        let titleOne = UILabel()
        let titleTwo = UILabel()
        let titleThree = UILabel()
        let getButton = UIButton()
        let sale_title = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: cellID4)
        backgroundColor = .clear
        
        ico_image.image = UIImage(named: "services_cell_img")
        
        contentView.addSubview(ico_image)
        contentView.addSubview(titleOne)
        contentView.addSubview(titleTwo)
        contentView.addSubview(titleThree)
        contentView.addSubview(getButton)
        contentView.addSubview(sale_title)
        
        ico_image.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
        
        titleOne.frame = CGRect(x: 70, y: 10, width: UIScreen.main.bounds.size.width  - 100, height: 50)
        titleOne.text = ""
        titleOne.numberOfLines = 1
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.boldSystemFont(ofSize: 16)
        titleOne.textAlignment = .left
        
        titleTwo.frame = CGRect(x: 70, y: 35, width: UIScreen.main.bounds.size.width  - 100, height: 60)
        titleTwo.text = ""
        titleTwo.numberOfLines = 2
        titleTwo.textColor = darkGrayLight
        titleTwo.font = UIFont.systemFont(ofSize: 15)
        titleTwo.textAlignment = .left
        
        titleThree.frame = CGRect(x: 70, y: 80, width: 200, height: 60)
        
        titleThree.textAlignment = .left
        
        sale_title.frame = CGRect(x: 150, y: 100, width: 50, height: 20)
        sale_title.textAlignment = .center
        sale_title.textColor = .white
        sale_title.backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
        sale_title.font = UIFont.systemFont(ofSize: 13)
        sale_title.layer.cornerRadius = sale_title.frame.height / 2
        sale_title.layer.masksToBounds = true
        sale_title.isHidden = true
        
       // getButton.setImage(#imageLiteral(resourceName: "get_button"), for: UIControl.State.normal)
        getButton.frame = CGRect(x: UIScreen.main.bounds.size.width  - 170, y: 90, width: 150, height: 40)
        getButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        getButton.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        getButton.layer.cornerRadius = getButton.frame.height / 2
        getButton.addTarget(self, action: #selector(connectService), for: .touchUpInside)
    }
    
    @objc func connectService(_  sender: UIButton){
        sender.showAnimation { [self] in
            actionDelegate?.didServiceConnect(for: self)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
