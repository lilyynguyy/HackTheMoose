//
//  AVCaptureManager.swift
//  HackTheMoose - Exercise App
//
//  Created by Kevin Tun on 7/15/24.
//

import Foundation
import AVFoundation

class AVCaptureManager{
    
    //singleton setup
    static let shared = AVCaptureManager()
    let captureSession: AVCaptureSession
    
    private init(){
        // Create the capture session.
        captureSession = AVCaptureSession()
        setupCapture()
    }
    
   
    //setups the capture
    func setupCapture() -> Void {
        
        print("Capture setup called")

       captureSession.beginConfiguration()
        //print("config started")
        
        //guard keyword for early return
        // Find the default video device.
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: AVCaptureDevice.Position.front) else { return }
        
        do {
            // Wrap the video device in a capture device input.
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            // If the input can be added, add it to the session.
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
                //print("video input added")
            }
        } catch {
            // Configuration failed. Handle error.
            print("Error adding video input")
        }
        
        
        captureSession.commitConfiguration()
    
        
    }
    
    //start capture
    func startCapture() -> Void {
        captureSession.startRunning()
    }
    
    //end capture
    func endCapture() -> Void {
        captureSession.stopRunning()
    }
}


