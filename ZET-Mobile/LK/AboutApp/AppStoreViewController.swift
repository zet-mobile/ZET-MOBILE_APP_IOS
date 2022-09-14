//
//  AppStoreViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 01/08/22.
//

import UIKit
import WebKit
import StoreKit

class AppStoreViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, SKStoreProductViewControllerDelegate {
    
    // Create a store product view controller.
    var storeProductViewController = SKStoreProductViewController()
    let app_store_view = AppStoreView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = true
        
        app_store_view.layer.cornerRadius = 10
        
        view.addSubview(app_store_view)
     
        storeProductViewController.delegate = self
        
        /*var conditionWV = WKWebView(frame: CGRect( x: 0, y: 60, width: 414, height: 697), configuration: WKWebViewConfiguration())
        self.view.addSubview(conditionWV)
        let myURL = URL(string: "https://apps.apple.com/ru/app/salom/id1535038896")
        let myRequest = URLRequest(url: myURL!)
        conditionWV.inputViewController?.open(scheme: "https://apps.apple.com/ru/app/salom/id1535038896")*/
        let parametersDict = [SKStoreProductParameterITunesItemIdentifier: 1535038896]
         
                /* Attempt to load it, present the store product view controller if success
                    and print an error message, otherwise. */
                storeProductViewController.loadProduct(withParameters: parametersDict, completionBlock: { (status: Bool, error: Error?) -> Void in
                    if status {
                       self.present(self.storeProductViewController, animated: true, completion: nil)
                    }
                    else {
                       if let error = error {
                       print("Error: \(error.localizedDescription)")
                  }}})
    }


}

class AppStoreView: UIView {
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 10, width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.isUserInteractionEnabled = false
        //button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: 30)
        title.text = defaultLocalizer.stringForKey(key: "About")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.boldSystemFont(ofSize: 22)
        title.textAlignment = .left
        
        return title
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = colorGrayWhite
     
        self.addSubview(title)
        self.addSubview(close)
    }
}

