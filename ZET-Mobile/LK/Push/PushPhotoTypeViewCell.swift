//
//  PishPhotoTypeViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/9/21.
//

import UIKit

protocol CellPushDelegate{
    func didMoreTapped(for cell: PushPhotoTypeViewCell)
    func didMoreTwoTapped(for cell: PushTableViewCell)
    func didOpenSheetMore(for cell: PushPhotoTypeViewCell)
}

class PushPhotoTypeViewCell: UITableViewCell {

    var actionDelegate: CellPushDelegate?
    
    let view_cell = UIView()
    let ico_image = UIImageView()
    let title = UILabel()
    let about = UILabel()
    let titlemore = UILabel()
    let icon_more = UIButton()
    let icon_show_more = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "push_photo_cell")
        backgroundColor = .clear
        //view_cell.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? colorFrom1 : colorTo1)
        view_cell.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: 90)
        view_cell.layer.cornerRadius = 20
        
        ico_image.image = UIImage(named: "services_cell_img")
        title.text = ""
        
        view_cell.addSubview(ico_image)
        view_cell.addSubview(title)
        view_cell.addSubview(about)
        view_cell.addSubview(icon_more)
        view_cell.addSubview(icon_show_more)
        contentView.addSubview(view_cell)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        
        ico_image.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
        
        title.frame = CGRect(x: 70, y: 5, width: 300, height: 50)
        title.text = "Скидка на Хаматарафа+200"
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        
        about.frame = CGRect(x: 70, y: 45, width: 300, height: 30)
        about.text = """
 С 4 мая по 31 октября действует 30% СКИДКА на пакет \n "Хаматарафа+100"
 """
        //about.numberOfLines = 2
        about.textColor = darkGrayLight
        about.font = UIFont.systemFont(ofSize: 16)
        about.textAlignment = .left
        
        icon_more.frame = CGRect(x: 355, y: 25, width: 11, height: 6)
        icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
        icon_more.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        
        icon_show_more.frame = CGRect(x: 70, y: 100, width: 140, height: 45)
        icon_show_more.setImage(#imageLiteral(resourceName: "icon_show_more"), for: UIControl.State.normal)
        icon_show_more.isHidden = true
        icon_show_more.addTarget(self, action: #selector(openMore), for: .touchUpInside)
        icon_show_more.contentHorizontalAlignment = .left
        
    }
    
    @objc func moreTapped() {
        actionDelegate?.didMoreTapped(for: self)
    }
    
    @objc func openMore() {
        actionDelegate?.didOpenSheetMore(for: self)
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
