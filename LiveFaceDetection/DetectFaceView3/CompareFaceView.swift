//
//  CompareFaceView.swift
//  LiveFaceDetection
//
//  Created by chanho on 5/14/24.
//

import SwiftUI

struct CompareFaceView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var referenceImage: UIImage? = UIImage(named: "reference") // Reference 이미지
    @State private var similarity: Double = 0.0
    @State private var showAlert = true
    
    var body: some View {
        VStack {
//            CameraView { image in
//                capturedImage = image
//                if let referenceImage = referenceImage {
//                    compareFaces(currentImage: image, referenceImage: referenceImage)
//                }
//                showAlert = true
//            }
//            .edgesIgnoringSafeArea(.all)
            
            if showAlert {
                VStack {
                    if let capturedImage {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }
                    
                    Text("유사도: \(similarity * 100, specifier: "%.2f")%")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Button(action: {
                        showAlert = false
                    }) {
                        Text("확인")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}
#Preview {
    CompareFaceView()
}
