//
//  RoumingTableCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/11/22.
//

import UIKit

class RoumingTableCell: UITableViewCell {
        
        let button = UIButton()
        let titleOne = UILabel()
        let opisanie = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "roming_list_cell")
        backgroundColor = .clear
        
        contentView.addSubview(button)
        contentView.addSubview(titleOne)
        contentView.addSubview(opisanie)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80)
        
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 20, width: 50, height: 30)
        button.setImage(#imageLiteral(resourceName: "drop_icon"), for: UIControl.State.normal)
        
        titleOne.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 90, height: 60)
        titleOne.text = ""
        titleOne.numberOfLines = 0
        titleOne.textColor = .black
        titleOne.font = UIFont.systemFont(ofSize: 20)
        titleOne.textAlignment = .left
        
        opisanie.numberOfLines = 0
        opisanie.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        opisanie.font = UIFont(name: "", size: 10)
        opisanie.lineBreakMode = NSLineBreakMode.byWordWrapping
        opisanie.textAlignment = .left
        opisanie.frame = CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width - 40, height: 0)
        opisanie.autoresizesSubviews = true
        opisanie.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    }

