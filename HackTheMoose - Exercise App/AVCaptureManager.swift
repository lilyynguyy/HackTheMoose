//
//  AVCaptureManager.swift
//  HackTheMoose - Exercise App
//
//  Created by Kevin Tun on 7/15/24.
//

import Foundation
import AVFoundation

class AVCaptureManager{
    // Create the capture session.
    static let captureSession = AVCaptureSession()
    
    func configureCapture() -> Void {
        
        print("capture setup called")

        AVCaptureManager.captureSession.beginConfiguration()
        print("config started")
        //guard keyword for early return
        // Find the default video device.
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: AVCaptureDevice.Position.front) else { return }
        print("video device made")

        do {
            // Wrap the video device in a capture device input.
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            // If the input can be added, add it to the session.
            if AVCaptureManager.captureSession.canAddInput(videoInput) {
                AVCaptureManager.captureSession.addInput(videoInput)
                print("video input added")
            }
        } catch {
            // Configuration failed. Handle error.
            print("error adding video input")
        }
        
        
        AVCaptureManager.captureSession.commitConfiguration()
        print("config committed")
        
        
        
        
    }
    
    
}


