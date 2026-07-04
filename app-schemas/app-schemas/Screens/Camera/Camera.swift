import AVFoundation
import SwiftUI

/// A minimal camera controller built on `AVFoundation`.
///
/// It configures a photo capture session on the back camera and exposes an
/// async ``capturePhoto()`` that returns the captured image. Nothing is saved —
/// the caller just displays the returned `UIImage`.
@Observable
final class Camera: NSObject {
    /// The capture session driving both the live preview and photo capture.
    let session = AVCaptureSession()

    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "app-schemas.camera.session")

    /// Whether inputs/outputs were successfully wired up. Stays `false` when no
    /// camera is available (for example, on the Simulator), which lets
    /// ``capturePhoto()`` fail gracefully instead of raising an exception.
    private var isConfigured = false

    /// Bridges the delegate-based capture callback to `async`/`await`.
    private var photoContinuation: CheckedContinuation<UIImage, Error>?

    enum CameraError: Error {
        case notAuthorized
        case unavailable
        case noImageData
    }

    /// Requests authorization, configures the session on first use, and starts
    /// the preview feed.
    func start() async throws {
        guard await isAuthorized else { throw CameraError.notAuthorized }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            sessionQueue.async { [self] in
                configureIfNeeded()
                guard isConfigured else {
                    continuation.resume(throwing: CameraError.unavailable)
                    return
                }
                if !session.isRunning {
                    session.startRunning()
                }
                continuation.resume()
            }
        }
    }

    /// Stops the preview feed. Call when the camera screen goes away.
    func stop() {
        sessionQueue.async { [self] in
            if session.isRunning {
                session.stopRunning()
            }
        }
    }

    /// Captures a single photo and returns it as a `UIImage`.
    func capturePhoto() async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            sessionQueue.async { [self] in
                guard isConfigured else {
                    continuation.resume(throwing: CameraError.unavailable)
                    return
                }
                photoContinuation = continuation
                photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            }
        }
    }

    private var isAuthorized: Bool {
        get async {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                return true
            case .notDetermined:
                return await AVCaptureDevice.requestAccess(for: .video)
            default:
                return false
            }
        }
    }

    /// Wires up the back camera input and the photo output exactly once.
    private func configureIfNeeded() {
        guard !isConfigured else { return }

        session.beginConfiguration()
        defer { session.commitConfiguration() }

        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(photoOutput) else {
            return
        }

        session.addInput(input)
        session.addOutput(photoOutput)
        isConfigured = true
    }
}

extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        defer { photoContinuation = nil }

        if let error {
            photoContinuation?.resume(throwing: error)
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            photoContinuation?.resume(throwing: CameraError.noImageData)
            return
        }

        photoContinuation?.resume(returning: image)
    }
}

/// A SwiftUI wrapper around `AVCaptureVideoPreviewLayer` that shows the live
/// camera feed for a session.
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}

    /// A `UIView` backed directly by an `AVCaptureVideoPreviewLayer`.
    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
}
