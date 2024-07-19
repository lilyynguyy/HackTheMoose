//
//  OutputDelegate.swift
//  HackTheMoose_Exercise
//
//  Created by Kevin Tun on 7/19/24.
//

import Foundation
import AVFoundation
import Combine

class OutputDelegate:NSObject,AVCaptureVideoDataOutputSampleBufferDelegate{
    
    let framePublisher: PassthroughSubject<CMSampleBuffer, Never>?
    
    init(framePublisher: PassthroughSubject<CMSampleBuffer, Never>) {
        self.framePublisher = framePublisher
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        
        framePublisher?.send(sampleBuffer)
    }
}

