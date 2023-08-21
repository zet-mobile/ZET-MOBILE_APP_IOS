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
    let sign = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "push_photo_cell")
        backgroundColor = .clear
        view_cell.backgroundColor = alertColor
        view_cell.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: 90)
        view_cell.layer.cornerRadius = 20
        
        ico_image.image = UIImage(named: "")
        title.text = ""
        
        view_cell.addSubview(ico_image)
        view_cell.addSubview(title)
        view_cell.addSubview(about)
        view_cell.addSubview(icon_more)
        view_cell.addSubview(icon_show_more)
        view_cell.addSubview(sign)
        contentView.addSubview(view_cell)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        
        ico_image.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
        ico_image.contentMode = .scaleAspectFit
        
        title.frame = CGRect(x: 70, y: 20, width: UIScreen.main.bounds.size.width - 140, height: 50)
        title.text = ""
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.textAlignment = .left
        
        about.frame = CGRect(x: 70, y: 60, width: UIScreen.main.bounds.size.width - 120, height: 30)
        about.text = ""
        //about.numberOfLines = 2
        about.textColor = darkGrayLight
        about.font = UIFont.systemFont(ofSize: 16)
        about.textAlignment = .left
        
        icon_more.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 15, width: 23, height: 18)
        icon_more.setImage(#imageLiteral(resourceName: "closed_icon"), for: UIControl.State.normal)
        icon_more.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        
        icon_show_more.frame = CGRect(x: 70, y: 90, width: 140, height: 45)
        icon_show_more.isHidden = true
        icon_show_more.addTarget(self, action: #selector(openMore), for: .touchUpInside)
        icon_show_more.contentHorizontalAlignment = .left
        icon_show_more.backgroundColor = .clear
        icon_show_more.setTitle("\(defaultLocalizer.stringForKey(key: "More_details")) >", for: .normal)
        icon_show_more.setTitleColor(.orange, for: .normal)
        icon_show_more.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        sign.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 50, width: 13, height: 13)
        sign.layer.cornerRadius = sign.frame.width  / 2
        sign.backgroundColor =  .clear
        sign.layer.backgroundColor = UIColor.orange.cgColor
        sign.layer.borderColor = colorLightDarkGray.cgColor
        sign.layer.borderWidth = 1
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
