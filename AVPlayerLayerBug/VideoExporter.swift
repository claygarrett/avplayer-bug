//
//  VideoExporter.swift
//  AVPlayerLayerBug
//
//  Created by Clay Garrett on 10/28/16.
//  Copyright © 2016 Meograph. All rights reserved.
//

import UIKit
import AVFoundation

class VideoExporter: NSObject {

    var parentLayer: CALayer?
    var imageLayer: CALayer?
    let videoUrl: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "sorry", ofType: "mov")!)
    
    func export() {
        
        // remove existing export file if it exists
        let baseDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let exportUrl = (baseDirectory.appendingPathComponent("export.mov", isDirectory: false) as NSURL).filePathURL!
        deleteExistingFile(url: exportUrl)
        
        // init variables
        let videoAsset: AVAsset = AVAsset(url: videoUrl) as AVAsset
        let tracks = videoAsset.tracks(withMediaType: AVMediaTypeVideo)
        let videoAssetTrack = tracks.first!
        let videoLayer = CALayer()
        let parentLayer = CALayer()
        let exportSize: CGFloat = 320
        
        // set frame sizes
        videoLayer.frame = CGRect(x: 0, y: 0, width: exportSize, height: exportSize)
        parentLayer.frame = CGRect(x: 0, y: 0, width: exportSize, height: exportSize)
        parentLayer.addSublayer(videoLayer)
        
        // build video composition
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: exportSize, height: exportSize)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        // build instructions
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoAssetTrack)
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]
        
        
        /// add animation tool:
        /// **************************
        /// this line triggers the bug.
        /// **************************
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in:parentLayer)
        
        // create exporter and export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter!.videoComposition = videoComposition
        exporter!.outputURL = exportUrl
        exporter!.outputFileType = AVFileTypeQuickTimeMovie
        exporter!.shouldOptimizeForNetworkUse = true
        exporter!.exportAsynchronously(completionHandler: { () -> Void in
            switch exporter!.status {
            case .completed:
                print("Done!")
                break
            case .failed:
                print("Failed! \(exporter!.error)")
            default:
                break
            }
        })
    }
    
    func deleteExistingFile(url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
        }
        catch let _ as NSError {
            
        }
    }
}
