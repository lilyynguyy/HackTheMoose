/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A `Pose` is a collection of "landmarks" and connections between select landmarks.
 Each `Pose` can draw itself as a wireframe to a Core Graphics context.
*/

import UIKit
import Vision

typealias Observation = VNHumanBodyPoseObservation
/// Stores the landmarks and connections of a human body pose and draws them as
/// a wireframe.
/// - Tag: Pose
struct Pose {
    /// The names and locations of the significant points on a human body.
    private let landmarks: [Landmark]

    /// A list of lines between landmarks for drawing a wireframe.
    private var connections: [Connection]!

    /// The locations of the pose's landmarks as a multiarray.
    /// - Tag: multiArray
    let multiArray: MLMultiArray?

    /// A rough approximation of the landmarks' area.
    let area: CGFloat

    /// Creates a `Pose` for each human body pose observation in the array.
    /// - Parameter observations: An array of human body pose observations.
    /// - Returns: A `Pose` array.
    static func fromObservations(_ observations: [Observation]?) -> [Pose]? {
        // Convert each observations to a `Pose`.
        observations?.compactMap { observation in Pose(observation) }
    }

    /// Creates a wireframe from a human pose observation.
    /// - Parameter observation: A human body pose observation.
    init?(_ observation: Observation) {
        // Create a landmark for each joint in the observation.
        landmarks = observation.availableJointNames.compactMap { jointName in
            guard jointName != JointName.root else {
                return nil
            }

            guard let point = try? observation.recognizedPoint(jointName) else {
                return nil
            }

            return Landmark(point)
        }

        guard !landmarks.isEmpty else { return nil }

        //
        area = Pose.areaEstimateOfLandmarks(landmarks)

        // Save the multiarray from the observation.
        multiArray = try? observation.keypointsMultiArray()

        // Build a list of connections from the pose's landmarks.
        buildConnections()
    }

    /// Draws all the valid connections and landmarks of the wireframe.
    /// - Parameters:
    ///   - context: A context the method uses to draw the wireframe.
    ///   - transform: A transform that modifies the point locations.
    /// - Tag: drawWireframeToContext
    func drawWireframeToContext(_ context: CGContext,
                                applying transform: CGAffineTransform? = nil) {
        let scale = drawingScale

        // Draw the connection lines first.
        connections.forEach {
            line in line.drawToContext(context,
                                       applying: transform,
                                       at: scale)

        }

        // Draw the landmarks on top of the lines' endpoints.
        landmarks.forEach { landmark in
            landmark.drawToContext(context,
                                   applying: transform,
                                   at: scale)
        }
    }

    /// Adjusts the landmarks radius and connection thickness when the pose draws
    /// itself as a wireframe.
    private var drawingScale: CGFloat {
        /// The typical size of a dominant pose.
        ///
        /// The sample's author empirically derived this value.
        let typicalLargePoseArea: CGFloat = 0.35

        /// The largest scale is 100%.
        let max: CGFloat = 1.0

        /// The smallest scale is 60%.
        let min: CGFloat = 0.6

        /// The area's ratio relative to the typically large pose area.
        let ratio = area / typicalLargePoseArea

        let scale = ratio >= max ? max : (ratio * (max - min)) + min
        return scale
    }
}

// MARK: - Helper methods
extension Pose {
    /// Creates an array of connections from the available landmarks.
    mutating func buildConnections() {
        // Only build the connections once.
        guard connections == nil else {
            return
        }

        connections = [Connection]()

        // Get the joint name for each landmark.
        let joints = landmarks.map { $0.name }

        // Get the location for each landmark.
        let locations = landmarks.map { $0.location }

        // Create a lookup dictionary of landmark locations.
        let zippedPairs = zip(joints, locations)
        let jointLocations = Dictionary(uniqueKeysWithValues: zippedPairs)

        // Add a connection if both of its endpoints have valid landmarks.
        for jointPair in Pose.jointPairs {
            guard let one = jointLocations[jointPair.joint1] else { continue }
            guard let two = jointLocations[jointPair.joint2] else { continue }

            connections.append(Connection(one, two))
        }
    }

    /// Returns a rough estimate of the landmarks' collective area.
    /// - Parameter landmarks: A `Landmark` array.
    /// - Returns: A `CGFloat` that is greater than or equal to `0.0`.
    static func areaEstimateOfLandmarks(_ landmarks: [Landmark]) -> CGFloat {
        let xCoordinates = landmarks.map { $0.location.x }
        let yCoordinates = landmarks.map { $0.location.y }

        guard let minX = xCoordinates.min() else { return 0.0 }
        guard let maxX = xCoordinates.max() else { return 0.0 }

        guard let minY = yCoordinates.min() else { return 0.0 }
        guard let maxY = yCoordinates.max() else { return 0.0 }

        let deltaX = maxX - minX
        let deltaY = maxY - minY

        return deltaX * deltaY
    }
}

extension Pose {
    typealias JointName = VNHumanBodyPoseObservation.JointName

    /// The name and location of a point of interest on a human body.
    ///
    /// Each landmark defines its location in an image and the name of the body
    /// joint it represents, such as nose, left eye, right knee, and so on.
    struct Landmark {
        /// The minimum `VNRecognizedPoint` confidence for a valid `Landmark`.
        private static let threshold: Float = 0.2

        /// The drawing radius of a landmark.
        private static let radius: CGFloat = 14.0

        /// The name of the landmark.
        ///
        /// For example, "left shoulder", "right knee", "nose", and so on.
        let name: JointName

        /// The location of the landmark in normalized coordinates.
        ///
        /// When calling `drawToContext()`, use a transform to apply a scale
        /// that's appropriate for the graphics context.
        let location: CGPoint

