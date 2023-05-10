//
//  ReplyToZetViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class ReplyToZetViewController: UIViewController , UIScrollViewDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var reply_view = ReplyToZetView()
    var alert = UIAlertController()
    
    private lazy var imagePicker: ImagePicker = {
            let imagePicker = ImagePicker()
            imagePicker.delegate = self
            return imagePicker
        }()
    
    var feedback_data = [[String]]()
    
    var emailChoosed = ""
    var typeMessageChoosed = ""
    var typeMessageChoosedID = 1
    
    var screenshotsData = [Data]()
    var screenImg = [UIImage]()
    var screenKeys = [String]()
    var screenName = [String]()
    
    var y_pozition = 430
    var but_pozition = 460
    var screen_i = 1
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivityIndicator(uiView: self.view)
        view.backgroundColor = contentColor
        
        reply_view = ReplyToZetView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
        reply_view.text_message.delegate = self
        
        sendRequest()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            scrollView.scrollIndicatorInsets = view.safeAreaInsets
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            // Fallback on earlier versions
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func touchesView() {
        reply_view.text_message.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if reply_view.text_message.text == defaultLocalizer.stringForKey(key: "problem_detail"){
            reply_view.text_message.text = ""
        }
        reply_view.text_message.textColor = colorBlackWhite
        
        if reply_view.button.frame.origin.y == 430 {
            reply_view.text_message.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
            reply_view.button.frame.origin.y = 400
            reply_view.titleRed.isHidden = true
            
            let buttons = getButtonsInView(view: scrollView)
            for button in buttons {
                if button.image(for: .normal) == UIImage(named: "correct") || button.image(for: .normal) == UIImage(named: "Trash_light") {
                    button.frame.origin.y -= 30
                }
                
            }
            
            let labels = getLabelsInView(view: self.scrollView)
            for label in labels {
                
                if label.frame.origin.y >= 400 && label.text != defaultLocalizer.stringForKey(key: "Send") {
                    label.frame.origin.y -= 30
                }
            }
            
            reply_view.button_send.frame.origin.y -= 30
            y_pozition -= 30
            i = 0
        }
        
    }
    
    func setupView() {
        view.backgroundColor = contentColor
  
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = contentColor
        scrollView.contentSize = CGSize(width: view.frame.width, height: 500)
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
         
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(touchesView))
        reply_view.isUserInteractionEnabled = true
        reply_view.addGestureRecognizer(tapGestureRecognizer2)
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(reply_view)
        
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Feedback")
        toolbar.backgroundColor = contentColor
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
    }
    
    func setupViewData() {
        if feedback_data.count != 0 {
            reply_view.type_message.text = feedback_data[0][2]
            reply_view.email.text = feedback_data[0][1]
        }
        
        reply_view.type_message.didSelect { [self] (selectedText, index, id) in
            typeMessageChoosed = selectedText
            emailChoosed = feedback_data[index][1]
            typeMessageChoosedID = Int(feedback_data[index][0]) ?? 1
            
            reply_view.type_message.text = feedback_data[index][2]
            reply_view.email.text = feedback_data[index][1]
            
            
        }
        
        for i in 0 ..< feedback_data.count {
            reply_view.type_message.optionArray.append(feedback_data[i][2])
            reply_view.type_message.optionIds?.append(i)
            
        }
        
        reply_view.button.addTarget(self, action: #selector(choosedScreenshot), for: .touchUpInside)
        reply_view.button_send.addTarget(self, action: #selector(sendScreen), for: .touchUpInside)
    }

    func sendRequest() {
        let client = APIClient.shared
            do{
              try client.getFeedBackRequest().subscribe(
                onNext: { result in
                    DispatchQueue.main.async {
                        
                        if result.feedback != nil {
                            if result.feedback.count != 0 {
                                for i in 0 ..< result.feedback.count {
                                    self.feedback_data.append([String(result.feedback[i].id), String(result.feedback[i].supportEmail), String(result.feedback[i].messageSubject)])
                                }
                            }
                        }
    
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                        requestAnswer(status: false, message: defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                    }
                },
                onCompleted: {
                    DispatchQueue.main.async { [self] in
                        setupView()
                        setupViewData()
                        hideActivityIndicator(uiView: view)
                    }
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func sendScreen() {
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        alert.view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width * 0.90
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
        alert.view.addConstraint(widthConstraint)
        
        let view = AlertView()

        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 320)
        view.layer.cornerRadius = 20
        
        view.image_icon.image = UIImage(named: "App Icon")
        view.name.text = defaultLocalizer.stringForKey(key: "Feedback")
        view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Send_message"))"
        view.ok.setTitle(defaultLocalizer.stringForKey(key: "Proceed"), for: .normal)
        
        view.name_content.frame.origin.y -= 20
        view.name_content.font = UIFont.systemFont(ofSize: 19)
        view.ok.frame.origin.y -= 20
        
        view.cancel.addTarget(self, action: #selector(dismissDialogCancel), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        print("i", i)
        if (reply_view.text_message.text == "" || reply_view.text_message.text == defaultLocalizer.stringForKey(key: "problem_detail")) && i == 0 {
            print("baby")
            reply_view.text_message.layer.borderColor = UIColor.red.cgColor
            reply_view.button.frame.origin.y = 430
            reply_view.titleRed.isHidden = false
            
            let buttons = getButtonsInView(view: scrollView)
            for button in buttons {
                if button.image(for: .normal) == UIImage(named: "correct") || button.image(for: .normal) == UIImage(named: "Trash_light") {
                    button.frame.origin.y += 30
                }
            }
            
            let labels = getLabelsInView(view: self.scrollView)
            for label in labels {
                
                if label.frame.origin.y >= 430 && label.text != defaultLocalizer.stringForKey(key: "Send") {
                    label.frame.origin.y += 30
                }
            }
            
            reply_view.button_send.frame.origin.y += 30
            y_pozition += 30
            i += 1
        } else if (reply_view.text_message.text == "" || reply_view.text_message.text == defaultLocalizer.stringForKey(key: "problem_detail")) && i > 0{
            print("jjjii")
            reply_view.text_message.layer.borderColor = UIColor.red.cgColor
            reply_view.button.frame.origin.y = 430
            reply_view.titleRed.isHidden = false
        }
        else {
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @objc func requestAnswer(status: Bool, message: String) {
        hideActivityIndicator(uiView: view)
        
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        alert.view.removeConstraints(widthConstraints)
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width * 0.90
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
        alert.view.addConstraint(widthConstraint)
        
        let view = AlertView()

        view.backgroundColor = contentColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 320)
        view.layer.cornerRadius = 20
        if status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "Application_accepted")
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "Something went wrong")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        view.name_content.frame.origin.y -= 20
        view.name_content.font = UIFont.systemFont(ofSize: 19)
        view.ok.frame.origin.y -= 20
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        print("hello")
        alert.dismiss(animated: true, completion: nil)
        hideActivityIndicator(uiView: view)
        
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
    
    @objc func dismissDialogCancel(_ sender: UIButton) {
        print("hello")
        alert.dismiss(animated: true, completion: nil)
        hideActivityIndicator(uiView: view)
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        alert.dismiss(animated: true, completion: nil)
      
        showActivityIndicator(uiView: view)
        
        let parametrs: [String: Any] = ["feedBackId": typeMessageChoosedID, "feedBackMessage":  String(reply_view.text_message.text!)]
        
        print(typeMessageChoosedID)
       // print(screenImg[0])
        var mediaImages = [Media]()
        
        if screenImg.count != 0 {
            for i in 0 ..< screenImg.count {
                // guard let mediaImage = Media(withImage: screenImg[i], forKey: "file") else {return}
                mediaImages.append(Media(withImage: screenImg[i], forKey: "file")!)
            }
        }
        
        
        let client = APIClient.shared
            do{
                try client.postFeedBackRequest(jsonBody: parametrs, mediaImage: mediaImages).subscribe(
                onNext: { [self] result in
                  print(result)
                    print("here")
                    //sendRequest()
                    DispatchQueue.main.async {
                        if result.success == true {
                            print("true")
                            requestAnswer(status: true, message: String(result.message ?? ""))
                        }
                        else {
                            print("false")
                            requestAnswer(status: false, message: String(result.message ?? ""))
                        }
                    }
                },
                onError: { error in
                   print(error.localizedDescription)
                    DispatchQueue.main.async { [self] in
                        hideActivityIndicator(uiView: self.view)
                    }
                },
                onCompleted: { [self] in
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func choosedScreenshot() {
        if screenName.count < 5 {
            imagePicker.photoGalleryAsscessRequest()
        }
      }
      
    
    @objc func deleteImage(_ sender: UIButton, _ sender2: UILabel){
        print(sender.tag)
        screenName.remove(at: sender.tag - 1)
        screenImg.remove(at: sender.tag - 1)
        
        let buttons = getButtonsInView(view: scrollView)
        for button in buttons {
            if button.image(for: .normal) == UIImage(named: "correct") || button.image(for: .normal) == UIImage(named: "Trash_light") {
                button.removeFromSuperview()
            }
            
            /*if button.tag == sender.tag {
                button.removeFromSuperview()
            }*/
        }
        
        let labels = getLabelsInView(view: self.scrollView)
        for label in labels {
            
            if label.frame.origin.y >= 430 && label.text != defaultLocalizer.stringForKey(key: "Send") {
                label.removeFromSuperview()
            }
        }
        
        if reply_view.text_message.layer.borderColor == UIColor.red.cgColor {
            reply_view.button_send.frame.origin.y = 490
            y_pozition = 460
            but_pozition = 490
        }
        else {
            reply_view.button_send.frame.origin.y = 460
            y_pozition = 430
            but_pozition = 460
        }
        
        screen_i = 1
        
        for i in 0 ..< screenName.count {
            y_pozition += 30
            let icon1 = UIButton()
            icon1.setImage(UIImage(named: "correct"), for: .normal)
            icon1.frame = CGRect(x: 20, y: y_pozition, width: 20, height: 20)
            icon1.tag = screen_i
            
            let title = UILabel()
            title.numberOfLines = 0
            title.textColor = colorBlackWhite
            title.font = UIFont.systemFont(ofSize: 16)
            title.lineBreakMode = NSLineBreakMode.byWordWrapping
            title.textAlignment = .left
            title.frame = CGRect(x: 45, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) - 90, height: 20)
            
            title.text = screenName[i]
            
            let icon2 = UIButton()
            icon2.setImage(UIImage(named: "Trash_light"), for: .normal)
            icon2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - 40, y: y_pozition, width: 20, height: 20)
            icon2.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
            icon2.tag = screen_i
            
            scrollView.addSubview(icon1)
            scrollView.addSubview(title)
            scrollView.addSubview(icon2)
            screen_i += 1
            reply_view.button_send.frame.origin.y = CGFloat(y_pozition + 40)
            scrollView.contentSize = CGSize(width: view.frame.width, height: reply_view.button_send.frame.origin.y + 50)
            scrollView.updateConstraints()
        }
        
    }
}

extension ReplyToZetViewController: ImagePickerDelegate {

    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage, name: String) {

            DispatchQueue.main.async { [self] in
                UIView.setAnimationsEnabled(false)
                y_pozition += 30
                let icon1 = UIButton()
                icon1.setImage(UIImage(named: "correct"), for: .normal)
                icon1.frame = CGRect(x: 20, y: y_pozition, width: 20, height: 20)
                icon1.tag = screen_i
                
                let title = UILabel()
                title.numberOfLines = 0
                title.textColor = colorBlackWhite
                title.font = UIFont.systemFont(ofSize: 16)
                title.lineBreakMode = NSLineBreakMode.byWordWrapping
                title.textAlignment = .left
                title.frame = CGRect(x: 45, y: y_pozition, width: Int(UIScreen.main.bounds.size.width) - 90, height: 20)
                
                
                title.text = name
                
                let icon2 = UIButton()
                icon2.setImage(UIImage(named: "Trash_light"), for: .normal)
                icon2.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - 40, y: y_pozition, width: 20, height: 20)
                icon2.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
                icon2.tag = screen_i
                
                scrollView.addSubview(icon1)
                scrollView.addSubview(title)
                scrollView.addSubview(icon2)
                screen_i += 1
                reply_view.button_send.frame.origin.y = CGFloat(y_pozition + 40)
                
                scrollView.contentSize = CGSize(width: view.frame.width, height: reply_view.button_send.frame.origin.y + 50)
                scrollView.updateConstraints()
                
                let pickedImage = image
                
                let data = image.jpegData(compressionQuality: 0.9)
  
                screenImg.append(pickedImage)
                screenshotsData.append(data!)
                screenName.append(name)
               // screenName.append(asset?.originalFilename ?? "image_\(screen_i)")
            }
       
        imagePicker.dismiss()
    }

    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}

extension UIImage {
    
    func fixedOrientation() {
        
        if imageOrientation == UIImage.Orientation.up {
        }
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        default: break
        }
        
        switch imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        default: break
        }
        
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(origin: CGPoint.zero, size: size))
        default:
            ctx.draw(self.cgImage!, in: CGRect(origin: CGPoint.zero, size: size))
            break
        }

        let cgImage: CGImage = ctx.makeImage()!

        //return UIImage(cgImage: cgImage)
    }
}

extension PHAsset {
    var originalFilename: String? {
        var fileName: String?

        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.last {
                fileName = resource.originalFilename
            }
        }

        if fileName == nil {
            /// This is an undocumented workaround that works as of iOS 9.1
            fileName = self.value(forKey: "filename") as? String
        }

        return fileName
    }
}
