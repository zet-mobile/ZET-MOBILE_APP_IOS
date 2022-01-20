//
//  UsageCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/10/21.
//

import UIKit

class UsageCollectionViewCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Call_usage")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 20, y: 10, width: 25, height: 25)
        return iv
    }()
    
    lazy var title1: UILabel = {
        let title = UILabel()
        title.text = "Минуты"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 60, y: 0, width: 100, height: 45)
        
        return title
    }()
    
    lazy var rez1: UILabel = {
        let title = UILabel()
        title.text = "23"
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 0, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line1: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 45, width: UIScreen.main.bounds.size.width - 50, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    let image2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "zet")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 20, y: 57, width: 25, height: 25)
        return iv
    }()
    
    lazy var title2: UILabel = {
        let title = UILabel()
        title.text = "Минуты внутри сети"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 60, y: 47, width: 200, height: 45)
        
        return title
    }()
    
    lazy var rez2: UILabel = {
        let title = UILabel()
        title.text = "23"
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 47, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line2: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 92, width: UIScreen.main.bounds.size.width - 50, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    let image3: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Chart")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 20, y: 104, width: 25, height: 25)
        return iv
    }()
    
    lazy var title3: UILabel = {
        let title = UILabel()
        title.text = "Интернет"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 60, y: 94, width: 100, height: 45)
        
        return title
    }()
    
    lazy var rez3: UILabel = {
        let title = UILabel()
        title.text = "23"
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 94, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line3: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 94, width: UIScreen.main.bounds.size.width - 50, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    let image4: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Message")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 20, y: 151, width: 25, height: 25)
        return iv
    }()
    
    lazy var title4: UILabel = {
        let title = UILabel()
        title.text = "SMS"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 60, y: 141, width: 100, height: 45)
        
        return title
    }()
    
    lazy var rez4: UILabel = {
        let title = UILabel()
        title.text = "23"
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 141, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line4: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 141, width: UIScreen.main.bounds.size.width - 50, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    let image5: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "More Square")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 20, y: 198, width: 25, height: 25)
        return iv
    }()
    
    lazy var title5: UILabel = {
        let title = UILabel()
        title.text = "Звонки на короткие номера"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 60, y: 188, width: 200, height: 45)
        
        return title
    }()
    
    lazy var rez5: UILabel = {
        let title = UILabel()
        title.text = "23"
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 188, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line5: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 188, width: UIScreen.main.bounds.size.width - 50, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    let image6: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Wallet2")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 20, y: 245, width: 25, height: 25)
        return iv
    }()
    
    lazy var title6: UILabel = {
        let title = UILabel()
        title.text = "Сомони"
        title.numberOfLines = 1
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 60, y: 235, width: 100, height: 45)
        
        return title
    }()
    
    lazy var rez6: UILabel = {
        let title = UILabel()
        title.text = "23"
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 235, width: 100, height: 45)
        
        return title
    }()

    
    lazy var Line6: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 235, width: UIScreen.main.bounds.size.width - 50, height: 2)
        title.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(image)
        contentView.addSubview(title1)
        contentView.addSubview(Line1)
        contentView.addSubview(rez1)
        
        contentView.addSubview(image2)
        contentView.addSubview(title2)
        //contentView.addSubview(Line2)
        contentView.addSubview(rez2)
        
        contentView.addSubview(image3)
        contentView.addSubview(title3)
        contentView.addSubview(Line3)
        contentView.addSubview(rez3)
        
        contentView.addSubview(image4)
        contentView.addSubview(title4)
        contentView.addSubview(Line4)
        contentView.addSubview(rez4)
        
        contentView.addSubview(image5)
        contentView.addSubview(title5)
        contentView.addSubview(Line5)
        contentView.addSubview(rez5)
        
        contentView.addSubview(image6)
        contentView.addSubview(title6)
        contentView.addSubview(Line6)
        contentView.addSubview(rez6)
        
        //image.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
