//
//  TQPlayerView.m
//  TQPlayer
//
//  Created by qfu on 3/28/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/CABase.h>

static void * BBAPlayerViewPlayerContext = &BBAPlayerViewPlayerContext;
static void * BBAPlayerViewPlayerItemContext = &BBAPlayerViewPlayerItemContext;

@interface TQPlayerView()

@property (nonatomic,assign) TQPlayerViewStatus playerViewStatus;
@property (nonatomic,strong) NSURL *loadedURL;
//private
@property (nonatomic,strong) id periodicTimeObserver;

@end

@implementation TQPlayerView

+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setPlayerViewStatus:TQPlayerViewStatusUnknown];
        [self setBufferSeconds:2.0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPlayerViewStatus:TQPlayerViewStatusUnknown];
        [self setBufferSeconds:2.0];
    }
    return self;
}

- (void)dealloc{
    AVPlayer *player = [self player];
    [self removeObserverToPlayer:player];
}

#pragma mark - Set

- (void)setPlayerViewStatus:(TQPlayerViewStatus)playerViewStatus{
    if (_playerViewStatus != playerViewStatus) {
        _playerViewStatus = playerViewStatus;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: statusChange:)]) {
                [self.delegate playerView:self statusChange:playerViewStatus];
            }
        });
    }
}

#pragma mark - Public

- (void)playURL:(NSURL *)URL{
    if (URL == nil) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: willLoadURL:)]) {
        [self.delegate playerView:self willLoadURL:URL];
    }
    
    AVPlayer *player = [self player];
    
    if (player) {
        [self removeObserverToPlayer:player];
        [self setPlayer:nil];
    }
    
    AVAsset *asset = [AVAsset assetWithURL:URL];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    
    [self setPlayer:player];
    [self addObserverToPlayer:player];
    
    [self setLoadedURL:URL];
    [self setPlayerViewStatus:TQPlayerViewStatusLoadedURL];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: didLoadURL:)]) {
        [self.delegate playerView:self didLoadURL:URL];
    }
}

- (void)play{
    AVPlayer *player = [self player];
    
    if (player == nil) {
        return;
    }
    
    if (player.status == AVPlayerStatusReadyToPlay) {
        [self.player play];
        [self setPlayerViewStatus:TQPlayerViewStatusPlay];
    }
}

- (void)pause{
    AVPlayer *player = [self player];
    
    if (player == nil) {
        return;
    }
    
    if (player.status == AVPlayerStatusReadyToPlay) {
        [self.player pause];
        [self setPlayerViewStatus:TQPlayerViewStatusPause];
    }
}

- (void)seekToSeconds:(Float64)seconds completionHandler:(void (^)(BOOL finished))completionHandler{
    AVPlayer *player = [self player];
    
    if (player == nil) {
        return;
    }
    
    if (player.status == AVPlayerStatusReadyToPlay) {
        [player seekToTime:CMTimeMakeWithSeconds(seconds,60000) completionHandler:completionHandler];
    }
}

- (Float64)duration{
    if ([self player] && [self player].currentItem) {
        Float64 duration = CMTimeGetSeconds([self player].currentItem.duration);
        if (!isnan(duration)) {
            return duration;
        }
    }
    return 0.0;
}

- (Float64)currentTime{
    if ([self player]) {
        Float64 time = CMTimeGetSeconds([self player].currentTime);
        if (!isnan(time)) {
            return time;
        }
    }
    return 0.0f;
}

- (Float64)currentLoadedTime{
    if ([self player] && [self player].currentItem && [self player].currentItem.loadedTimeRanges) {
        NSArray *loadedTimeRanges = self.player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        double startSeconds = CMTimeGetSeconds(timeRange.start);
        double durationSeconds = CMTimeGetSeconds(timeRange.duration);
        return startSeconds + durationSeconds;
    }
    return 0.0f;
}

- (CGSize)presentationSize{
    CGSize presentationSize = CGSizeZero;
    if ([self player] && [self player].currentItem && [self player].status == AVPlayerStatusReadyToPlay){
        presentationSize = self.player.currentItem.presentationSize;
    }
    return presentationSize;
}

- (BOOL)playbackBufferEmpty
{
    if ([self player] && [self player].currentItem) {
        return [self player].currentItem.playbackBufferEmpty;
    }
    return NO;
}

- (BOOL)playbackLikelyToKeepUp
{
    if ([self player] && [self player].currentItem) {
        return [self player].currentItem.playbackLikelyToKeepUp;
    }
    return NO;
}

#pragma mark - AVPlayer

