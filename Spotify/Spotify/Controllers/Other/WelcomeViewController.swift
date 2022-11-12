//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitle("Sign in with spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "background_image"))
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on the go."
        return label
    }()
    
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "welcome_logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(logoImageView)
        view.addSubview(label)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 50,
            height: 50)
        
        backgroundImageView.frame = view.bounds
        
        overlayView.frame = view.bounds
        
        logoImageView.frame = CGRect(x: (view.width - 120) / 2,
                                     y: (view.height - 300) / 2,
                                     width: 120,
                                     height: 120)
        label.frame = CGRect(x: 30,
                             y: logoImageView.bottom + 30,
                             width: view.width - 60,
                             height: 150)
        
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    private func handleSignIn(success: Bool) {
        // log user in or show errors
        guard success else{
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel,
                                          handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVc = TabBarViewController()
        mainAppTabBarVc.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVc, animated: true)
    }

    

}
