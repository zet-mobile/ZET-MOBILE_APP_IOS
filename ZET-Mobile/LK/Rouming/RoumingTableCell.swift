//
//  RoumingTableCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/11/22.
//

import UIKit

class RoumingTableCell: UITableViewCell {

    let opisanie = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "roming_list_cell")
        contentView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 80)
        
        backgroundColor = .clear
        
        selectionStyle = .none

        contentView.addSubview(opisanie)
        
        opisanie.textColor = darkGrayLight
        opisanie.font = UIFont(name: "", size: 10)
        opisanie.textAlignment = .left
        opisanie.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 40, height: CGFloat.greatestFiniteMagnitude)
        opisanie.numberOfLines = 0
        opisanie.lineBreakMode = NSLineBreakMode.byWordWrapping
        opisanie.sizeToFit()
      
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

