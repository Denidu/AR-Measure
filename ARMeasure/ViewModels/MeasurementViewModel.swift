//
//  MeasurementViewModel.swift
//  ARMeasure
//
//  Created by Denidu Gamage on 2025-07-03.
//

import Foundation

class MeasurementViewModel: ObservableObject {
    @Published var measurements: [Measurement] = []
    @Published var currentStartPoint: SIMD3<Float>? = nil
    
    func addPoint(_ point: SIMD3<Float>) {
        if let start = currentStartPoint {
            let measurement = Measurement(start: start, end: point)
            measurements.append(measurement)
            currentStartPoint = nil
        } else {
            currentStartPoint = point
        }
    }

    func reset() {
        measurements.removeAll()
        currentStartPoint = nil
    }
}
