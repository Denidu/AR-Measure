//
//  ContentView.swift
//  ARMeasure
//
//  Created by Denidu Gamage on 2025-07-03.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MeasurementViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)

            Button(action: {
                viewModel.reset()
            }) {
                Text("Reset")
                    .font(.headline)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    ContentView()
}
