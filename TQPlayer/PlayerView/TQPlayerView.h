//
//  TQPlayerView.h
//  TQPlayer
//
//  Created by qfu on 3/28/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TQPlayerViewStatus) {
    TQPlayerViewStatusUnknown,
    TQPlayerViewStatusLoadedURL,
    TQPlayerViewStatusReadyToPlay,
    TQPlayerViewStatusPlay,
    TQPlayerViewStatusPause,
    TQPlayerViewStatusPlayToEndTime,
    TQPlayerViewStatusFailed
};

@protocol TQPlayerViewDelegate;

@interface TQPlayerView : UIView

@property (nonatomic,assign,readonly) TQPlayerViewStatus playerViewStatus;
@property (nonatomic,strong,readonly) NSURL *loadedURL;
@property (nonatomic,weak) id<TQPlayerViewDelegate> delegate;
@property (nonatomic,assign) double bufferSeconds; //default 2.0 seconds

- (void)playURL:(NSURL *)URL;
- (void)play;
- (void)pause;
- (void)seekToSeconds:(Float64)seconds completionHandler:(void (^)(BOOL finished))completionHandler;
- (Float64)duration;
- (Float64)currentTime;
- (Float64)currentLoadedTime;
- (CGSize)presentationSize;
- (BOOL)playbackBufferEmpty;
- (BOOL)playbackLikelyToKeepUp;

@end

@protocol TQPlayerViewDelegate<NSObject>

@optional
- (void)playerView:(TQPlayerView *)playerView willLoadURL:(NSURL *)URL;
- (void)playerView:(TQPlayerView *)playerView didLoadURL:(NSURL *)URL;
- (void)playerViewReadyToPlay:(TQPlayerView *)playerView;
- (void)playerViewStateFailed:(TQPlayerView *)playerView error:(NSError *)error;
- (void)playerView:(TQPlayerView *)playerView statusChange:(TQPlayerViewStatus)status;
- (void)playerView:(TQPlayerView *)playerView playingProgress:(Float64)progress;
- (void)playerView:(TQPlayerView *)playerView loadedTimeStart:(Float64)start loadedTimeDuration:(Float64)duration;
- (void)playerViewLoadedToEndTime:(TQPlayerView *)playerView;
- (void)playerViewDidPlayToEndTime:(TQPlayerView *)playerView;
- (void)playerView:(TQPlayerView *)playerView durationChange:(Float64)durationChange;
- (void)playerView:(TQPlayerView *)playerView presentationSizeChange:(CGSize)presentationSize;
- (void)playerView:(TQPlayerView *)playerView isBufferingForPlay:(BOOL)isBufferingForPlay;

@end