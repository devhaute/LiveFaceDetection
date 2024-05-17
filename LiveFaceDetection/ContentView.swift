//
//  ContentView.swift
//  LiveFaceDetection
//
//  Created by chanho on 5/3/24.
//

import SwiftUI

enum AppPath: Hashable {
    case detectFace
    case detectFace2
    case detectFace3
}

struct ContentView: View {
    @State private var paths = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $paths) {
            HStack(spacing: 30) {
                Button {
                    paths.append(AppPath.detectFace)
                } label: {
                    Text("detectFace")
                }
                
                Button {
                    paths.append(AppPath.detectFace2)
                } label: {
                    Text("detectFace2")
                }
                
                Button {
                    paths.append(AppPath.detectFace3)
                } label: {
                    Text("detectFace3")
                }
            }
            .navigationDestination(for: AppPath.self) { path in
                switch path {
                case .detectFace:
                    FaceCaptureViewControllerWrapper()
                case .detectFace2:
                    DetectFaceView2()
                case .detectFace3:
                    CompareFaceView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct FaceCaptureViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FaceCaptureViewController {
        FaceCaptureViewController()
    }
    
    func updateUIViewController(_ uiViewController: FaceCaptureViewController, context: Context) {
        // Here you can pass data to the UIViewController if needed
    }
}
