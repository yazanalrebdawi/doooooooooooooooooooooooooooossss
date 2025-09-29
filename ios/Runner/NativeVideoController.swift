import Foundation
import AVKit
import Flutter

class NativeVideoController: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var currentVideoUrl: String?
    private var isPlaying = false
    private var isInitialized = false
    private var methodChannel: FlutterMethodChannel
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        methodChannel = FlutterMethodChannel(name: "native_video_controller_\(viewId)", binaryMessenger: messenger)
        super.init()
        
        setupMethodChannel()
        initializePlayer()
    }
    
    func view() -> UIView {
        return _view
    }
    
    private func setupMethodChannel() {
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            self?.handleMethodCall(call: call, result: result)
        }
    }
    
    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "loadVideo":
            if let args = call.arguments as? [String: Any],
               let videoUrl = args["url"] as? String {
                loadVideo(url: videoUrl)
                result(true)
            } else {
                result(FlutterError(code: "INVALID_URL", message: "Video URL is required", details: nil))
            }
            
        case "play":
            play()
            result(true)
            
        case "pause":
            pause()
            result(true)
            
        case "stop":
            stop()
            result(true)
            
        case "dispose":
            dispose()
            result(true)
            
        case "isPlaying":
            result(isPlaying)
            
        case "isInitialized":
            result(isInitialized)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializePlayer() {
        do {
            // Configure audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Create player layer
            playerLayer = AVPlayerLayer()
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.frame = _view.bounds
            
            if let playerLayer = playerLayer {
                _view.layer.addSublayer(playerLayer)
            }
            
            isInitialized = true
            print("🎬 NativeVideoController: Player initialized successfully")
            
        } catch {
            print("❌ NativeVideoController: Error initializing player: \(error.localizedDescription)")
            methodChannel.invokeMethod("onVideoError", arguments: "Failed to initialize player: \(error.localizedDescription)")
        }
    }
    
    private func loadVideo(url: String) {
        do {
            print("🎬 NativeVideoController: Loading video: \(url)")
            
            if currentVideoUrl == url && player?.currentItem?.status == .readyToPlay {
                print("🎬 NativeVideoController: Video already loaded and ready")
                return
            }
            
            currentVideoUrl = url
            
            // Create AVPlayerItem
            guard let videoURL = URL(string: url) else {
                throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
            }
            
            let playerItem = AVPlayerItem(url: videoURL)
            
            // Create or update player
            if player == nil {
                player = AVPlayer(playerItem: playerItem)
                playerLayer?.player = player
            } else {
                player?.replaceCurrentItem(with: playerItem)
            }
            
            // Add observer for player item status
            playerItem.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
            
            // Add observer for playback end
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: playerItem
            )
            
            print("✅ NativeVideoController: Video loaded successfully")
            
        } catch {
            print("❌ NativeVideoController: Error loading video: \(error.localizedDescription)")
            methodChannel.invokeMethod("onVideoError", arguments: "Failed to load video: \(error.localizedDescription)")
        }
    }
    
    private func play() {
        guard let player = player, isInitialized else {
            print("⚠️ NativeVideoController: Cannot play - player not ready")
            return
        }
        
        do {
            player.play()
            isPlaying = true
            print("▶️ NativeVideoController: Video playing")
            methodChannel.invokeMethod("onVideoPlay", arguments: nil)
        } catch {
            print("❌ NativeVideoController: Error playing video: \(error.localizedDescription)")
        }
    }
    
    private func pause() {
        guard let player = player else { return }
        
        do {
            player.pause()
            isPlaying = false
            print("⏸️ NativeVideoController: Video paused")
            methodChannel.invokeMethod("onVideoPause", arguments: nil)
        } catch {
            print("❌ NativeVideoController: Error pausing video: \(error.localizedDescription)")
        }
    }
    
    private func stop() {
        guard let player = player else { return }
        
        do {
            player.pause()
            player.seek(to: .zero)
            isPlaying = false
            print("⏹️ NativeVideoController: Video stopped")
            methodChannel.invokeMethod("onVideoStop", arguments: nil)
        } catch {
            print("❌ NativeVideoController: Error stopping video: \(error.localizedDescription)")
        }
    }
    
    private func dispose() {
        print("🗑️ NativeVideoController: Disposing player...")
        
        // Remove observers
        if let playerItem = player?.currentItem {
            playerItem.removeObserver(self, forKeyPath: "status")
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
        
        // Stop and clear player
        player?.pause()
        player = nil
        
        // Remove player layer
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        
        // Reset state
        currentVideoUrl = nil
        isPlaying = false
        isInitialized = false
        
        print("✅ NativeVideoController: Player disposed successfully")
        methodChannel.invokeMethod("onPlayerDisposed", arguments: nil)
    }
    
    @objc private func playerDidFinishPlaying() {
        print("🔄 NativeVideoController: Video finished playing")
        methodChannel.invokeMethod("onVideoEnded", arguments: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let playerItem = object as? AVPlayerItem {
                switch playerItem.status {
                case .readyToPlay:
                    print("✅ NativeVideoController: Video ready to play")
                    methodChannel.invokeMethod("onVideoReady", arguments: nil)
                case .failed:
                    print("❌ NativeVideoController: Video failed to load")
                    methodChannel.invokeMethod("onVideoError", arguments: playerItem.error?.localizedDescription ?? "Unknown error")
                case .unknown:
                    print("⏳ NativeVideoController: Video status unknown")
                    methodChannel.invokeMethod("onVideoBuffering", arguments: nil)
                @unknown default:
                    break
                }
            }
        }
    }
    
    deinit {
        dispose()
    }
}

class NativeVideoControllerFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NativeVideoController(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
