/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the Exercise Classifier's frame rate.
 This property reflect the value the model's author set in the
 Create ML developer tool's training parameters.
*/

import CoreML

extension jumping_jacks_model_1_01 {
    
    /// Creates a shared Exercise Classifier instance for the app at launch.
    static let shared: jumping_jacks_model_1_01 = {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an Exercise Classifier instance.
        guard let exerciseClassifier = try? jumping_jacks_model_1_01(configuration: defaultConfig) else {
            // The app requires the action classifier to function.
            fatalError("Exercise Classifier failed to initialize.")
        }

        // Ensure the Exercise Classifier.Label cases match the model's classes.
       // exerciseClassifier.checkLabels()

        return exerciseClassifier
    }()
    
    
    /// The value of the Frame Rate training parameter the action
    /// classifier's creator used in the Create ML developer tool.
    ///
    /// The app configures the device's camera to generate this many frames
    /// per second to match the action classifier's expectations.
    ///
    /// **Note**
    /// If you replace the Exercise Classifier with your own action
    /// classifier model, set this value to match the Frame Rate training
    /// parameter you used in the Create ML developer tool.
    /// - Tag: frameRate
    static let frameRate = 30.0

    /// Returns number of input data samples the model expects in its `poses`
    /// multiarray input to make a prediction. See ExerciseClassifier.mlmodel >
    /// Predictions
    ///
    /// The `keypointsMultiArray()` method of a `VNHumanBodyPoseObservation`
    /// returns a multiarray for one sample.
    ///
    /// The window size is the number of samples you must merge together
    /// by using the `MLMultiArray(concatenating: axis: dataType:)` initializer.
    /// - Tag: calculatePredictionWindowSize
    func calculatePredictionWindowSize() -> Int {
        let modelDescription = model.modelDescription

        let modelInputs = modelDescription.inputDescriptionsByName
        assert(modelInputs.count == 1, "The model should have exactly 1 input")

        guard let  input = modelInputs.first?.value else {
            fatalError("The model must have at least 1 input.")
        }

        guard input.type == .multiArray else {
            fatalError("The model's input must be an `MLMultiArray`.")
        }

        guard let multiArrayConstraint = input.multiArrayConstraint else {
            fatalError("The multiarray input must have a constraint.")
        }

        let dimensions = multiArrayConstraint.shape
        guard dimensions.count == 3 else {
            fatalError("The model's input multiarray must be 3 dimensions.")
        }

        let windowSize = Int(truncating: dimensions.first!)
        let frameRate = jumping_jacks_model_1_01.frameRate

        let timeSpan = Double(windowSize) / frameRate
        let timeString = String(format: "%0.2f second(s)", timeSpan)
        let fpsString = String(format: "%.0f fps", frameRate)
        print("Window is \(windowSize) frames wide, or \(timeString) at \(fpsString).")

        return windowSize
    }
}

extension jumping_jacks_model_1_01 {
    /// Predicts an action from a series of landmarks' positions over time.
    /// - Parameter window: An `MLMultiarray` that contains the locations of a
    /// person's body landmarks for multiple points in time.
    /// - Returns: An `ActionPrediction`.
    /// - Tag: predictActionFromWindow
    func predictActionFromWindow(_ window: MLMultiArray) -> ActionPrediction {
        do {
            let output = try prediction(poses: window)
            let action = Label(output.label)
            let confidence = output.labelProbabilities[output.label]!

            return ActionPrediction(label: action.rawValue, confidence: confidence)

        } catch {
            fatalError("Exercise Classifier prediction error: \(error)")
        }
    }
}

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the app's knowledge of the model's class labels.
*/

extension jumping_jacks_model_1_01 {
    /// Represents the app's knowledge of the Exercise Classifier model's labels.
    enum Label: String, CaseIterable {
        case jumping_jack_eccentric = "jumping_jack_eccentric"
        case jumping_jack_concentric = "jumping_jack_concentric"
        

        /// A negative class that represents irrelevant actions.
        case other = "other"

        /// Creates a label from a string.
        /// - Parameter label: The name of an action class.
        init(_ string: String) {
            guard let label = Label(rawValue: string) else {
                let typeName = String(reflecting: Label.self)
                fatalError("Add the `\(string)` label to the `\(typeName)` type.")
            }

            self = label
        }
    }
}


