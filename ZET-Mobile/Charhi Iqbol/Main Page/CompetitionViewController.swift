//
//  CompetitionViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/12/22.
//

import UIKit
import RxCocoa
import RxSwift

var apiData = [[String]]()

class CompetitionViewController: UIViewController, UIScrollViewDelegate {
    var bannerUrl = ""
    var presentDescription = ""
    var presentTitle = ""
    var present = ""

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    let disposeBag = DisposeBag()
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    let detailViewController = MoreDetailViewController()
    
    var nav = UINavigationController()
    var alert = UIAlertController()
    let imagee = UIImageView()
   
    let scrollView = UIScrollView()
    
    var toolbar = TarifToolbarView()
    var competitionView = CompetitionView()
    let table = UITableView()
    
    var prizeImageData = [String]()
    var prizeImageText = [String]()
    var tableData = [String]()
    

    let CollectionPrizeView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CollectionPrizeViewCell.self, forCellWithReuseIdentifier: cellID3)
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = contentColor
                toolbar = TarifToolbarView(frame: CGRect(x: 0, y: topPadding ?? 0, width: UIScreen.main.bounds.size.width, height: 60))
        self.view.addSubview(toolbar)
            sendRequest()
        toolbar.icon_back.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        toolbar.isUserInteractionEnabled = true
        toolbar.addGestureRecognizer(tapGestureRecognizer)
        toolbar.number_user_name.text = defaultLocalizer.stringForKey(key: "Charkhi Ikbol")
        
        tableData.append("\(defaultLocalizer.stringForKey(key: "MyTickets"))")
        tableData.append("\(defaultLocalizer.stringForKey(key: "BuyTickets"))")
        tableData.append("\(defaultLocalizer.stringForKey(key: "DrawTerms"))")
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightContent : .darkContent)
    }
    
    
    @objc func goBack() {
        if let destinationViewController = navigationController?.viewControllers
                                                                .filter(
                                              {$0 is HomeViewController})
                                                                .first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }

    
    func sendRequest()
    {
        bannerUrl.removeAll()
        let client = APIClient.shared
            do{
                try client.charhiIqbolMain().subscribe(
                onNext: { [weak self] result in
                    DispatchQueue.main.async {
                        self!.bannerUrl = result.bannerURL
                        self!.presentDescription = result.presentDescription
                        self!.presentTitle = result.presentTitle
                        self!.present = result.present
                        

                        for i in 0 ..< result.images.count {
                            self!.prizeImageData.append(result.images[i].imageURL)
                            self!.prizeImageText.append(result.images[i].name)
                        }
                        
                    }

                },
                onError: {
                    error in
                     DispatchQueue.main.async { [self] in
                         print(error)

                         setupView()
                         setupCollectionPrizeSection()
                         setupTableView()
                         self.requestAnswer(status: false, message: self.defaultLocalizer.stringForKey(key: "service is temporarily unavailable"))
                         self.hideActivityIndicator(uiView: self.view)
                     }
                },
                onCompleted: {DispatchQueue
                    
                    .main
                    .async { [self] in
                        setupView()
                        setupCollectionPrizeSection()
                        setupTableView()
                    }
                }).disposed(by: disposeBag)

              }
              catch{
            }
    }
    
    func setupView() {
        view.backgroundColor = toolbarColor
        
                
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = contentColor
        scrollView.addSubview(competitionView.view_button)
        scrollView.addSubview(competitionView.view_prize)
       
        

             //competitionView = CompetitionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + toolbar.frame.height))
        competitionView.sendButton.addTarget(self, action: #selector(openBuyTickets), for: .touchUpInside)
        scrollView.addSubview(competitionView)
        scrollView.frame = CGRect(x: 0, y: toolbar.frame.maxY, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - toolbar.frame.height)//- (ContainerViewController().tabBar.frame.size.height  + (topPadding ?? 0) + (bottomPadding ?? 0)))
       // scrollView.frame = CGRect(x: 0, y: toolbar.frame.maxY, width: UIScreen.main.bounds.size.width, height: 667   )//- (ContainerViewController().tabBar.frame.size.height  + (topPadding ?? 0) + (bottomPadding ?? 0)))
        
        
        // Устанавливаем высоту scrollView.contentSize равной высоте содержимого
        scrollView.contentSize = CGSize(width: view.frame.width, height: 640 + 42)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    @objc func requestAnswer(status: Bool, message: String) {
        alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
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
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 350)
        view.layer.cornerRadius = 20
        if  status == true {
            view.name.text = defaultLocalizer.stringForKey(key: "service_connected")
            view.image_icon.image = UIImage(named: "correct_alert")
        }
        else {
            view.name.text = defaultLocalizer.stringForKey(key: "error_title")
            view.image_icon.image = UIImage(named: "uncorrect_alert")
        }
        
        view.name_content.text = "\(message)"
        view.ok.setTitle("OK", for: .normal)
        
        view.cancel.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        view.ok.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        alert.view.backgroundColor = .clear
        alert.view.addSubview(view)
        present(alert, animated: true, completion: nil)

        
    }

    
    @objc func dismissDialog(_ sender: UIButton) {
        sender.showAnimation { [self] in
            alert.dismiss(animated: true, completion: nil)
            hideActivityIndicator(uiView: view)
        }
    }

    
    func setupCollectionPrizeSection() {
        scrollView.addSubview(CollectionPrizeView)
        CollectionPrizeView.frame = CGRect(x: 0, y: competitionView.image_banner.bounds.maxY+5, width: UIScreen.main.bounds.size.width, height: 120)
        CollectionPrizeView.backgroundColor = .clear
        CollectionPrizeView.delegate = self
        CollectionPrizeView.dataSource = self
    }
    

    
    func setupTableView() {
        scrollView.addSubview(table)
    
        table.frame = CGRect(x: 0, y: 310, width: Int(UIScreen.main.bounds.size.width), height: 210)
        
        table.register(ListTableViewCell.self, forCellReuseIdentifier: "list_cell")
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.backgroundColor = .white
        table.separatorColor = .lightGray
        
        table.rowHeight = 70
        table.estimatedRowHeight = 70
        table.alwaysBounceVertical = false
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
      }
}





