//
//  ContentView.swift
//  LiveFaceDetection
//
//  Created by chanho on 5/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CameraViewControllerWrapper()
        }
    }
}

#Preview {
    ContentView()
}

struct CameraViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VideoCaptureViewController {
        VideoCaptureViewController()
    }
    
    func updateUIViewController(_ uiViewController: VideoCaptureViewController, context: Context) {
        // Here you can pass data to the UIViewController if needed
    }
}
