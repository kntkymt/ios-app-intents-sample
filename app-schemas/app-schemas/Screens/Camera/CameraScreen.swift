import SwiftUI

/// A modal camera screen shown as a sheet.
///
/// It shows a live preview, captures a photo when the shutter is tapped, and
/// then displays the captured image. Nothing is saved — retaking simply drops
/// the image and returns to the preview. Opened by
/// ``NavigateToCaptureModeIntent`` (the `.camera.openInCaptureMode` schema) or
/// the camera button in ``TodoScreen``.
struct CameraScreen: View {
    let captureMode: CaptureMode

    @Environment(\.dismiss) private var dismiss

    @State private var camera = Camera()
    @State private var capturedImage: UIImage?
    @State private var isCapturing = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                if let capturedImage {
                    // Show the photo the user just took.
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                } else {
                    // Live viewfinder.
                    CameraPreview(session: camera.session)
                        .ignoresSafeArea()
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.callout)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(.black.opacity(0.5), in: .rect(cornerRadius: 12))
                        .padding()
                }

                VStack {
                    Spacer()
                    controls
                        .padding(.bottom, 40)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
        .task {
            do {
                try await camera.start()
            } catch {
                errorMessage = "Camera unavailable.\n\(error.localizedDescription)"
            }
        }
        .onDisappear { camera.stop() }
    }

    /// The shutter (in preview) or a retake button (after capturing).
    @ViewBuilder
    private var controls: some View {
        if capturedImage == nil {
            Button(action: capture) {
                Circle()
                    .fill(.white)
                    .frame(width: 72, height: 72)
                    .overlay {
                        Circle()
                            .stroke(.white, lineWidth: 4)
                            .padding(4)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                    .opacity(isCapturing ? 0.5 : 1)
            }
            .disabled(isCapturing)
        } else {
            Button("Retake") { capturedImage = nil }
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.white.opacity(0.2), in: .capsule)
        }
    }

    private func capture() {
        isCapturing = true
        Task {
            defer { isCapturing = false }
            do {
                capturedImage = try await camera.capturePhoto()
            } catch {
                errorMessage = "Failed to capture photo.\n\(error.localizedDescription)"
            }
        }
    }
}

/// Lets the capture mode drive a `.sheet(item:)` presentation.
extension CaptureMode: Identifiable {
    public var id: String { rawValue }
}

#Preview {
    CameraScreen(captureMode: .photo)
}
