//
//  FrameProcessor.swift
//  HackTheMoose_Exercise
//
//  Created by Kevin Tun on 7/19/24.
//

import Foundation
import Combine
import AVFoundation
import CoreMedia
import Vision
import CoreImage



class Predictor{
    
    var subscriber: AnyCancellable?
    
    let predictionOutSubject = PassthroughSubject<String, Never>()
    
    
    let humanBodyPoseRequest = VNDetectHumanBodyPoseRequest()
    
    /// The number of pose data instances the action classifier needs
    /// to make a prediction.
    /// - Tag: predictionWindowSize
    private let predictionWindowSize: Int

    /// The number of pose data instances the window advances after each
    /// prediction.
    ///
    /// Increase the stride's value to make predictions less frequently.
    /// - Tag: windowStride
    private let windowStride = 10
    
    private var window = [MLMultiArray?]()
    
    
    
    init() {
        predictionWindowSize = jumping_jacks_model_1_01.shared.calculatePredictionWindowSize()
    }
    
    func subscribeToFramePublisher() {
        subscriber = CaptureManager.shared.framePublisher?.sink(receiveValue: processFrame)
    }
    func processFrame(_ sampleBuffer: CMSampleBuffer){
        var image = imageFromFrame(sampleBuffer)
        
        var poses = findPosesInFrame(image!)
        
        var largestPose = isolateLargestPose(poses)
        
        var multiArray = multiArrayFromPose(largestPose)
        
        window = gatherWindow(previousWindow: window, multiArray: multiArray)
        
        if gateWindow(window) {
            var prediction = predictActionWithWindow(window)
            predictionOutSubject.send(prediction.label)
            print("Prediction is " + prediction.label)
        }
        
    }
    
    
    private func imageFromFrame(_ buffer: CMSampleBuffer) -> CGImage? {
        

        guard let imageBuffer = buffer.imageBuffer else {
            print("The frame doesn't have an underlying image buffer.")
            return nil
        }

        // Create a Core Image context.
        let ciContext = CIContext(options: nil)

        // Create a Core Image image from the sample buffer.
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)

        // Generate a Core Graphics image from the Core Image image.
        guard let cgImage = ciContext.createCGImage(ciImage,
                                                    from: ciImage.extent) else {
            print("Unable to create an image from a frame.")
            return nil
        }

        return cgImage
    }

    private func findPosesInFrame(_ frame: CGImage) -> [Pose]? {
        // Create a request handler for the image.
        let visionRequestHandler = VNImageRequestHandler(cgImage: frame)

        // Use Vision to find human body poses in the frame.
        do { try visionRequestHandler.perform([humanBodyPoseRequest]) } catch {
            assertionFailure("Human Pose Request failed: \(error)")
        }

        let poses = Pose.fromObservations(humanBodyPoseRequest.results)

        return poses
    }
    
    private func isolateLargestPose(_ poses: [Pose]?) -> Pose? {
        return poses?.max(by:) { pose1, pose2 in pose1.area < pose2.area }
    }
    
    private func multiArrayFromPose(_ item: Pose?) -> MLMultiArray? {
        return item?.multiArray
    }
    
    private func gatherWindow(previousWindow: [MLMultiArray?],
                              multiArray: MLMultiArray?) -> [MLMultiArray?] {
        var currentWindow = previousWindow


        // If the previous window size is the target size, it
        // means sendWindowWhenReady() just published an array window.
        if previousWindow.count == predictionWindowSize {
            // Advance the sliding array window by stride elements.
            currentWindow.removeFirst(windowStride)
        }


        // Add the newest multiarray to the window.
        currentWindow.append(multiArray)


        // Publish the array window to the next subscriber.
        // The currentWindow becomes this method's next previousWindow when
        // it receives the next multiarray from the upstream publisher.
        return currentWindow
    }
    
    private func gateWindow(_ currentWindow: [MLMultiArray?]) -> Bool {
        return currentWindow.count == predictionWindowSize
    }
    
    /// Makes a prediction from the multiarray window.
    /// - Parameter currentWindow: An`MLMultiArray?` array.
    /// - Returns: An `ActionPrediction`.
    /// - Tag: predictActionWithWindow
    private func predictActionWithWindow(_ currentWindow: [MLMultiArray?]) -> ActionPrediction {
        var poseCount = 0

        // Fill the nil elements with an empty pose array.
        let filledWindow: [MLMultiArray] = currentWindow.map { multiArray in
            if let multiArray = multiArray {
                poseCount += 1
                return multiArray
            } else {
                return Pose.emptyPoseMultiArray
            }
        }

        // Only use windows with at least 60% real data to make a prediction
        // with the action classifier.
        let minimum = predictionWindowSize * 60 / 100
        guard poseCount >= minimum else {
            return ActionPrediction.noPersonPrediction
        }

        // Merge the array window of multiarrays into one multiarray.
        let mergedWindow = MLMultiArray(concatenating: filledWindow,
                                        axis: 0,
                                        dataType: .float)

        // Make a genuine prediction with the action classifier.
        let prediction = jumping_jacks_model_1_01.shared.predictActionFromWindow(mergedWindow)

        // Return the model's prediction if the confidence is high enough.
        // Otherwise, return a "Low Confidence" prediction.
        return checkConfidence(prediction)
    }

    /// Sends an action prediction to the delegate on the main thread.
    /// - Parameter actionPrediction: The action classifier's prediction.
    /// - Tag: checkConfidence
    private func checkConfidence(_ actionPrediction: ActionPrediction) -> ActionPrediction {
        let minimumConfidence = 0.6

        let lowConfidence = actionPrediction.confidence < minimumConfidence
        return lowConfidence ? .lowConfidencePrediction : actionPrediction
    }
    
    
    
    
    
}
