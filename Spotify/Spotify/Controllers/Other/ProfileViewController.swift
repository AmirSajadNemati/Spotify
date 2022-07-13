//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        navigationItem.largeTitleDisplayMode = .always
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                print("profile called successfully")
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    


}
