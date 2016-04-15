//
//  TQPlayerPanelProtocol.h
//  TQPlayer
//
//  Created by qfu on 4/2/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TQPlayerPanelDelegate <NSObject>

@optional;
- (void)playerPanelPlayEvent;
- (void)playerPanelPauseEvent;
- (void)playerPanelCloseEvent;
- (void)playerPanelSeekToProgress:(double)progress completionHandler:(void (^)(BOOL finished))completionHandler;

- (void)playerPanelMiniScreenEvent;
- (void)playerPanelFullScreenEvent;

@end

@protocol TQPlayerPanelProtocol <NSObject>

@property (nonatomic,weak) id<TQPlayerPanelDelegate> delegate;
@property (nonatomic,assign,readonly) BOOL playPanelHidden;

- (void)updatePlayPanelWithLive:(BOOL)isLive;
- (void)updatePlayPanelWithLoading:(BOOL)isLoading;
- (void)updatePlayPanelWithPlaying:(BOOL)isPlaying;
- (void)updatePlayPanelWithDuration:(double)duration downloadProgress:(double)downloadProgress;
- (void)updatePlayPanelWithDuration:(double)duration playingProgress:(double)playingProgress;
- (void)showPlayPanelWithAnimationCompletion:(void (^)(BOOL finished))completion;
- (void)hiddenPlayPanelWithAnimationCompletion:(void (^)(BOOL finished))completion;

@end
