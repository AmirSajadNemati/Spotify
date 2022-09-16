//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 8/21/22.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album: Album
    
    private var viewModels = [AlbumTrackCollectionCellViewModel]()

    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                    collectionViewLayout: UICollectionViewCompositionalLayout(
                                                                        sectionProvider: { sectionIndex, _ -> NSCollectionLayoutSection? in
        return  AlbumViewController.createSectionLayout(section: sectionIndex)
    }))
    
    // MARK : - Init
    
    init(album: Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.register(AlbumTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.register(PlayListHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumTrackCollectionCellViewModel(
                            artistName: $0.artists.first?.name ?? "",
                            trackName: $0.name)
                    }
                    )
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    

    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        // Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 1,
                                                     leading: 2,
                                                     bottom: 1,
                                                     trailing: 2)
        // Group
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            ),
            subitem: item,
            count: 1
        )
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        return section
        
    }
    
}



extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureViewModel(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? PlayListHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
                  return UICollectionReusableView()
              }
        let headerViewModel = PlayListHeaderViewViewModel(
            name: album.name,
            ownerName: album.artists.first?.name ?? "",
            description: "Release Date : \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? "")
        )
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // play song
    }
}

extension AlbumViewController: PlayListHeaderCollectionReusableViewDelegate {
    func PlayListHeaderCollectionReusableViewDidTapPlayAll(_ header: PlayListHeaderCollectionReusableView) {
        // start playlist in  queue

    }
}

