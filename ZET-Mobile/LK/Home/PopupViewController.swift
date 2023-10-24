//
//  PopupViewController.swift
//  ZET-Mobile
//
//  Created by iDev on 18/09/23.
//
import UIKit

class PopupViewController: UIViewController {
    private let popupImageView = UIImageView()
    private let closeButton = UIButton()
     let nextButton = UIButton()
    let view_button = UIView()

    private let imageURL: URL

    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadImageFromURL()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

       // popupImageView.contentMode = .scaleAspectFit
        view.addSubview(popupImageView)

        //closeButton.setTitle("\(defaultLocalizer.stringForKey(key: "Close"))", for: .normal)
       // closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
       // closeButton.setTitleColor(darkGrayLight, for: .normal) // Изменение цвета текста кнопки (в данном случае на красный)
            closeButton.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
     //   closeButton.frame = CGre
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        //nextButton.setTitle("Next", for: .normal)
        nextButton.frame = CGRect(x:0, y: 0, width: Int(UIScreen.main.bounds.size.width) - 40 , height: 45)
        nextButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        nextButton.setTitle("\(defaultLocalizer.stringForKey(key: "Participate"))", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
      
        let screenSize = UIScreen.main.bounds.size

        let centerX = screenSize.width / 2
        let centerY = screenSize.height / 2

       
        
        view_button.backgroundColor = .clear
        view_button.addSubview(nextButton)
        popupImageView.frame = CGRect(x: 20, y: 70, width: Int(UIScreen.main.bounds.width) - 40, height: 520)
        nextButton.addTarget(self, action: #selector(openMyTicket), for: .touchUpInside)
        view_button.frame = CGRect(x: 20 , y: Int(popupImageView.frame.maxY) + 20, width: Int(UIScreen.main.bounds.size.width), height: 60)
        view_button.isHidden = false
        view.addSubview(view_button)

       // popupImageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
       // view_button.translatesAutoresizingMaskIntoConstraints = false
        //nextButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            //popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            //popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            //popupImageView.widthAnchor.constraint(equalToConstant: 200),
//            //popupImageView.heightAnchor.constraint(equalToConstant: 200),
//            popupImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            popupImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            popupImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -100),
//            popupImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
//
            closeButton.trailingAnchor.constraint(equalTo: popupImageView.trailingAnchor, constant: -15),
            closeButton.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 15),
//
//          //  view_button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          //  view_button.topAnchor.constraint(equalTo: Uiscre, constant: 80)
//
        ])
    }
    
    

    private func loadImageFromURL() {
        URLSession.shared.dataTask(with: imageURL) { [weak self] (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.popupImageView.image = image
                }
            }
        }.resume()
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func nextButtonTapped() {
        print("НАЖАЛ")
        let nextViewController = CompetitionViewController()
               navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func openMyTicket(_ sender: UIButton){
        print("НАЖАЛоооооооо")

        sender.showAnimation { [self] in

            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(MyTicketViewController(), animated: true)
        }    }
}
