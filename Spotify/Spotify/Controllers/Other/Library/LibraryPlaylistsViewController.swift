//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 10/28/22.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    // MARK : - Properties
    
    private let noplaylitsView = ActionLabelView()
    
    private var playlists = [PlayList]()
    
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
        
        setUoNoPlaylistLabelView()
        fetchdata()
       
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noplaylitsView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: 150,
                                      height: 150)
        noplaylitsView.center = view.center
        
        tableView.frame = view.bounds
        
    }
    
    private func updateUI(){
        if playlists.isEmpty {
            noplaylitsView.isHidden = false
            
        } else {
            // show tabel
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func setUoNoPlaylistLabelView(){
        view.addSubview(noplaylitsView)
        noplaylitsView.delegate = self
        noplaylitsView.configure(with: ActionLabelViewViewModel(
                text: "No playlists yet!",
                actionTitle: "Create"))

    }
    
    private func fetchdata(){
        
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
   
    public func createNewPlaylistAlert(){
        let alert = UIAlertController(title: "New Playlist",
                                      message: "Enter Playlist Name",
                                      preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Create",
                                      style: .default,
                                      handler: { _ in
            guard let textField = alert.textFields?.first,
                  let text = textField.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                      return
                  }
            DispatchQueue.main.async {
                APICaller.shared.createPlaylist(name: text) { [weak  self] success in
                    if success {
                        // refresh list of playlists
                        self?.fetchdata()
                    } else {
                        print("Failed to create playlist!")
                    }
                }
            }
        }))
        present(alert, animated:  true)
    }
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func ActionLabelViewDidTapButton(_ actionViewLabel: ActionLabelView) {
        //show creation UI
        createNewPlaylistAlert()
    }
}

extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
            title: playlist.name,
            subtitle: playlist.owner.display_name,
            imageURL: URL(string: playlist.images.first?.url ?? ""))
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        vc.title = playlist.name
        vc.view.backgroundColor = .systemBackground
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
