//
//  ViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import UIKit

enum BrowseSectionType {
    case NewReleases(viewModel: [NewReleaseCellViewModel]) // 0
    case FeaturedPlaylists(viewModel: [FeaturedPlaylistViewModel]) // 1
    case RecommendedTracks(viewModel: [RecommendedTrackViewModel]) // 2
    
    var title: String {
        switch self {
        case .NewReleases:
            return "New Released Albums"
        case .FeaturedPlaylists:
            return "Featured Playlists"
        case .RecommendedTracks:
            return "Recommended"
        }
    }
}
	
class HomeViewController: UIViewController {

    // MARK : - SubViews
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                    collectionViewLayout: UICollectionViewCompositionalLayout(
                                                                        sectionProvider: { sectionIndex, _ -> NSCollectionLayoutSection? in
        return  HomeViewController.createSectionLayout(section: sectionIndex)
    }))
    
    private let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    // MARK : - Properties
    private var sections = [BrowseSectionType]()
    
    private var newAlbums: [Album] = []
    private var playLists: [PlayList] = []
    private var tracks: [AudioTrack] = []
    // MARK : - Ovveride Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done, target: self,
                                                            action: #selector(didTapSettings))
        fetchData()
        configureCollectionView()
        view.addSubview(spinner)
        
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // LongTapGesture
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress( _ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
              indexPath.section == 2 else {
                  return
              }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would you like to add this track to a playlist?",
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        actionSheet.addAction(UIAlertAction(
            title: "Add to playlist",
            style: .default,
            handler: { [weak self] _ in
                DispatchQueue.main.async {
                    let vc = LibraryPlaylistsViewController()
                    vc.selectionHandler = { playlist in
                        APICaller.shared.addTrackToPlaylist(track: model, playlist: playlist) { success in
                            print("added to playlist : \(success)")
                        }
                    }
                    vc.title = "Select PLaylist"
                    self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                }
            }))
        
        present(actionSheet, animated: true)
    }
    
    
    // MARK : - Functions
    
    private func configureCollectionView(){
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
        collectionView.register(RecommendedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
       let supplemantaryViews = [
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    ]
        switch section {
        case 0:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            // Vertical Group inside Horizontal
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplemantaryViews
            section.orthogonalScrollingBehavior = .groupPaging
            return section
            
        case 1:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            // Vertical Group inside Horizontal
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplemantaryViews
            section.orthogonalScrollingBehavior = .groupPaging
            return section
            
        case 2:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            // Group
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplemantaryViews
            return section
            
        default:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
           // Grooup
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        
    }
    
    private func fetchData(){
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleaseResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        // New Relases
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result{
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Featuerd Playlists
        APICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result{
            case .success(let model):
                featuredPlaylists = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // Recommended Tracks
        
        APICaller.shared.getRecommendedGenres { result in
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getReccomendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case  .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let tracks = recommendations?.tracks else {
                      print("Failed to Unwrap data")
                      return
                  }
            self.configureModles(newAlbums: newAlbums,
                                 playLists: playlists,
                                 tracks: tracks)
        }
        
        
    }
    
    private func configureModles(
        newAlbums: [Album],
        playLists: [PlayList],
        tracks: [AudioTrack]) {
            
            self.newAlbums = newAlbums
            self.playLists = playLists
            self.tracks = tracks

            // Configure Modles
            sections.append(.NewReleases(viewModel: newAlbums.compactMap({
                return NewReleaseCellViewModel(name: $0.name,
                                               artworkURL: URL(string: $0.images.first?.url ?? ""),
                                               numberOfTracks: $0.total_tracks,
                                               artistName: $0.artists.first?.name ?? "")
            })))
            
            sections.append(.FeaturedPlaylists(viewModel:playLists.compactMap({
                return FeaturedPlaylistViewModel(name: $0.name,
                                                 artworkURL: URL(string: $0.images.first?.url ?? ""),
                                                 creatorName: $0.owner.display_name)
            })))
            
            sections.append(.RecommendedTracks(viewModel: tracks.compactMap({
                return RecommendedTrackViewModel(artistName: $0.artists.first?.name ?? "",
                                                 trackName: $0.name,
                                                 artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
            })))
            collectionView.reloadData()
        }
    // MARK : - OBJC Functions
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .NewReleases(let viewModel):
            return viewModel.count
        case .FeaturedPlaylists(let viewModel):
            return viewModel.count
        case .RecommendedTracks(let viewModel):
            return viewModel.count
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count		
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        
        // New Release
        case .NewReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleasesCollectionViewCell.identifier,
                for: indexPath) as? NewReleasesCollectionViewCell else {
                    return UICollectionViewCell()
                }
            let viewModel = viewModels[indexPath.row]
            cell.configureViewModel(with: viewModel)
            return cell
            
        // Featured playlists
        case .FeaturedPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier,
                for: indexPath) as? FeaturedPlaylistsCollectionViewCell else {
                    return UICollectionViewCell()
                }
            let viewModel = viewModels[indexPath.row]
            cell.configureViewModel(with: viewModel)
            return cell
            
        // Recommendations
        case .RecommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
                for: indexPath) as? RecommendedTracksCollectionViewCell else {
                    return UICollectionViewCell()
                }
            let viewModel = viewModels[indexPath.row]
            cell.configureViewModel(with: viewModel)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hapticManager.shared.vibrateForSelection()
        let section = sections[indexPath.section]
        switch section {
        case .FeaturedPlaylists:
            let playlist = playLists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.view.backgroundColor = .systemBackground
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .NewReleases:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.view.backgroundColor = .systemBackground
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .RecommendedTracks:
            let index = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: index)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
                  return UICollectionReusableView()
              }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        
        return header
    }
    
   
    
    
}
