//
//  DetectFaceCameraView.swift
//  LiveFaceDetection
//
//  Created by chanho on 5/14/24.
//

import SwiftUI
import AVFoundation
import Vision

struct DetectFaceCameraView: UIViewControllerRepresentable {
    let faceDetected: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        // 1. 세션 생성
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720
        
        // 2. 캡쳐 디바이스 설정
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return viewController
        }
        
        // 3. 캡쳐 인풋 설정
        guard let videoInput = try? AVCaptureDeviceInput(device: device) else {
            return viewController
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        // 4. 아웃풋 설정
        let videoOuput = AVCaptureVideoDataOutput()
        videoOuput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue.global(qos: .userInitiated))
        
        if captureSession.canAddOutput(videoOuput) {
            captureSession.addOutput(videoOuput)
        }
        
        // 4. preview 설정
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

extension DetectFaceCameraView {
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        let faceDetected: () -> Void
        
        init(faceDetected: @escaping () -> Void) {
            self.faceDetected = faceDetected
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
            let faces = faceDetector?.features(in: ciImage) ?? []
            
            if !faces.isEmpty {
                Task { @MainActor in
                    faceDetected()
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(faceDetected: faceDetected)
    }
}
