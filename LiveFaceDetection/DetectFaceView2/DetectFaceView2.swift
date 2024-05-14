//
//  DetectFaceView2.swift
//  LiveFaceDetection
//
//  Created by chanho on 5/7/24.
//

import SwiftUI

struct DetectFaceView2: View {
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            DetectFaceCameraView(faceDetected: faceDetected)
            
            VStack {
                Spacer()
                
                Text("얼굴이 보입니다")
                    .foregroundStyle(.white)
                    .font(.title)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [.green, .cyan], startPoint: .leading, endPoint: .trailing)
                    )
                    .offset(y: showAlert ? 0 : 100)
            }
        }
    }
    
    private func faceDetected() {
        withAnimation {
            showAlert = true
        }
    }
}

#Preview {
    DetectFaceView2()
}
