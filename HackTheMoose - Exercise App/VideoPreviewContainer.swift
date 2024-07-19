//
//  VideoPreviewLayer.swift
//  HackTheMoose - Exercise App
//
//  Created by Kevin Tun on 7/16/24.
//
import UIKit
import SwiftUI
import AVFoundation
import Foundation

//uiview class of the avcapturevideopreviewlayer
class VideoPreviewUIView: UIView {
    // Use a capture video preview layer as the view's backing layer.
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
    // Connect the layer to a capture session.
    func setSession(_ session: AVCaptureSession) {
        // Connects the session with the preview layer, which allows the layer
        // to provide a live view of the captured content.
        previewLayer.session = session
        
        //allows video to go into safe zone
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
       }
}

//swift view to see a video preview of the capture session, container for avcapturevideopreviewlayer
struct VideoPreviewSwiftView: UIViewRepresentable {
    
    private let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
            self.session = session
        }
    
    init() {
        self.session = AVCaptureManager.shared.captureSession
        }
    
    func makeUIView(context: Context) -> VideoPreviewUIView {
        let view = VideoPreviewUIView(frame: .zero)
        view.setSession(session)
        
        //starts capture when makingUIView
        DispatchQueue.global(qos: .userInitiated).async {
            AVCaptureManager.shared.startCapture()
            
            DispatchQueue.main.async {
                
            }
        }
        
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewUIView, context: Context) {
        
    }
    
    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator) {
        // Perform any cleanup necessary before the view is discarded
           
        AVCaptureManager.shared.endCapture()
        print("Ending capture session and dismantling VideoPreviewSwiftUI")
        }

}
