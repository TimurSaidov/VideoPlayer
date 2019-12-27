//
//  VideoLooperView.swift
//  VideoPlayer
//
//  Created by Timur Saidov on 17/03/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit
import AVFoundation

class VideoLooperView: UIView {
    
    var videos: [Video]
    let videoPlayerView = VideoPlayerView()
    
    @objc private let queuePlayer = AVQueuePlayer() // Объект/проигрыватель, запускающий одно видео за другим. То есть AVQueuePlayer - проигрыватель, использующий последовательность видео, а именно массив AVPlayerItem'ов, которые используется для моделирования времени и состояния конкретного, своего видеофайла. AVQueuePlayer.init(items: [AVPlayerItem]). @objc - подвергается объектам из Obj-C, как KVO.
    
    private var token: NSKeyValueObservation?
    
    init(videos: [Video]) {
        self.videos = videos
        
        super.init(frame: .zero)
        
        initilizePlayer()
        addGestureRecognizers()
    }
    
    // Для отображения VideoPlayerView(). Задатчик размеров View.
    override func layoutSubviews() {
        addSubview(videoPlayerView)
        videoPlayerView.frame = bounds
    }
    
    private func initilizePlayer() {
        videoPlayerView.player = queuePlayer
        addAllVideosToPlayer()
        
        queuePlayer.volume = 0.0
        queuePlayer.play()
        
        token = queuePlayer.observe(\.currentItem, changeHandler: { [weak self] (player, _) in
            guard let self = self else { return }
            if self.queuePlayer.items().count == 1 {
                self.addAllVideosToPlayer()
            }
        })
    }
    
    func pause() {
        queuePlayer.pause()
    }
    
    func play() {
        queuePlayer.play()
    }
    
    private func addGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(wasTapped))
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(wasDoubleTapped))
        
//        tap.require(toFail: doubleTap)
        
        addGestureRecognizer(tap)
//        addGestureRecognizer(doubleTap)
    }
    
    @objc func wasTapped() {
        print(#function)
        queuePlayer.volume = queuePlayer.volume == 0.0 ? 1.0 : 0.0
    }
    
//    @objc func wasDoubleTapped() {
//        print(#function)
//        queuePlayer.rate = queuePlayer.rate == 1.0 ? 2.0 : 1.0
//    }
    
    private func addAllVideosToPlayer() {
        for video in videos {
            let asset = AVURLAsset(url: video.url) // Объект клипа (представление видеофайла), переданного по URL-ссылке.
            let item = AVPlayerItem(asset: asset) // Объект/модель видеофайла (обертка AVAsset), чтобы Player мог воспроизводить клипов. AVQueuePlayer.init(items: [AVPlayerItem])
            
            queuePlayer.insert(item, after: queuePlayer.items().last)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
