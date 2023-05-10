//
//  MenuViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/23/22.
//

import UIKit

class MenuViewCell: UITableViewCell {
    // MARK: - Properties
    
    let ico_image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = colorBlackWhite
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        
        addSubview(ico_image)
        addSubview(descriptionLabel)
        addSubview(countLabel)
        
        backgroundColor = contentColor
        ico_image.frame = CGRect(x: 25, y: 20, width: 20, height: 20)
        descriptionLabel.frame = CGRect(x: 65, y: 20, width: UIScreen.main.bounds.size.width  - 150, height: 20)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textAlignment = .left
        
        countLabel.frame = CGRect(x: UIScreen.main.bounds.size.width  - 140, y: 20, width: 50, height: 20)
        countLabel.numberOfLines = 1
        countLabel.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers

}