        /// Creates a landmark from a point.
        /// - Parameter point: A point in a human body pose observation.
        init?(_ point: VNRecognizedPoint) {
            // Only create a landmark from a point that satisfies the minimum
            // confidence.
            guard point.confidence >= Pose.Landmark.threshold else {
                return nil
            }

            name = JointName(rawValue: point.identifier)
            location = point.location
        }

        /// Draws a circle at the landmark's location after transformation.
        /// - Parameters:
        ///   - context: A context the method uses to draw the landmark.
        ///   - transform: A transform that modifies the point locations.
        func drawToContext(_ context: CGContext,
                           applying transform: CGAffineTransform? = nil,
                           at scale: CGFloat = 1.0) {

            context.setFillColor(UIColor.white.cgColor)
            context.setStrokeColor(UIColor.darkGray.cgColor)

            // Define the rectangle's origin by applying the transform to the
            // landmark's normalized location.
            let origin = location.applying(transform ?? .identity)

            // Define the size of the circle's rectangle with the radius.
            let radius = Landmark.radius * scale
            let diameter = radius * 2
            let rectangle = CGRect(x: origin.x - radius,
                                   y: origin.y - radius,
                                   width: diameter,
                                   height: diameter)

            context.addEllipse(in: rectangle)
            context.drawPath(using: CGPathDrawingMode.fillStroke)
        }
    }
}

extension Pose {
    /// Represents a line between two landmarks.
    struct Connection: Equatable {
        static let width: CGFloat = 12.0

        /// The gradient colors the connection uses to draw its line.
        static let colors = [UIColor.systemGreen.cgColor,
                             UIColor.systemYellow.cgColor,
                             UIColor.systemOrange.cgColor,
                             UIColor.systemRed.cgColor,
                             UIColor.systemPurple.cgColor,
                             UIColor.systemBlue.cgColor
        ] as CFArray

        static let gradientColorSpace = CGColorSpace(name: CGColorSpace.sRGB)

        static let gradient = CGGradient(colorsSpace: gradientColorSpace,
                                         colors: colors,
                                         locations: [0, 0.2, 0.33, 0.5, 0.66, 0.8])!

        /// The connection's first endpoint.
        private let point1: CGPoint

        /// The connection's second endpoint.
        private let point2: CGPoint

        /// Creates a connection from two points.
        ///
        /// The order of the points isn't important.
        /// - Parameters:
        ///   - one: The location for one end of the connection.
        ///   - two: The location for the other end of the connection.
        init(_ one: CGPoint, _ two: CGPoint) { point1 = one; point2 = two }

        /// Draws a line from the connection's first endpoint to its other
        /// endpoint.
        /// - Parameters:
        ///   - context: The Core Graphics context to draw to.
        ///   - transform: An affine transform that scales and translate each
        ///   endpoint.
        ///   - scale: The scale that adjusts the line's thickness
        func drawToContext(_ context: CGContext,
                           applying transform: CGAffineTransform? = nil,
                           at scale: CGFloat = 1.0) {

            let start = point1.applying(transform ?? .identity)
            let end = point2.applying(transform ?? .identity)

            // Store the current graphics state.
            context.saveGState()

            // Restore the graphics state after the method finishes.
            defer { context.restoreGState() }

            // Set the line's thickness.
            context.setLineWidth(Connection.width * scale)

            // Draw the line.
            context.move(to: start)
            context.addLine(to: end)
            context.replacePathWithStrokedPath()
            context.clip()
            context.drawLinearGradient(Connection.gradient,
                                       start: start,
                                       end: end,
                                       options: .drawsAfterEndLocation)
        }
    }
}

extension Pose {
    /// A series of joint pairs that define the wireframe lines of a pose.
    static let jointPairs: [(joint1: JointName, joint2: JointName)] = [
        // The left arm's connections.
        (.leftShoulder, .leftElbow),
        (.leftElbow, .leftWrist),

        // The left leg's connections.
        (.leftHip, .leftKnee),
        (.leftKnee, .leftAnkle),

        // The right arm's connections.
        (.rightShoulder, .rightElbow),
        (.rightElbow, .rightWrist),

        // The right leg's connections.
        (.rightHip, .rightKnee),
        (.rightKnee, .rightAnkle),

        // The torso's connections.
        (.leftShoulder, .neck),
        (.rightShoulder, .neck),
        (.leftShoulder, .leftHip),
        (.rightShoulder, .rightHip),
        (.leftHip, .rightHip)
    ]
}

extension Pose {
    /// A multiarray with the same dimensions as human body pose
    /// that sets each element to zero.
    ///
    /// This instance has the same shape as the multiarray from a
    /// `VNHumanBodyPoseObservation` instance.
    /// - Tag: emptyPoseMultiArray
    static let emptyPoseMultiArray = zeroedMultiArrayWithShape([1, 3, 18])

    /// Creates a multiarray and assigns zero to every element.
    /// - Returns: An `MLMultiArray`.
    private static func zeroedMultiArrayWithShape(_ shape: [Int]) -> MLMultiArray {
        // Create the multiarray.
        guard let array = try? MLMultiArray(shape: shape as [NSNumber],
                                            dataType: .double) else {
            fatalError("Creating a multiarray with \(shape) shouldn't fail.")
        }

        // Get a pointer to quickly set the array's values.
        guard let pointer = try? UnsafeMutableBufferPointer<Double>(array) else {
            fatalError("Unable to initialize multiarray with zeros.")
        }

        // Set every element to zero.
        pointer.initialize(repeating: 0.0)
        return array
    }
}

