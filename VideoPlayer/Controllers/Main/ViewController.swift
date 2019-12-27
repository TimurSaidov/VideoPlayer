//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Timur Saidov on 17/03/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    let videos: [Video] = Video.allVideos()
    let videoPreviewLooper = VideoLooperView(videos: Video.allVideos()) // Черный прямоугоник внизу экрана.

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(videoPreviewLooper)
        setupCollectionView()
        
        videoPreviewLooper.frame = CGRect(x: view.bounds.width - 150 - 16, y: view.bounds.height - 200, width: 150, height: 100)
        videoPreviewLooper.backgroundColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoPreviewLooper.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPreviewLooper.pause()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        
        // Величины отступов и размеров ячеек в Collection View.
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = Constants.galleryMinimumInteritemSpacing
        collectionView.contentInset = UIEdgeInsets(top: Constants.topDistanceToView, left: Constants.leftDistanceToView, bottom: Constants.bottomDistanceToView, right: Constants.rightDistanceToView)
        layout.itemSize = CGSize(width: Constants.galleryItemWidth , height: Constants.galleryItemHeight)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        cell.video = videos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        let videoURL = video.url
        let player = AVPlayer(url: videoURL) // Объект, который управляет видеофайлом, передающимся по ссылке. Таким образом, AVPlayer - проигрыватель с объектом AVPlayerItem, который используется для моделирования времени и состояния видеофайла (Объект/модель, которого AVPlayer использует для произведения видеофайлов), переданного по URL-ссылке. AVPlayer.init(playerItem item: AVPlayerItem?)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}
