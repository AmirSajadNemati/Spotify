//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 10/28/22.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {


    // MARK : - Properties
 
    private let noAlbumsView = ActionLabelView()
        
    private var albums = [Album]()
    
    private var observer: NSObjectProtocol?
    
    private var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    // MARK : - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        setUpNoAlbumsLabelView()
        fetchdata()
        
        observer = NotificationCenter.default.addObserver(
            forName: .savedAlbumNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchdata()
            })
        
        
       
        
    }
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width - 150) / 2,
                                    y: (view.height - 150) / 2,
                                    width: 150,
                                    height: 150)
        
        
        tableView.frame = view.bounds
        
    }
    
    private func updateUI(){
        if albums.isEmpty {
            noAlbumsView.isHidden = false
            
        } else {
            // show tabel
            noAlbumsView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func setUpNoAlbumsLabelView(){
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        
        noAlbumsView.configure(with: ActionLabelViewViewModel(
                text: "No Albums Yet!",
                actionTitle: "Browse"))

    }
    
    private func fetchdata(){
        albums.removeAll()
        APICaller.shared.getCurentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
   
}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func ActionLabelViewDidTapButton(_ actionViewLabel: ActionLabelView) {
        tabBarController?.selectedIndex = 0	
        
    }
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
            title: album.name,
            subtitle: album.artists.first?.name ?? "",
            imageURL: URL(string: album.images.first?.url ?? ""))
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = albums[indexPath.row]
        
        let vc = AlbumViewController(album: album)
        vc.title = album.name
        vc.view.backgroundColor = .systemBackground
        vc.navigationItem.largeTitleDisplayMode = .never
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
