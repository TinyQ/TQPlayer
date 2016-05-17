# TQPlayer

##Demo
![](https://raw.github.com/TinyQ/TQPlayer/master/README_IMG/1.1.PNG)
![](https://raw.github.com/TinyQ/TQPlayer/master/README_IMG/1.2.PNG)
![](https://raw.github.com/TinyQ/TQPlayer/master/README_IMG/1.3.PNG)

![](https://raw.github.com/TinyQ/TQPlayer/master/README_IMG/2.1.PNG)

![](https://raw.github.com/TinyQ/TQPlayer/master/README_IMG/2.2.PNG)

![](https://raw.github.com/TinyQ/TQPlayer/master/README_IMG/2.3.PNG)

##Introduction
TQPlayer is a video player base on `AVPlayer`.Support witch full & mini screen play. Support brightness, volume, and the playback progress gestures. TQPlayer is a Singleton, using the video player in globally is suitable.

##Features

* Support horizontal and vertical screen switch.
* Support full and mini screen switch.
* Supports gestures to adjust brightness, and sound playback progress

Screen brightness and volume do not play in the simulator 

##Installation

###CocoaPods

1.	Add `pod 'TQPlayer'` to your Podfile.
2.	Run `pod install` or pod update.
3.	Import `<TQPlayer/TQPlayer.h>`.

###Carthage

1.	Add `github "tinyq/TQPlayer"` to your Cartfile.
2.	Run `carthage update --platform ios` and add the framework to your project.
3.	Import `<TQPlayer/TQPlayer.h>`.

##Requirements

This library requires `iOS 8.0` and `Xcode 7.0`.

##License
TQPlayer is provided under the MIT license. See LICENSE file for details.



# 介绍
TQPlayer 是一个基于 `AVPlayer` 构建的视频播放器。主要支持全屏幕与小窗口的视频播放，亮度、音量与播放进度的手势调节。TQPlayer 在单独 `UIWindow` 窗口承载的播放器。适合项目中进行全局使用的视频播放器。

##特性

* 支持切换横屏、竖屏以及小窗口模式。
* 支持全屏幕与小窗口模式下屏幕旋转。
* 支持使用手势调节亮度、声音以及播放进度。

屏幕亮度与播放音量请在真机下调试。

##安装

###CocoaPods

1.	在 Podfile 中添加 `pod 'TQPlayer'`。
2.	执行 `pod install` 或 `pod update`。
3.	导入 `<TQPlayer/TQPlayer.h>`。

###Carthage

1.	在 Cartfile 中添加 `github "tinyq/TQPlayer"`。
2.	执行 `carthage update --platform ios` 并将生成的 framework 添加到你的工程。
3.	导入 `<TQPlayer/TQPlayer.h>`。

##系统要求

该项目最低支持 `iOS 8.0` 和 `Xcode 7.0`。

##许可证
TQPlayer 使用 MIT 许可证，详情见 LICENSE 文件。


