//  Project name: Translator
//  File name   : CaptureManager.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/8/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 Vulcan Labs. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import Foundation
import AVFoundation
import CoreGraphics


public protocol CaptureManagerDelegate {
    func onFrameReady(frame: CVImageBuffer)
}

public final class CaptureManager: NSObject {


    // MARK: Class's properties
    public let session = AVCaptureSession()
    public var delegate: CaptureManagerDelegate?

    public fileprivate(set) var captureInput: AVCaptureDeviceInput?
    public fileprivate(set) var captureOutput: AVCaptureVideoDataOutput?

    fileprivate let queue = DispatchQueue(label: "com.fiision.lib.FwiOpenGLES")

    // MARK: Class's constructors
    public override init() {
        super.init()

        /* Condition validation */
        guard captureCount > 0 else {
            return
        }

        do {
            // Initialize input
            captureInput = try AVCaptureDeviceInput(device: try captureBack())

            // Initialize capture session & preset medium quality for video
            if session.canSetSessionPreset(AVCaptureSessionPresetHigh) {
                session.canSetSessionPreset(AVCaptureSessionPresetHigh)
            }

            // Add video
            if session.canAddInput(captureInput) {
                session.addInput(captureInput)
            }

            // Register an output
            captureOutput = AVCaptureVideoDataOutput()
            captureOutput?.alwaysDiscardsLateVideoFrames = true

            captureOutput?.setSampleBufferDelegate(self, queue: queue)

            let key = String(kCVPixelBufferPixelFormatTypeKey)
            let videoSettings: [String:Any] = [key:UInt(kCVPixelFormatType_32BGRA)]
            captureOutput?.videoSettings = videoSettings

            if session.canAddOutput(captureOutput) {
                session.addOutput(captureOutput)
            }
        } catch {
            // Do nothing.
        }
    }

    // MARK: Class's public methods
    /// Toggle between back and front camera.
    @discardableResult
    public func toggleCamera() -> Bool {
        /* Condition validation */
        guard captureCount > 1, let input = captureInput else {
            return false
        }

        do {
            let position = captureInput?.device.position ?? .back

            // Initialize new video input
            let capture = (position == .back ? try captureFront() : try captureBack())
            let newInput = try AVCaptureDeviceInput(device: capture)

            // Switch video input
            session.beginConfiguration()
            session.removeInput(input)

            if session.canAddInput(newInput) {
                session.addInput(newInput)
                captureInput = newInput
            } else {
                session.addInput(input)
            }

            session.commitConfiguration()
            return true
        } catch _ {
            return false
        }
    }

    /// Set auto focus.
    ///
    /// @param
    /// - point {CGPoint} (a point that user had touched on screen)
    public func autoFocus(atPoint point: CGPoint) {
        /* Condition validation */
        guard let device = captureInput?.device, device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) else {
            return
        }

        do {
            try device.lockForConfiguration()

            device.focusPointOfInterest = point
            device.focusMode = .autoFocus

            device.unlockForConfiguration()
        } catch _ {
            // Do nothing here.
        }
    }

    /// Set continuous focus.
    ///
    /// @param
    /// - point {CGPoint} (a point that user had touched on screen)
    public func continuousFocus(atPoint point: CGPoint) {
        /* Condition validation */
        guard let device = captureInput?.device, device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus) else {
            return
        }

        do {
            try device.lockForConfiguration()

            device.focusPointOfInterest = point
            device.focusMode = .continuousAutoFocus

            device.unlockForConfiguration()
        } catch _ {
            // Do nothing here.
        }
    }

    /// Start preview session.
    public func startPreview() {
        session.startRunning()

//        // Setup the still image file output
//        captureOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
//        if session.canAddOutput(captureOutput) {
//            session.addOutput(captureOutput)
//        }
    }

    /// Stop preview session.
    public func stopPreview() {
        session.stopRunning()
    }
}

// MARK: Class's properties
public extension CaptureManager {

    public var captureCount: Int {
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else {
            return 0
        }
        return devices.count
    }
}

// MARK: ImageCapture
public extension CaptureManager {

    /// Turn on flash.
    public func flashOn() -> Error? {
        guard let device = try? captureBack(), device.hasFlash else {
            return NSError(domain: "co.vulcanlabs.Capture", code: -1, userInfo: [NSLocalizedDescriptionKey:"This device does not have flash!"])
        }

        do {
            try device.lockForConfiguration()

            if device.isFlashModeSupported(.on) {
                device.flashMode = .on
            }

            device.unlockForConfiguration()
            return nil
        } catch let err {
            return err
        }
    }

    /// Turn off flash.
    public func flashOff() -> Error? {
        guard let device = try? captureBack(), device.hasFlash else {
            return NSError(domain: "co.vulcanlabs.Capture", code: -1, userInfo: [NSLocalizedDescriptionKey:"This device does not have flash!"])
        }

        do {
            try device.lockForConfiguration()

            if device.isFlashModeSupported(.off) {
                device.flashMode = .off
            }

            device.unlockForConfiguration()
            return nil
        } catch let err {
            return err
        }
    }

    /// Auto on/off flash.
    public func flashAuto() -> Error? {
        guard let device = try? captureBack(), device.hasFlash else {
            return NSError(domain: "co.vulcanlabs.Capture", code: -1, userInfo: [NSLocalizedDescriptionKey:"This device does not have flash!"])
        }

        do {
            try device.lockForConfiguration()

            if device.isFlashModeSupported(.auto) {
                device.flashMode = .auto
            }

            device.unlockForConfiguration()
            return nil
        } catch let err {
            return err
        }
    }
}

// MARK: Class's private methods
fileprivate extension CaptureManager {

    /// Return back camera reference.
    fileprivate func captureBack() throws -> AVCaptureDevice {
        return try capture(withPosition: .back)
    }

    /// Return front camera reference.
    fileprivate func captureFront() throws -> AVCaptureDevice {
        return try capture(withPosition: .front)
    }

    /// Return reference of a camera at specific position.
    ///
    /// @param
    /// - position {AVCaptureDevicePosition} (a position of a camera)
    fileprivate func capture(withPosition position: AVCaptureDevicePosition) throws -> AVCaptureDevice {
        if #available(iOS 10.0, *) {
            let list: [AVCaptureDeviceType] = [
                AVCaptureDeviceType.builtInTelephotoCamera,
                AVCaptureDeviceType.builtInWideAngleCamera,
                AVCaptureDeviceType.builtInDuoCamera
            ]

            guard let device = AVCaptureDeviceDiscoverySession(deviceTypes: list, mediaType: AVMediaTypeVideo, position: position).devices.first else {
                throw NSError(domain: "co.vulcanlabs.Capture", code: -1, userInfo: [NSLocalizedDescriptionKey:"Capture devices is not available!"])
            }
            return device
        } else {
            guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice], devices.count > 0 else {
                throw NSError(domain: "co.vulcanlabs.Capture", code: -1, userInfo: [NSLocalizedDescriptionKey:"Capture devices is not available!"])
            }

            for device in devices {
                if device.position == position {
                    return device
                }
            }
            return devices[0]
        }
    }
}

// MARK: `AVCaptureVideoDataOutputSampleBufferDelegate`'s members
extension CaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {

    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        defer {
            CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        }
        delegate?.onFrameReady(frame: imageBuffer)
    }

    public func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        debugPrint("A frame just dropped out!")
    }
}
