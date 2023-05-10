//
//  PushTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/9/21.
//

import UIKit

class PushTableViewCell: UITableViewCell {
    
    var actionDelegate: CellPushDelegate?
    
    let view_cell = UIView()
    let title = UILabel()
    let about = UILabel()
    let titlemore = UILabel()
    let icon_more = UIButton()
    let icon_show_more = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "push_cell")
        backgroundColor = .clear
        view_cell.backgroundColor = alertColor
        view_cell.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: 90)
        view_cell.layer.cornerRadius = 20
        
        view_cell.addSubview(title)
        view_cell.addSubview(about)
        view_cell.addSubview(icon_more)
        contentView.addSubview(view_cell)
        
        //contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        
        title.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.size.width - 140, height: 50)
        title.text = "Скидка на Хаматарафа+200"
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.textAlignment = .left
        
        about.frame = CGRect(x: 20, y: 45, width: UIScreen.main.bounds.size.width - 120, height: 30)
        about.text = """
 С 4 мая по 31 октября действует 30% СКИДКА на пакет "Хаматарафа+100"
 """
        //about.numberOfLines = 2
        about.textColor = darkGrayLight
        about.font = UIFont.systemFont(ofSize: 15)
        about.textAlignment = .left
        
        icon_more.frame = CGRect(x: UIScreen.main.bounds.size.width - 60, y: 25, width: 11, height: 6)
        icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
        icon_more.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        
        icon_show_more.frame = CGRect(x: 70, y: 150, width: 200, height: 50)
        icon_show_more.setImage(#imageLiteral(resourceName: "icon_show_more"), for: UIControl.State.normal)
        
    }
    
    @objc func moreTapped() {
        actionDelegate?.didMoreTwoTapped(for: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
