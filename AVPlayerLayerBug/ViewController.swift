//
//  ViewController.swift
//  AVPlayerLayerBug
//
//  Created by Clay Garrett on 10/28/16.
//  Copyright © 2016 Meograph. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    
    let videoUrl: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "mp4")!)
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    @IBAction func exportVideoTapped(_ sender: Any) {
        exportVideo()
    }

    @IBAction func loadPlayerTapped(_ sender: Any) {
        addPlayer()
    }
    
    func addPlayer() {
        removePlayer()
        
        playerItem = AVPlayerItem(url: videoUrl)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.frame = self.videoView.bounds
        playerLayer!.backgroundColor = UIColor.green.cgColor
        self.videoView.layer.addSublayer(playerLayer!)
        player!.play()
    }
    
    func removePlayer() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
    }
    
    func exportVideo() {
        let exporter = VideoExporter()
        exporter.export()
    }
}

