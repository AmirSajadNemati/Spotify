//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 9/18/22.
//

import UIKit

import SafariServices

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func showResults(_ controller: UIViewController)
}
	
class SearchResultsViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var sections: [SearchSection] = []
    
    weak var delegate : SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        //tableView.isHidden = true
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .clear
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func update(with results: [SearchResult]){
        
//        self.sections = results
        tableView.reloadData()
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Tracks", results: tracks)]
    }
    
    
    // MARK : - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
            // Artists Cell
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identifier,
                for: indexPath) as? SearchResultDefaultTableViewCell else {
                    return UITableViewCell()
                }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: artist.name,
                imageURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
            // Playlists Cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
                }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
            // Albums Cell
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
                }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "",
                imageURL: URL(string: album.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
            
            // Tracks Cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
                }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "",
                imageURL: URL(string: track.album?.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        case .artist(let model):
           
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
            delegate?.showResults(vc)
        case .album(let model):
            let vc = AlbumViewController(album: model)
            delegate?.showResults(vc)
        case .track(let model):
            PlaybackPresenter.shared.startPlayback(from: self, track: model)
        }
        
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
  

}

  
    



