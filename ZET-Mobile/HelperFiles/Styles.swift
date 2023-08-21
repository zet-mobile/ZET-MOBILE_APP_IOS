//
//  ViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/14/21.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

var container: UIView = UIView()
var container2: UIView = UIView()

extension UIButton {
    
    func animateWhenPressed(disposeBag: DisposeBag) {
        let pressDownTransform = rx.controlEvent([.touchDown, .touchDragEnter])
            .map({ CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) })
        
        let pressUpTransform = rx.controlEvent([.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
            .map({ CGAffineTransform.identity })
        
        Observable.merge(pressDownTransform, pressUpTransform)
            .distinctUntilChanged()
            .subscribe(onNext: animate(_:))
            .disposed(by: disposeBag)
    }
    
    private func animate(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        self.transform = transform
            }, completion: nil)
    }
    
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func removeZerosFromEnd() -> String {
            let formatter = NumberFormatter()
            let number = NSNumber(value: self)
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
         return String(format: "%.2f", number)
        }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}

extension UIView {
    
    
    func frameRect(x: Double, y: Double, width: Double, height: Double) {
        frame = CGRect(x: (Double(UIScreen.main.bounds.size.width) * x) / 428, y: (Double(UIScreen.main.bounds.size.height) * y) / 926, width: (Double(UIScreen.main.bounds.size.width) * width) / 428, height: (Double(UIScreen.main.bounds.size.height) * height) / 926)
    }

    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat? = 0,
                paddingLeft: CGFloat? = 0,
                paddingBottom: CGFloat? = 0,
                paddingRight: CGFloat? = 0,
                width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UITextField {
    
    @discardableResult
    func setView(_ view: ViewType, image: UIImage?, width: CGFloat = 20) -> UIButton {
        let button = UIButton(frame: CGRect(x: 5, y: 0, width: 25, height: 25))
        button.setImage(image, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.sizeToFit()
        //button.imageView!.contentMode = .scaleAspectFit
        
        setView(view, with: button)
        return button
    }
    
    enum ViewType {
        case left, right
    }
    
    func setView(_ type: ViewType, with view: UIView) {
        if type == ViewType.left {
            leftView = view
            leftViewMode = .always
        } else if type == .right {
            rightView = view
            rightViewMode = .always
        }
    }
}

extension UISwitch {

    func setFrame(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}

extension UIViewController {
    
    func getViewsInView(view: UIView) -> [UIView] {
        var results = [UIView]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UIView {
                results += [labelView]
            } else {
                results += getViewsInView(view: subview)
            }
        }
        return results
    }
    
    func getButtonsInView(view: UIView) -> [UIButton] {
        var results = [UIButton]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UIButton {
                results += [labelView]
            } else {
                results += getButtonsInView(view: subview)
            }
        }
        return results
    }
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
    
    func getImagesInView(view: UIView) -> [UIImageView] {
        var results = [UIImageView]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UIImageView {
                results += [labelView]
            } else {
                results += getImagesInView(view: subview)
            }
        }
        return results
    }
    
    func showActivityIndicator(uiView: UIView) {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = .clear
        activityIndicator.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - 5, y: ((UIScreen.main.bounds.size.height/2) - 5), width: 10.0, height: 10.0)
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.color = .orange
        container.addSubview(activityIndicator)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    func showActivityIndicator2(uiView: UIView) {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        container2.frame = uiView.frame
        container2.center = uiView.center
        container2.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        activityIndicator.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - 5, y: ((UIScreen.main.bounds.size.height/2) - 5), width: 10.0, height: 10.0)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = .orange
        container2.addSubview(activityIndicator)
        uiView.addSubview(container2)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator2(uiView: UIView) {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.stopAnimating()
        container2.removeFromSuperview()
    }
    
}

public extension UIView {
 
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = true
        let originalBackgroundColor = backgroundColor
        
        UIView.animate(withDuration: 0.01,
                       animations: { [weak self] in
                           self?.backgroundColor = .gray
                       }) { [weak self] (_) in
                           UIView.animate(withDuration: 0.01,
                                          animations: { [weak self] in
                                              self?.backgroundColor = originalBackgroundColor
                                          }) { [weak self] (_) in
                                              self?.isUserInteractionEnabled = true
                                              completionBlock()
                                          }
                       }
    }




    
    func showAnimation2(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            self!.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self?.backgroundColor = .clear
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
