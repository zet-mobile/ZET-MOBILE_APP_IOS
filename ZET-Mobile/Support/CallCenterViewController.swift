//
//  CallCenterViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit
import YandexMapKit
import RxSwift
import RxCocoa

var officesdata = [[String]]()
var supportdata = [[String]]()

class CallCenterViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var halfModalTransitioningDelegate: HalfModalTransitioningTwoDelegate?
    
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var support_view = SupportView()
    let table = UITableView()
    
    let SupportCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SupportCollectionViewCell.self, forCellWithReuseIdentifier: "SupportCollectionCell")
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    var x_pozition = 25
    var long = ""
    var lat = ""
    var mapView = YMKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = toolbarColor
        setupView()
        
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
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor
  
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 850)
        view.addSubview(scrollView)
        
        toolbar = TarifToolbarView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: 60))
        support_view = SupportView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapClick))
        support_view.title1.isUserInteractionEnabled = true
        support_view.title1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(listClick))
        support_view.title2.isUserInteractionEnabled = true
        support_view.title2.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(mapClick))
        support_view.icon1.isUserInteractionEnabled = true
        support_view.icon1.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(listClick))
        support_view.icon2.isUserInteractionEnabled = true
        support_view.icon2.addGestureRecognizer(tapGestureRecognizer4)
        
        mapView = YMKMapView(frame: CGRect(x: 0, y: 220, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        self.view.addSubview(toolbar)
        scrollView.addSubview(support_view)
        scrollView.addSubview(mapView)
        
        setMapView()
        
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        toolbar.number_user_name.text = "Поддержка"
        
        support_view.number.text = supportdata[0][1]
        
        /* if let url = URL(string: "tel://800"), UIApplication.shared.canOpenURL(url) {
         if #available(iOS 10, *) {
             UIApplication.shared.open(url)
         } else {
             UIApplication.shared.openURL(url)
         }
     }*/
        SupportCollectionView.backgroundColor = .clear
        SupportCollectionView.frame = CGRect(x: 0, y: 80, width: Int(UIScreen.main.bounds.size.width), height: 50)
        SupportCollectionView.delegate = self
        SupportCollectionView.dataSource = self
        SupportCollectionView.alwaysBounceVertical = false
        scrollView.addSubview(SupportCollectionView)
        
        table.register(SupportListCell.self, forCellReuseIdentifier: "support_list_cell")
        table.frame = CGRect(x: 10, y: 230, width: UIScreen.main.bounds.size.width - 20, height: 7 * 80)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 80
        table.estimatedRowHeight = 80
        table.alwaysBounceVertical = false
        table.isHidden = true
        table.backgroundColor = contentColor
        support_view.white_back.isHidden = true
        scrollView.addSubview(table)
        
        scrollView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 104)
        
    }
    
    func setMapView() {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: 38.53575, longitude: 68.77905), zoom: 10, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
            cameraCallback: nil)
        
       // let myPlace = mapView.mapWindow.map.mapObjects.addPlacemark(with: YMKPoint(latitude: 38.85818, longitude: 71.24798))
       // myPlace.setIconWith(UIImage(named: "myLL.png")!)
        
        let mapObjects = self.mapView.mapWindow.map.mapObjects
        //mapObjects.clear()
        if (officesdata.count != 0) {
            var placeMark = mapObjects.addPlacemark(with: YMKPoint(latitude: Double(officesdata[0][4])!, longitude: Double(officesdata[0][5])!))
          
            placeMark.userData = officesdata[0][0] + "&" + officesdata[0][1]
            placeMark.setIconWith(UIImage(named: "Location.png")!)
            placeMark.addTapListener(with: self)
          
            for i in 1 ..< officesdata.count - 1 {
                placeMark = mapObjects.addPlacemark(with: YMKPoint(latitude: Double(officesdata[i][4])!, longitude: Double(officesdata[i][5])!))
                if ((officesdata[i][6]) == "2") {
                    placeMark.setIconWith(UIImage(named: "Location.png")!)
                }
                else {
                    placeMark.setIconWith(UIImage(named: "ecc.png")!)
                }
                placeMark.addTapListener(with: self)
                placeMark.userData = officesdata[i][0] + "&" + officesdata[i][1]
        }
      }
   }
    
    @objc func mapClick() {
        support_view.icon1.image = UIImage(named: "Pin_alt_light")
        support_view.title1.textColor = colorBlackWhite
        support_view.icon2.image = UIImage(named: "list_map")
        support_view.title2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        table.isHidden = true
        mapView.isHidden = false
        support_view.white_back.isHidden = true
    }
    
    @objc func listClick() {
        support_view.icon1.image = UIImage(named: "Pin_alt_light_gray")
        support_view.title1.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        support_view.icon2.image = UIImage(named: "list_map_orange")
        support_view.title2.textColor = colorBlackWhite
        table.isHidden = false
        mapView.isHidden = true
        support_view.white_back.isHidden = false
    }
    
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named:"UserArrow")!)
        
        let pinPlacemark = view.pin.useCompositeIcon()
        
        pinPlacemark.setIconWithName("icon",
                                     image: UIImage(named:"Icon")!,
                                     style:YMKIconStyle(
                                        anchor: CGPoint(x: 0, y: 0) as NSValue,
                                        rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                                        zIndex: 0,
                                        flat: true,
                                        visible: true,
                                        scale: 1.5,
                                        tappableArea: nil))
        
        pinPlacemark.setIconWithName(
            "pin",
            image: UIImage(named:"SearchResult")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil))
        
        view.accuracyCircle.fillColor = UIColor.blue
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}

