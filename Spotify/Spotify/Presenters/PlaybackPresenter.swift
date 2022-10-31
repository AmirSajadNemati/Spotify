//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 10/7/22.
//

import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject{
    
    var songName: String? {get}
    var subtitle: String? {get}
    var imageURL: URL? {get}
    
}

final class PlaybackPresenter: PlayerDataSource {
    
    static let shared = PlaybackPresenter()
    
    var singlePlayer: AVPlayer?
    var queuePlayer: AVQueuePlayer?
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    
    var playerVC: PlayerViewController?
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let player = self.queuePlayer,  !tracks.isEmpty {
            return tracks[index]
        }
        
        return  nil
    }
    
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack) {
            let vc = PlayerViewController()
            self.track = track
            self.tracks = []
            vc.title = track.name
            vc.dataSource = self
            vc.delegate = self
            
            guard let url = URL(string: track.preview_url ?? "") else {
                return
            }
            
            singlePlayer = AVPlayer(url: url)
            singlePlayer?.volume = 0.5
            viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
                self?.singlePlayer?.play()
            }
            self.playerVC = vc
            
            
        }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]) {
            self.tracks = tracks
            self.track = nil
            
            self.queuePlayer = AVQueuePlayer(items: tracks.compactMap({
                guard let url = URL(string: $0.preview_url ?? " ") else {
                    return nil
                }
                return AVPlayerItem(url: url)
            }))
            
            self.queuePlayer?.volume = 50
            self.queuePlayer?.play()
            
            let vc = PlayerViewController()
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
            
            self.playerVC = vc
        }
    
    
    // DataSource Methods
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate{
    
    func didSlideSlider(_ value: Float) {
        singlePlayer?.volume = value
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            singlePlayer?.pause()
        }
        else if let player = queuePlayer {
            self.queuePlayer?.advanceToNextItem()
            index += 1
            print(index)
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            singlePlayer?.pause()
            singlePlayer?.play()
        }
        else if let firstItem = queuePlayer?.items().first {
            queuePlayer?.pause()
            queuePlayer?.removeAllItems()
            queuePlayer = AVQueuePlayer(items: [firstItem])
            queuePlayer?.volume = 50
            queuePlayer?.play()
        }
    }
    
    func didTapPlayPause() {
        if let player = singlePlayer {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
            
        }
        else if let player = queuePlayer {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    
}


