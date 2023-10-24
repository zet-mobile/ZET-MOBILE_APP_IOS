//
//  MyTicketsViewCell.swift
//  ZET-Mobile
//
//  Created by iDev on 06/09/23.
//

import UIKit

class MyTicketsViewCell: UITableViewCell {
    
    let ico_image = UIImageView()
    let titleOne = UILabel()
    let titleTwo = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "myTickets_cell")
        backgroundColor = .clear
        
        ico_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "in_money_dark") : UIImage(named: "in_money"))
       // contentView.addSubview(ico_image)
        contentView.addSubview(titleOne)
        contentView.addSubview(titleTwo)
        
        
     //   contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 76)
        
       // ico_image.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
        
        titleOne.frame = CGRect(x: 20, y: contentView.frame.minY + 8, width: 240, height: 27)
        //titleOne.text = "fbfb"
        titleOne.numberOfLines = 2
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.boldSystemFont(ofSize: 20)
        titleOne.textAlignment = .left
        
        titleTwo.frame = CGRect(x: 20, y: contentView.frame.minY + 42, width: 340, height: 16)
       // titleTwo.text = "fgf"
        titleTwo.numberOfLines = 1
        titleTwo.textColor = .gray
        titleTwo.font = UIFont.systemFont(ofSize: 12)
        titleTwo.textAlignment = .left
        
    }
       

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    }

