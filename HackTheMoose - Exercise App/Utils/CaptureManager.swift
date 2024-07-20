//
//  AVCaptureManager.swift
//  HackTheMoose - Exercise App
//
//  Created by Kevin Tun on 7/15/24.
//

import Foundation
import AVFoundation
import Combine

class CaptureManager {
    
    //singleton setup
    static let shared = CaptureManager()
    let captureSession: AVCaptureSession
    let outputDelegate: OutputDelegate
    let framePublisher: PassthroughSubject<CMSampleBuffer, Never>?
    
    private init(){
        // Create the capture session.
        captureSession = AVCaptureSession()
        
        // Create a new passthrough subject that publishes frames to subscribers.
        framePublisher = PassthroughSubject<CMSampleBuffer, Never>()
        
        outputDelegate = OutputDelegate(framePublisher: framePublisher!)
        
        setupCapture()
    }
    
    //setup publisher
    func setupPublisher() -> Void{
        
        
       
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
        
        
        //configure output
        let output = AVCaptureVideoDataOutput()
        
        let pixelTypeKey = String(kCVPixelBufferPixelFormatTypeKey)
        output.videoSettings = [pixelTypeKey: kCVPixelFormatType_32BGRA]
        
        // Discard newer frames if the app is busy with an earlier frame.
        output.alwaysDiscardsLateVideoFrames = true
        
        let videoQueue = DispatchQueue(label: "videoQueue")
        output.setSampleBufferDelegate(outputDelegate, queue: videoQueue)
        
        guard captureSession.canAddOutput(output) else {
            print("Could not add output") ; return }
        captureSession.addOutput(output)
        
        
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



