//
//  ContentView.swift
//  watchdemo Watch App
//
//  Created by Stephen Rogers on 19/05/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WatchConnectivityModel = WatchConnectivityModel()
    var body: some View {
        VStack {
            Button("Start") {
                viewModel.start()
            }
            Button("Stop") {
                viewModel.stop()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
