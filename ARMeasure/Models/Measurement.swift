//
//  Measurement.swift
//  ARMeasure
//
//  Created by Denidu Gamage on 2025-07-03.
//

import Foundation
import simd

struct Measurement : Identifiable {
    let id = UUID()
    let start: SIMD3<Float>
    let end: SIMD3<Float>
    
    var distance : Float {
        simd_distance(start, end)
    }
}
