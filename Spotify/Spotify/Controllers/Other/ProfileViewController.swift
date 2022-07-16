//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK : - SubViews
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return  tableView
    }()
    
    var models = [String]()
    // MARK : - Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        fetchProfile()
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
   
    // MARK : - Functions
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    
                    
                case .failure(let error):
                    self?.failedToGetProfile()
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        models.append("Full Name : \(model.display_name)")
        models.append("Email : \(model.email)")
        models.append("User ID : \(model.id)")
        models.append("Plan : \(model.product)")
        createTableHeader(with: model.images.first?.url )
        tableView.reloadData()
        
    }
    
    private func createTableHeader(with string: String?){
        guard let urlString = string, let url = URL(string: urlString) else {
            print("Image url failed")
            return
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/3))
        let imageSize : CGFloat = headerView.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        imageView.sd_setImage(with: url, completed: nil)
        
        tableView.tableHeaderView = headerView
    }

    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed To Load Profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        label.center = view.center
        view.addSubview(label)
        
        
    }
    
    // MARK : - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
