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
    
    var imagePicker = UIImagePickerController()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivityIndicator(uiView: self.view)
        view.backgroundColor = contentColor
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
        reply_view.text_message.text = ""
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
        reply_view = ReplyToZetView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 896))
         
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
      
        reply_view.text_message.delegate = self
        
        scrollView.frame = CGRect(x: 0, y: 60 + (topPadding ?? 0), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - (ContainerViewController().tabBar.frame.size.height + 60 + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
    }
    
    func setupViewData() {
        
        reply_view.type_message.text = feedback_data[0][2]
        reply_view.email.text = feedback_data[0][1]
        
        reply_view.type_message.didSelect { [self] (selectedText, index, id) in
            typeMessageChoosed = selectedText
            emailChoosed = feedback_data[index][1]
            typeMessageChoosedID = index
            
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
                    self.requestAnswer(status: false, message: error.localizedDescription)
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
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
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
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 330)
        view.layer.cornerRadius = 20
        
        view.name.text = defaultLocalizer.stringForKey(key: "Feedback")
        view.name_content.text = "\(defaultLocalizer.stringForKey(key: "Connect_service"))?"
        view.ok.setTitle(defaultLocalizer.stringForKey(key: "Sent"), for: .normal)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(okClickDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func requestAnswer(status: Bool, message: String) {
        
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
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
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 330)
        view.layer.cornerRadius = 20
        if status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "Your message successfully was sent")
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "Something went wrong")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        //alert.view.sendSubviewToBack(view)
        hideActivityIndicator(uiView: self.view)
        present(alert, animated: true, completion: nil)

        
    }
    
    @objc func dismissDialog(_ sender: UIButton) {
        print("hello")
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }
    
    @objc func okClickDialog(_ sender: UIButton) {
        
        sender.showAnimation {
            self.alert.dismiss(animated: true, completion: nil)
        }
        showActivityIndicator(uiView: view)
        
        let parametrs: [String: Any] = ["feedBackId": typeMessageChoosedID, "feedBackMessage":  String(reply_view.text_message.text!)]
        
        print(typeMessageChoosedID)
        print(screenImg[0])
        var mediaImages = [Media]()
        
        for i in 0 ..< screenImg.count {
           // guard let mediaImage = Media(withImage: screenImg[i], forKey: "file") else {return}
            mediaImages.append(Media(withImage: screenImg[i], forKey: "file")!)
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
                    print("kkkkkkkkk")
                    DispatchQueue.main.async { [self] in
                        requestAnswer(status: false, message: error.localizedDescription)
                        print(error.localizedDescription)
                        
                    }
                },
                onCompleted: { [self] in
                    print("")
                   print("Completed event.")
                    
                }).disposed(by: disposeBag)
              }
              catch{
            }
    }
    
    @objc func choosedScreenshot() {
        let alert = UIAlertController(title: "Выбрать фото из: ", message: "", preferredStyle: .alert)
        
        let gallery = UIAlertAction(title: "Галереи", style:.default){ [self] (action) in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)){
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                //present(self.imagePicker, animated: true, completion: nil)
                present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let camera = UIAlertAction(title: "Снять фото", style:.default){ [self] (action) in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                //present(imagePicker, animated: true, completion: nil)
                present(imagePicker, animated: true, completion: nil)
                
            } else{
                let alert2 = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                alert2.addAction(ok)
                //present(alert2, animated: true, completion: nil)
                present(alert2, animated: true, completion: nil)
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style:.default){ (action) in
            alert.dismiss(animated: false, completion: nil)
        }
        
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        if screenName.count < 5 {
            present(alert, animated: true, completion: nil)
        }
        else {
            
        }
      }
      
      func didSendScreen() {
          //emailAddress = cell.e_mail.text!
          //sendScreenToServer()
      }
      
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
          if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
              let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
              let asset = result.firstObject
              print(asset?.value(forKey: "filename"))
         
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
                  
                  title.text = asset?.value(forKey: "filename") as? String
                  
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
                  
                  let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                  pickedImage!.fixedOrientation()
            
                  let data = pickedImage!.jpegData(compressionQuality: 0.9)
    
                  screenImg.append(pickedImage!)
                  screenshotsData.append(data!)
                  screenName.append(asset?.value(forKey: "filename") as! String)
                }
              }
          
          dismiss(animated: true, completion: nil)
      }
      
      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         // dismiss(animated: true, completion: nil)
          dismiss(animated: true, completion: nil)
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
        
        reply_view.button_send.frame.origin.y = 460
        y_pozition = 430
        but_pozition = 460
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
