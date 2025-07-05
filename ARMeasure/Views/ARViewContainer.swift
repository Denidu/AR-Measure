//
//  ARViewContainer.swift
//  ARMeasure
//
//  Created by Denidu Gamage on 2025-07-03.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: MeasurementViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        arView.session.run(config, options: [])

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)

        context.coordinator.arView = arView

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject {
        var viewModel: MeasurementViewModel
        weak var arView: ARView?

        init(viewModel: MeasurementViewModel) {
            self.viewModel = viewModel
        }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            let location = sender.location(in: arView)

            if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .any).first {
                let worldTransform = result.worldTransform
                let position = SIMD3<Float>(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)

                viewModel.addPoint(position)
                placeSphere(at: position)

                if let last = viewModel.measurements.last {
                    placeLine(from: last.start, to: last.end)
                }
            }
        }

        func placeSphere(at position: SIMD3<Float>) {
            let mesh = MeshResource.generateSphere(radius: 0.005)
            let material = SimpleMaterial(color: .red, isMetallic: false)
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.position = position

            let anchor = AnchorEntity(world: position)
            anchor.addChild(entity)
            arView?.scene.addAnchor(anchor)
        }

        func placeLine(from start: SIMD3<Float>, to end: SIMD3<Float>) {
            let lineMesh = try! MeshResource.generateBox(size: [simd_distance(start, end), 0.001, 0.001])
            let material = SimpleMaterial(color: .blue, isMetallic: false)
            let entity = ModelEntity(mesh: lineMesh, materials: [material])

            entity.position = (start + end) / 2
            entity.look(at: end, from: entity.position, relativeTo: nil)

            let anchor = AnchorEntity()
            anchor.addChild(entity)
            arView?.scene.addAnchor(anchor)
        }
    }
}