extension CompetitionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let text = tableData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "list_cell", for: indexPath) as! ListTableViewCell
        
        
        let bgColorView = UIView()
        
        cell.backgroundColor = contentColor
        cell.selectedBackgroundView = bgColorView
        cell.titleOne.text = text
        cell.button.isUserInteractionEnabled = true
        cell.button.tag = indexPath.row
        if indexPath.row == 0 {
            cell.button.addTarget(self, action: #selector(openMyTicket), for: .touchUpInside)
        } else if  indexPath.row == 2{
            cell.button.addTarget(self, action: #selector(openFAQ), for: .touchUpInside)
            
        } else if indexPath.row == 1{
            cell.button.addTarget(self, action: #selector(openBuyTickets), for: .touchUpInside)

        }
            return cell
        
  }
    
    @objc func openMyTicket(_ sender: UIButton){
        sender.showAnimation { [self] in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(MyTicketViewController(), animated: true)
        }    }
    
    @objc func openFAQ(_ sender: UIButton){
        sender.showAnimation { [self] in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(FAQViewController(), animated: true)
        }    }
    
    @objc func openBuyTickets(_ sender: UIButton){
        sender.showAnimation { [self] in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(BuyTicketsViewController(), animated: true)
        }    }
    
    
    @objc func dismiss_view() {
        nav.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func openMore(_ sender: UIButton){
      //  imagee.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Frame 150 1") : UIImage(named: "zet 1-2"))
        
       // let imageView = UIImageView(image: UIImage(named: "your_image_name"))
         //  imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
      //  detailViewController.more_view.image.isHidden = false
        detailViewController.more_view.isUserInteractionEnabled = false
        detailViewController.more_view.title_top.frame.size.height = 50
        detailViewController.more_view.title_top.numberOfLines = 2
        detailViewController.more_view.content.text = presentDescription
        detailViewController.more_view.content.textColor = darkGrayLight
       // detailViewController.more_view.content.frame = CGRect(x: 20, y: -50, width: UIScreen.main.bounds.size.width - 40, height: 700)
        detailViewController.more_view.content.translatesAutoresizingMaskIntoConstraints = false
        //detailViewController.more_view.title_top.addSubview(imageView)
        detailViewController.more_view.title.isHidden  = true
        detailViewController.more_view.title_top.text = defaultLocalizer.stringForKey(key: "DRAW_TERMS")

        NSLayoutConstraint.activate([detailViewController.more_view.content.topAnchor.constraint(equalTo: detailViewController.more_view.title_top.bottomAnchor, constant: -5),
                                     detailViewController.more_view.content.leadingAnchor.constraint(equalTo: detailViewController.more_view.leadingAnchor, constant: 20),
                                     detailViewController.more_view.content.trailingAnchor.constraint(equalTo: detailViewController.more_view.trailingAnchor, constant: -20),
                                     detailViewController.more_view.content.bottomAnchor.constraint(equalTo: detailViewController.more_view.close_banner.topAnchor )])
        
        
        
        nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .pageSheet
        nav.view.backgroundColor = contentColor
        nav.isNavigationBarHidden = true
        detailViewController.view.backgroundColor = colorGrayWhite
        detailViewController.scrollView.addSubview(detailViewController.more_view.close_banner)
        detailViewController.scrollView.addSubview(detailViewController.more_view.close)
        detailViewController.more_view.close_banner.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)
        detailViewController.more_view.close.addTarget(self, action: #selector(dismiss_view), for: .touchUpInside)

        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        }

        present(nav, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}

@available(iOS 15.0, *)
extension CompetitionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prizeImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID3, for: indexPath) as! CollectionPrizeViewCell
                
        competitionView.image_banner.af_setImage(withURL: URL(string: self.bannerUrl)!)
        competitionView.titleOne.text = presentTitle
        competitionView.titleTwo.text = present
        
        competitionView.prizeButton.isUserInteractionEnabled = true
        competitionView.prizeButton.addTarget(self, action: #selector(openMore), for: .touchUpInside)
        let text = prizeImageText[indexPath.row]
        
        cell.image.af_setImage(withURL: URL(string: self.prizeImageData[indexPath.row])!)
        cell.label.text = text
        return cell
        }
}