- (AVPlayer*)player{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

#pragma mark - Observer AVPlayer

- (void)addObserverToPlayer:(AVPlayer *)player{
    if (player == nil) {
        return;
    }
    
    [player addObserver:self
             forKeyPath:NSStringFromSelector(@selector(status))
                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                context:BBAPlayerViewPlayerContext];
    [player addObserver:self
             forKeyPath:NSStringFromSelector(@selector(rate))
                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                context:BBAPlayerViewPlayerContext];
    AVPlayerItem *playerItem = [player currentItem];
    if (playerItem) {
        [self addObserverToPlayerItem:playerItem];
    }
    __weak typeof(self) weakSelf = self;
    self.periodicTimeObserver =
    [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
        [weakSelf progressChangeTime:time];
    }];
}

- (void)removeObserverToPlayer:(AVPlayer *)player{
    if (player == nil) {
        return;
    }
    
    @try {[player removeObserver:self forKeyPath:NSStringFromSelector(@selector(status))];}@catch (NSException *exception) {}
    @try {[player removeObserver:self forKeyPath:NSStringFromSelector(@selector(rate))];}@catch (NSException *exception) {}
    
    AVPlayerItem *playerItem = [player currentItem];
    if (playerItem) {
        [self removeObserverToPlayerItem:playerItem];
    }
    
    [player removeTimeObserver:self.periodicTimeObserver];
}

#pragma mark - Observer AVPlayerItem

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    if (playerItem == nil) {
        return;
    }
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(duration))
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:BBAPlayerViewPlayerItemContext];
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(presentationSize))
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:BBAPlayerViewPlayerItemContext];
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges))
                    options:NSKeyValueObservingOptionNew
                    context:BBAPlayerViewPlayerItemContext];
    [playerItem addObserver:self
                 forKeyPath:@"playbackLikelyToKeepUp"
                    options:NSKeyValueObservingOptionNew
                    context:BBAPlayerViewPlayerItemContext];
    [playerItem addObserver:self
                 forKeyPath:@"playbackBufferEmpty"
                    options:NSKeyValueObservingOptionNew
                    context:BBAPlayerViewPlayerItemContext];
    [playerItem addObserver:self
                 forKeyPath:@"playbackBufferFull"
                    options:NSKeyValueObservingOptionNew
                    context:BBAPlayerViewPlayerItemContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
}

- (void)removeObserverToPlayerItem:(AVPlayerItem *)playerItem{
    if (playerItem == nil) {
        return;
    }
    @try {[playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(duration))];}@catch (NSException *exception) {}
    @try {[playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(presentationSize))];}@catch (NSException *exception) {}
    @try {[playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges))];}@catch (NSException *exception) {}
    @try {[playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];}@catch (NSException *exception) {}
    @try {[playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];}@catch (NSException *exception) {}
    @try {[playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];}@catch (NSException *exception) {}
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:playerItem];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSString*, id> *)change
                       context:(nullable void *)context{
    id newObj = [change objectForKey:NSKeyValueChangeNewKey];
    id oldObj = [change objectForKey:NSKeyValueChangeOldKey];
    
    if (context == BBAPlayerViewPlayerContext){
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(status))]){
            AVPlayerStatus new = [newObj integerValue];
            AVPlayerStatus old = [oldObj integerValue];
            if (new != old) {
                [self statusChangeWithPlayer:object new:new old:old];
            }
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(rate))]){
            float new = [newObj floatValue];
            float old = [oldObj floatValue];
            if (new != old) {
                [self rateChangeWithPlayer:object new:new old:old];
            }
        }
    } else if (context == BBAPlayerViewPlayerItemContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(duration))]){
            CMTime new = [newObj CMTimeValue];
            CMTime old = [oldObj CMTimeValue];
            [self durationChangeWithPlayerItem:object new:new old:old];
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(presentationSize))]){
            CGSize new = [newObj CGSizeValue];
            CGSize old = [newObj CGSizeValue];
            [self presentationSizeChangeWithPlayerItem:object new:new old:old];
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(loadedTimeRanges))]){
            NSArray *loadedTimeRanges = [change objectForKey:NSKeyValueChangeNewKey];
            if (loadedTimeRanges && loadedTimeRanges.count > 0) {
                CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
                [self loadedTimeRangeChangeWithPlayerItem:object loadedTimeRange:timeRange];
            }
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
            BOOL value = [newObj boolValue];
            [self playbackLikelyToKeepUpChangeWithPlayerItem:object isPlaybackLikelyToKeepUp:value];
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
            BOOL value = [newObj boolValue];
            [self playbackBufferEmptyChangeWithPlayerItem:object isPlaybackBufferEmpty:value];
        } else if ([keyPath isEqualToString:@"playbackBufferFull"]){
            BOOL value = [newObj boolValue];
            [self playbackBufferFullChangeWithPlayerItem:object isPlaybackBufferFull:value];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - NSKeyValueObserving AVPlayer

- (void)statusChangeWithPlayer:(AVPlayer *)player new:(AVPlayerStatus)new old:(AVPlayerStatus)old{
    if (new == AVPlayerStatusUnknown) {
        
    } else if (new == AVPlayerStatusReadyToPlay) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerViewReadyToPlay:)]) {
            [self.delegate playerViewReadyToPlay:self];
        }
        [self setPlayerViewStatus:TQPlayerViewStatusReadyToPlay];
        [self play];
    } else if (new == AVPlayerStatusFailed) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerViewStateFailed: error:)]) {
            [self.delegate playerViewStateFailed:self error:player.error];
        }
        [self setPlayerViewStatus:TQPlayerViewStatusFailed];
    }
}

