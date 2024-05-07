//
//  FaceCaptureViewController.swift
//  LiveFaceDetection
//
//  Created by chanho on 5/3/24.
//

import UIKit
import AVFoundation
import Vision

class FaceCaptureViewController: UIViewController {
    private var captureDevice: AVCaptureDevice?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCameraFrames()
        
        Task {
            captureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        captureSession.stopRunning()
    }
    
    private func setUpCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get capture device for camera position: front")
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .hd1280x720
        captureDevice = device
        
        if let captureDevice {
            do {
                try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                
                if captureSession.canAddOutput(photoOutput) {
                    captureSession.addOutput(photoOutput)
                }
                
            } catch {
                print("error: \(error.localizedDescription)")
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.frame = UIScreen.main.bounds
            previewLayer?.videoGravity = .resizeAspectFill
            
            if let previewLayer {
                view.layer.addSublayer(previewLayer)
            }
            
            captureSession.commitConfiguration()
            
            if let audioDevice = AVCaptureDevice.default(for: .audio) {
                do {
                    let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                    if captureSession.canAddInput(audioInput) {
                        captureSession.addInput(audioInput)
                    }
                } catch {
                    print("Error setting up audio input: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension FaceCaptureViewController {
    private func getCameraFrames() {
        videoOutput.videoSettings = [
            (kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)
        ] as [String: Any]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        if !captureSession.outputs.contains(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        guard let connection = videoOutput.connection(with: .video),
              connection.isVideoOrientationSupported else {
            return
        }
        
        connection.videoOrientation = .portrait
    }
    
    private func detectFace(image: CVPixelBuffer) {
        let detectCaptureQualityRequest = VNDetectFaceCaptureQualityRequest()
        detectCaptureQualityRequest.revision = VNDetectFaceCaptureQualityRequestRevision2   // iOS 14.0+
        
        let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        do {
            try handler.perform([detectCaptureQualityRequest])
            
            if let results = detectCaptureQualityRequest.results {
                for face in results {
                    print("Face capture quality score: \(face.faceCaptureQuality ?? 0)")
                }
            }
        } catch {
            print("Failed to perform detection: \(error.localizedDescription)")
        }
    }
}

extension FaceCaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        detectFace(image: frame)
    }
}
