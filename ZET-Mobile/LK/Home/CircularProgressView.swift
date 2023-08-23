//
//  CircularProgressView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/3/21.
//

import UIKit

class CircularProgressView: UIView {

  // First create two layer properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var innerCircleLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()
    private var width: CGFloat = 0
    private var height: CGFloat = 0
    private let plusLayerHeight: CGFloat = 24.0
    
    var serviceTitle: String? {
        didSet {
            text.text = serviceTitle
        }
    }
    
    var spentProgress: CGFloat? {
        didSet {
            progressAnimation(value: spentProgress)
        }
    }
    
    let text: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width == 320 ? 9 : 12, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.textColor  = colorBlackWhite
        return label
    }()
    
    let text2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width == 320 ? 9 : 12, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.textColor  = colorBlackWhite
        return label
    }()
    
    let plusText: UIButton = {
        let button = UIButton()
        button.setImage((UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? #imageLiteral(resourceName: "plus-circle_b") : #imageLiteral(resourceName: "plus-circle_w")), for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.isHidden = true
        return button
    }()
        
    
    
    let clickActionEffect: UIButton = {
        let clickActionEffect = UIButton()
    
        clickActionEffect.setBackgroundImage((UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? #imageLiteral(resourceName: "clickEffectDark") : #imageLiteral(resourceName: "clickEffect")), for: UIControl.State.normal)
       
   
        clickActionEffect.backgroundColor = .clear
        clickActionEffect.layer.masksToBounds = true
        
       
        clickActionEffect.layer.masksToBounds = true
        clickActionEffect.isUserInteractionEnabled = true
        
        return clickActionEffect
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath(color1: color1, color2: color2)
    }
    
    override func layoutSubviews() {
       // super.layoutSubviews()
        
        createCircularPath(color1: color1, color2: color2)
        
        if frame.size.width != frame.size.height, frame.size.width < frame.size.height {
            width = frame.size.width - 5
            height = frame.size.width - 5
        } else if frame.size.width != frame.size.height, frame.size.width > frame.size.height {
            width = frame.size.height - 5
            height = frame.size.height - 5
        } else {
            width = frame.size.width - 5
            height = frame.size.height - 5
        }
       
        clickActionEffect.frame =  CGRect(x: (frame.size.width / 2) - ((width - 10) / 2), y: (frame.size.height / 2) - ((height - 10) / 2), width: width - 10, height: height - 10)
        
    
        clickActionEffect.layer.cornerRadius = (width - 10) / 2
        
        addSubview(clickActionEffect)
        
        text.frame = CGRect(x: (frame.width / 2) - ((width - 25) / 2), y: (frame.height / 2) - ((height / 2) / 2), width: width - 25, height: height / 2)
        
        text2.frame = CGRect(x: (frame.width / 2) - ((width - 25) / 2), y: 0, width: width - 25, height: height)
        
        addSubview(text)
        addSubview(text2)
        
        var paddingTop: CGFloat = 0
        if UIScreen.main.bounds.height <= 738 && UIScreen.main.bounds.height != 568 {
            paddingTop = frame.height - height - ((plusLayerHeight / 2) / 2) + 2
        } else if UIScreen.main.bounds.height == 568 {
            paddingTop = 5
        } else {
            paddingTop = 10
        }
        plusText.frame = CGRect(x: frame.width * 0.73, y: paddingTop, width: plusLayerHeight, height: plusLayerHeight)
        plusText.layer.cornerRadius = plusLayerHeight / 2
        addSubview(plusText)
        
        
}
   
    
    func createCircularPath(color1: UIColor, color2: UIColor) {
        if frame.size.width != frame.size.height, frame.size.width < frame.size.height {
            width = frame.size.width - 5
            height = frame.size.width - 5
        } else if frame.size.width != frame.size.height, frame.size.width > frame.size.height {
            width = frame.size.height - 5
            height = frame.size.height - 5
        } else {
            width = frame.size.width - 5
            height = frame.size.height - 5
        }
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: width / 2, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        let smallerCircularPath = UIBezierPath(roundedRect: CGRect(x: (frame.size.width / 2) - ((width - 10) / 2), y: (frame.size.height / 2) - ((height - 10) / 2), width: width - 10, height: height - 10), cornerRadius: (width - 10) / 2)
      
        innerCircleLayer.path = smallerCircularPath.cgPath
        innerCircleLayer.fillColor = color1.cgColor
        innerCircleLayer.strokeColor = UIColor.clear.cgColor
        innerCircleLayer.lineCap = .round
        innerCircleLayer.lineWidth = 5.0
        innerCircleLayer.shadowColor = UIColor.clear.cgColor
        innerCircleLayer.shadowRadius = 2
        innerCircleLayer.shadowOpacity = 0.3
        innerCircleLayer.shadowOffset = CGSize(width: 0, height: 1)
        innerCircleLayer.shadowPath = smallerCircularPath.cgPath
        
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 5.0
        circleLayer.strokeColor = color2.cgColor
  
         
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = color2.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 0
    
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor.orange.cgColor, UIColor.orange.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.mask = progressLayer

        
        layer.addSublayer(innerCircleLayer)
        layer.addSublayer(circleLayer)
        layer.addSublayer(gradientLayer)
       
    }
    
    func progressAnimation(duration: TimeInterval? = 0.5, value: CGFloat? = 0) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.fromValue = 0
        circularProgressAnimation.duration = duration!
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode =  .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    

}