extension CallCenterViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: collectionView.frame.width * 0.2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return supportdata.count - 1

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCollectionCell", for: indexPath) as! SupportCollectionViewCell
        cell.button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       open(scheme: supportdata[indexPath.row + 1][2])
    }
    
    @objc func buttonClick(_ sender: UIButton) {
        open(scheme: supportdata[sender.tag + 1][2])
    }
}

extension CallCenterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return officesdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "support_list_cell", for: indexPath) as! SupportListCell
            
        cell.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
        if indexPath.row == officesdata.count - 1 {
            cell.separatorInset = UIEdgeInsets.init(top: -10, left: UIScreen.main.bounds.size.width, bottom: -10, right: 0)
        
        }
        
        cell.titleOne.text = officesdata[indexPath.row][1]
        cell.titleTwo.text = officesdata[indexPath.row][0]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: Double(officesdata[indexPath.row][4])!, longitude: Double(officesdata[indexPath.row][5])!), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
            cameraCallback: nil)
        
        support_view.icon1.image = UIImage(named: "Pin_alt_light")
        support_view.title1.textColor = colorBlackWhite
        support_view.icon2.image = UIImage(named: "list_map")
        support_view.title2.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        table.isHidden = true
        mapView.isHidden = false
        support_view.white_back.isHidden = true
    }
    
}

extension CallCenterViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
       /* mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: point.latitude, longitude: point.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
            cameraCallback: nil)*/
 
        var office_choosed = mapObject.userData as? String
        var office_choosed_array = office_choosed!.components(separatedBy: "&")
        choosed_office_name = office_choosed_array[0]
        choosed_office_time = office_choosed_array[1]

        let next = DialogOfficesViewController()
        next.view.frame = (view.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        self.halfModalTransitioningDelegate = HalfModalTransitioningTwoDelegate(viewController: self, presentingViewController: next)
        next.modalPresentationStyle = .custom
        //next.modalPresentationCapturesStatusBarAppearance = true
        
        next.transitioningDelegate = self.halfModalTransitioningDelegate
        present(next, animated: true, completion: nil)
        return true
    }
    
    
}

extension Float {
    func sign() -> Int {
        return (self < Self(0) ? -1 : 1)
    }
}
