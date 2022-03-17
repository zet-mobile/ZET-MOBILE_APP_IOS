//
//  SplashViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/20/22.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        imageViewBackground.image = UIImage(named: "splash_img.png")
        imageViewBackground.contentMode = UIView.ContentMode.scaleToFill
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(touches), userInfo: nil, repeats: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func touches() {
//        print(UserDefaults.standard.string(forKey: "token")!)
    //    print(UserDefaults.standard.string(forKey: "mobPhone"))
        
        if (UserDefaults.standard.string(forKey: "mobPhone") != nil) {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }

            guard let rootViewController = window.rootViewController else {
                return
            }
            let vc = ContainerViewController()
            vc.view.frame = rootViewController.view.frame
            vc.view.layoutIfNeeded()
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                    window.rootViewController = vc
              }, completion: nil)
        }
        else {
              self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
              navigationController?.pushViewController(AuthorizationViewController(), animated: false)
          }
        
      }
    
}


