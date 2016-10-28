# Overview

This project demonstrates the AVPlayer bug in ios 10 documented in the following places:

http://www.openradar.me/28553945

https://forums.developer.apple.com/thread/62521

http://stackoverflow.com/questions/39560386/avplayer-playback-fails-while-avassetexportsession-is-active-as-of-ios-10?noredirect=1#comment67875901_39560386

# Instructions
Run the app (on device, not simluator). Press the `Export Video` button, wait for the completion to be logged. Then press the `Load Player` button a few times until the video goes blank. If it doesn't happen in your first session, rebuild and try again. Happens in the majority of sessions when testing on my iPhone 7 and iPhone 5s.

# Bug description
After running an AVAssetExportSession that includes the use of `AVVideoCompositionCoreAnimationTool`, videos displayed with AVPlayer will randomly go blank for a time while the audio continues.
