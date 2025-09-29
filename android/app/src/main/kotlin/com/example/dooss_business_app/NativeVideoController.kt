package com.example.dooss_business_app

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import androidx.media3.common.MediaItem
import androidx.media3.common.Player
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeVideoController(
    private val context: Context,
    private val messenger: MethodChannel,
    private val id: Int,
    private val creationParams: Map<String?, Any?>?
) : PlatformView, MethodChannel.MethodCallHandler {

    private var playerView: PlayerView? = null
    private var player: ExoPlayer? = null
    private var currentVideoUrl: String? = null
    private var isPlaying = false
    private var isInitialized = false

    init {
        messenger.setMethodCallHandler(this)
        initializePlayer()
    }

    private fun initializePlayer() {
        try {
            // Create PlayerView
            playerView = PlayerView(context).apply {
                useController = false // Hide default controls
                setShowBuffering(PlayerView.SHOW_BUFFERING_WHEN_PLAYING)
            }

            // Create ExoPlayer
            player = ExoPlayer.Builder(context).build().apply {
                repeatMode = Player.REPEAT_MODE_ONE // Loop video
                addListener(object : Player.Listener {
                    override fun onPlaybackStateChanged(playbackState: Int) {
                        when (playbackState) {
                            Player.STATE_READY -> {
                                isInitialized = true
                                messenger.invokeMethod("onVideoReady", null)
                            }
                            Player.STATE_ENDED -> {
                                messenger.invokeMethod("onVideoEnded", null)
                            }
                            Player.STATE_BUFFERING -> {
                                messenger.invokeMethod("onVideoBuffering", null)
                            }
                        }
                    }

                    override fun onPlayerError(error: androidx.media3.common.PlaybackException) {
                        messenger.invokeMethod("onVideoError", error.message)
                    }
                })
            }

            // Set player to PlayerView
            playerView?.player = player

            isInitialized = true
            println("🎬 NativeVideoController: Player initialized successfully")

        } catch (e: Exception) {
            println("❌ NativeVideoController: Error initializing player: ${e.message}")
            messenger.invokeMethod("onVideoError", "Failed to initialize player: ${e.message}")
        }
    }

    override fun getView(): View {
        return playerView ?: FrameLayout(context)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadVideo" -> {
                val videoUrl = call.argument<String>("url")
                if (videoUrl != null) {
                    loadVideo(videoUrl)
                    result.success(true)
                } else {
                    result.error("INVALID_URL", "Video URL is required", null)
                }
            }
            "play" -> {
                play()
                result.success(true)
            }
            "pause" -> {
                pause()
                result.success(true)
            }
            "stop" -> {
                stop()
                result.success(true)
            }
            "dispose" -> {
                disposePlayer()
                result.success(true)
            }
            "isPlaying" -> {
                result.success(isPlaying)
            }
            "isInitialized" -> {
                result.success(isInitialized)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun loadVideo(videoUrl: String) {
        try {
            println("🎬 NativeVideoController: Loading video: $videoUrl")
            
            if (currentVideoUrl == videoUrl && player?.playbackState == Player.STATE_READY) {
                println("🎬 NativeVideoController: Video already loaded and ready")
                return
            }

            currentVideoUrl = videoUrl
            
            // Create MediaItem
            val mediaItem = MediaItem.fromUri(videoUrl)
            
            // Set media item to player
            player?.apply {
                setMediaItem(mediaItem)
                prepare()
            }

            println("✅ NativeVideoController: Video loaded successfully")

        } catch (e: Exception) {
            println("❌ NativeVideoController: Error loading video: ${e.message}")
            messenger.invokeMethod("onVideoError", "Failed to load video: ${e.message}")
        }
    }

    private fun play() {
        try {
            if (player != null && isInitialized) {
                player?.play()
                isPlaying = true
                println("▶️ NativeVideoController: Video playing")
                messenger.invokeMethod("onVideoPlay", null)
            } else {
                println("⚠️ NativeVideoController: Cannot play - player not ready")
            }
        } catch (e: Exception) {
            println("❌ NativeVideoController: Error playing video: ${e.message}")
        }
    }

    private fun pause() {
        try {
            if (player != null) {
                player?.pause()
                isPlaying = false
                println("⏸️ NativeVideoController: Video paused")
                messenger.invokeMethod("onVideoPause", null)
            }
        } catch (e: Exception) {
            println("❌ NativeVideoController: Error pausing video: ${e.message}")
        }
    }

    private fun stop() {
        try {
            if (player != null) {
                player?.stop()
                isPlaying = false
                println("⏹️ NativeVideoController: Video stopped")
                messenger.invokeMethod("onVideoStop", null)
            }
        } catch (e: Exception) {
            println("❌ NativeVideoController: Error stopping video: ${e.message}")
        }
    }

    private fun disposePlayer() {
        try {
            println("🗑️ NativeVideoController: Disposing player...")
            
            // Stop and release player
            player?.apply {
                stop()
                release()
            }
            player = null

            // Clear PlayerView
            playerView?.player = null
            playerView = null

            // Reset state
            currentVideoUrl = null
            isPlaying = false
            isInitialized = false

            println("✅ NativeVideoController: Player disposed successfully")
            messenger.invokeMethod("onPlayerDisposed", null)

        } catch (e: Exception) {
            println("❌ NativeVideoController: Error disposing player: ${e.message}")
        }
    }

    override fun dispose() {
        disposePlayer()
    }
}

class NativeVideoControllerFactory(private val messenger: MethodChannel) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String?, Any?>
        return NativeVideoController(context, messenger, viewId, creationParams)
    }
}
