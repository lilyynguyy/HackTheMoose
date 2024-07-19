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
       }
}

struct VideoPreviewSwiftView: UIViewRepresentable {
    
    private let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
            self.session = session
        }
    
    func makeUIView(context: Context) -> VideoPreviewUIView {
        let view = VideoPreviewUIView(frame: .zero)
        view.setSession(session)
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewUIView, context: Context) {
        
    }

}
