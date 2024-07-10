//
//  SkeletonBone.swift
//  BodyTrackingExercise
//
//  Created by Kevin Tun on 7/10/24.
//

import Foundation
import RealityKit

struct SkeletonBone{
    var fromJoint: SkeletonJoint
    var toJoint: SkeletonJoint
    
    //center position of the skeleton
    var centerPosition : SIMD3<Float>{
        [(fromJoint.position.x + toJoint.position.x)/2,(fromJoint.position.y + toJoint.position.y)/2, (fromJoint.position.z + toJoint.position.z)/2 ]
        
    }
    
    // euclidean distance between two joints
    var length : Float{
        simd_distance(fromJoint.position, toJoint.position)
    }
    
    
    
    
    
}