- (void)rateChangeWithPlayer:(AVPlayer *)player new:(float)new old:(float)old{
    
}

- (void)progressChangeTime:(CMTime)time{
    Float64 progress = CMTimeGetSeconds(time);
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: playingProgress:)]) {
        [self.delegate playerView:self playingProgress:progress];
    }
}

#pragma mark - NSKeyValueObserving AVPlayerItem

- (void)durationChangeWithPlayerItem:(AVPlayerItem *)playerItem new:(CMTime)new old:(CMTime)old{
    Float64 newSeconds = CMTimeGetSeconds(new);
    Float64 oldSeconds = CMTimeGetSeconds(old);
    
    if (newSeconds != oldSeconds) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: durationChange:)]) {
            [self.delegate playerView:self durationChange:newSeconds];
        }
    }
}

- (void)presentationSizeChangeWithPlayerItem:(AVPlayerItem *)playerItem new:(CGSize)new old:(CGSize)old{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: presentationSizeChange:)]) {
        [self.delegate playerView:self presentationSizeChange:new];
    }
}

- (void)loadedTimeRangeChangeWithPlayerItem:(AVPlayerItem *)playerItem loadedTimeRange:(CMTimeRange)loadedTimeRange{
    AVPlayer *player = [self player];
    if (player == nil) {
        return;
    }
    
    Float64 startSeconds = CMTimeGetSeconds(loadedTimeRange.start);
    Float64 durationSeconds = CMTimeGetSeconds(loadedTimeRange.duration);
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: loadedTimeStart: loadedTimeDuration:)]) {
        [self.delegate playerView:self loadedTimeStart:startSeconds loadedTimeDuration:durationSeconds];
    }
    
    //如果当前PlayerViewStatus的状态是播放状态时，AVPlayer的rate值为0.0.说明是缓冲的buffer不足导致.
    //在缓冲buffer满足最小缓冲buffer后，重新设置rate的值为1.0.
    if (player.rate == 0.0 && self.playerViewStatus == TQPlayerViewStatusPlay) {
        if (durationSeconds > self.bufferSeconds) {
            player.rate = 1.0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: isBufferingForPlay:)]) {
                [self.delegate playerView:self isBufferingForPlay:NO];
            }
        }
    }
    
    //缓冲到视频末端
    Float64 totalDuration = CMTimeGetSeconds(playerItem.duration);
    if ((startSeconds + durationSeconds) >= totalDuration) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerViewLoadedToEndTime:)]) {
            [self.delegate playerViewLoadedToEndTime:self];
        }
    }
}

- (void)playbackLikelyToKeepUpChangeWithPlayerItem:(AVPlayerItem *)playerItem isPlaybackLikelyToKeepUp:(BOOL)isPlaybackLikelyToKeepUp{
    if (isPlaybackLikelyToKeepUp) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: isBufferingForPlay:)]) {
            [self.delegate playerView:self isBufferingForPlay:NO];
        }
    }
}

- (void)playbackBufferEmptyChangeWithPlayerItem:(AVPlayerItem *)playerItem isPlaybackBufferEmpty:(BOOL)isEmpty{
    if (isEmpty) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView: isBufferingForPlay:)]) {
            [self.delegate playerView:self isBufferingForPlay:YES];
        }
    }
}

- (void)playbackBufferFullChangeWithPlayerItem:(AVPlayerItem *)playerItem isPlaybackBufferFull:(BOOL)isFull{
    NSLog(@"AVPlayerItem isPlaybackBufferFull = %d",isFull);
    
}

- (void)playerItemDidPlayToEndTime:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerViewDidPlayToEndTime:)]) {
        [self.delegate playerViewDidPlayToEndTime:self];
    }
    [self setPlayerViewStatus:TQPlayerViewStatusPlayToEndTime];
}

@end
