//
//  TQPlayerViewController.m
//  TQPlayer
//
//  Created by qfu on 3/30/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerViewController.h"
#import "TQPlayerHelper.h"
#import "TQPlayerPanelProtocol.h"
#import "TQPlayerFullScreenPanel.h"
#import "TQPlayerMiniScreenPanel.h"
#import "TQPlayerViewGestureRecognizer.h"
#import "TQPlayerBrightness.h"
#import "TQPlayerResources.h"
@import MediaPlayer;

@interface TQPlayerViewController() <TQPlayerViewDelegate,TQPlayerPanelDelegate,TQPlayerViewGestureRecognizerDelegate>

@property (nonatomic,assign) TQPlayerViewControllerMode mode;
@property (nonatomic,strong) TQPlayerView *playerView;
@property (nonatomic,strong) TQPlayerFullScreenPanel *fullScreenPanel;
@property (nonatomic,strong) TQPlayerMiniScreenPanel *miniScreenPanel;
@property (nonatomic,strong) TQPlayerViewGestureRecognizer *playerViewGestureRecognizer;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) TQPlayerCountdownTrigger *countdownTrigger;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isLive;
//private
@property (nonatomic,assign) BOOL isLoadingAnimating;
@property (nonatomic,assign) double currentSeekTime;
@property (nonatomic,weak) NSTimer *timer;

@end

@implementation TQPlayerViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        _mode = TQPlayerViewControllerFullScreenMode;
    }
    return self;
}

- (void)dealloc{
    if (self.countdownTrigger) {
        [self.countdownTrigger invalidate];
        self.countdownTrigger = nil;
    }

    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadPlayerViewWithMode:TQPlayerViewControllerFullScreenMode];
    [self loadPanelViewWithMode:TQPlayerViewControllerFullScreenMode];
    [self.playerViewGestureRecognizer setEnabled:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.countdownTrigger reset];
    [self.countdownTrigger resume];
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(timerTick:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.countdownTrigger pause];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (BOOL)shouldAutorotate{
    if (self.mode == TQPlayerViewControllerFullScreenMode) {
        //全屏播放，应该支持个个方向。
        return YES;
    } else if(self.mode == TQPlayerViewControllerMiniScreenMode) {
        //小窗播放，应该根据状态栏方向，来保持小窗方向与UI界面方向统一。在TQPlayer里处理
        return NO;
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Public

- (void)playURL:(NSURL *)URL{
    [self playURL:URL live:NO];
}

- (void)playURL:(NSURL *)URL live:(BOOL)live{
    if (URL == nil) {
        return;
    }
    
    if (self.playerView == nil) {
        return;
    }
    
    self.isLive = live;
    [self.playerView playURL:URL];
}

- (void)play{
    if (self.playerView == nil) {
        return;
    }
    
    if (self.playerView.playerViewStatus == TQPlayerViewStatusPause) {
        [self.playerView play];
    }
    
    if (self.playerView.playerViewStatus == TQPlayerViewStatusPlayToEndTime) {
        __weak TQPlayerView *weakPlayer = self.playerView;
        [self.playerView seekToSeconds:0.0 completionHandler:^(BOOL finished) {
            [weakPlayer play];
        }];
    }
}

- (void)pause{
    if (self.playerView == nil) {
        return;
    }
    
    if (self.playerView.playerViewStatus == TQPlayerViewStatusPlay) {
        [self.playerView pause];
    }
}

#pragma mark - get & set

- (TQPlayerView *)playerView{
    if (_playerView == nil) {
        _playerView = [[TQPlayerView alloc] init];
        _playerView.backgroundColor = [UIColor blackColor];
        _playerView.delegate = self;
    }
    return _playerView;
}

- (TQPlayerFullScreenPanel *)fullScreenPanel{
    if (_fullScreenPanel == nil) {
        _fullScreenPanel = [[TQPlayerFullScreenPanel alloc] init];
    }
    return _fullScreenPanel;
}

- (TQPlayerMiniScreenPanel *)miniScreenPanel{
    if (_miniScreenPanel == nil) {
        _miniScreenPanel = [[TQPlayerMiniScreenPanel alloc] init];
    }
    return _miniScreenPanel;
}

- (TQPlayerViewGestureRecognizer *)playerViewGestureRecognizer{
    if (_playerViewGestureRecognizer == nil) {
        _playerViewGestureRecognizer = [[TQPlayerViewGestureRecognizer alloc] initWithPlayerView:self.playerView];
        _playerViewGestureRecognizer.delegate = self;
    }
    return _playerViewGestureRecognizer;
}

- (UIActivityIndicatorView *)activityIndicatorView{
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activityIndicatorView;
}

- (TQPlayerCountdownTrigger *)countdownTrigger{
    if (_countdownTrigger == nil) {
        _countdownTrigger = [[TQPlayerCountdownTrigger alloc] initWithTarget:self
                                                                    selector:@selector(countdownTriggerTimeUp:)
                                                                   tickTimes:5
                                                                    tickUnit:TQTimeSecond
                                                                     repeats:YES];
    }
    return _countdownTrigger;
}

#pragma mark - private

- (void)loadPlayerViewWithMode:(TQPlayerViewControllerMode)mode{
    if (mode == TQPlayerViewControllerFullScreenMode) {
        self.playerView.frame = self.view.bounds;
        self.playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        CGRect frame = CGRectZero;
        frame.size = [[self class] sizeOfPlayerViewInMiniMode:self.playerView];
        self.playerView.frame = frame;
        self.playerView.center = self.view.center;
        self.playerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    if (!self.playerView.superview) {
        self.activityIndicatorView.center = self.playerView.center;
        self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.playerView addSubview:self.activityIndicatorView];
        [self.view addSubview:self.playerView];
    }
}

- (void)loadPanelViewWithMode:(TQPlayerViewControllerMode)mode{
    UIView<TQPlayerPanelProtocol> *panelView = nil;
    if (mode == TQPlayerViewControllerFullScreenMode) {
        panelView = self.fullScreenPanel;
    } else {
        panelView = self.miniScreenPanel;
    }
    panelView.delegate = self;
    [self.view addSubview:panelView];
    panelView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:panelView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.playerView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:panelView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.playerView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:panelView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.playerView
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:panelView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.playerView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:0],]];
}

- (UIView<TQPlayerPanelProtocol> *)currentPanel{
    if (self.mode == TQPlayerViewControllerFullScreenMode) {
        return self.fullScreenPanel;
    } else {
        return self.miniScreenPanel;
    }
}

+ (CGSize)sizeOfPlayerViewInMiniMode:(TQPlayerView *)playerView{
    CGSize size = kDefaultSizeOfPlayerViewInMiniMode;
    
    if (!CGSizeEqualToSize([playerView presentationSize], CGSizeZero)){
        CGSize presentationSize = [playerView presentationSize];
        size = CGSizeMake(size.width,
                          size.width * presentationSize.height / presentationSize.width);
    }
    return size;
}

+ (void)fitMiniModePlayerViewToScreenWidth:(TQPlayerView *)playerView{
    CGSize naturalSize = [playerView presentationSize];
    
    if (CGSizeEqualToSize(naturalSize, CGSizeZero)) {
        return;
    }
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    CGRect frame = playerView.frame;
    
    frame.origin.x    = 0;
    frame.origin.y    = 20;
    frame.size.width  = screenWidth;
    frame.size.height = screenWidth * naturalSize.height / naturalSize.width;
    
    [UIView animateWithDuration:0.25 animations:^{
        playerView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)transformToMiniScreenModeWithAnimateCompletion:(void (^)(void))completion{
    if (self.mode == TQPlayerViewControllerMiniScreenMode) {
        return;
    }
    
    UIInterfaceOrientation statusBarOrientation  = [UIApplication sharedApplication].statusBarOrientation;
    UIInterfaceOrientation normalLevelWindowOrientation = [TQPlayerHelper currentInterfaceOrientationFromWindow:[TQPlayerHelper normalLevelWindow]];
    CGFloat radians = [TQPlayerHelper degreesFromOrientation:statusBarOrientation toOrientation:normalLevelWindowOrientation];
    CGSize miniPlayerSize = [[self class] sizeOfPlayerViewInMiniMode:self.playerView];
    [UIView animateWithDuration:0.35 animations:^{
        self.playerView.frame = CGRectMake(0, 0, miniPlayerSize.width, miniPlayerSize.height);
        self.playerView.center = self.view.center;
        self.playerView.transform = CGAffineTransformRotate(self.playerView.transform, TQPlayerDegreesToRadians(radians));
        [self currentPanel].alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.playerView.transform = CGAffineTransformRotate(self.playerView.transform, TQPlayerDegreesToRadians(-radians));
        [self currentPanel].alpha = 1;
        [[self currentPanel] removeFromSuperview];
        [self loadPlayerViewWithMode:TQPlayerViewControllerMiniScreenMode];
        [self loadPanelViewWithMode:TQPlayerViewControllerMiniScreenMode];
        [self setMode:TQPlayerViewControllerMiniScreenMode];
        [self updateCurrentPanelUI];
        if (completion) {
            completion();
        }
    }];
}

- (void)transformToFullScreenModeWithAnimateCompletion:(void (^)(void))completion{
    if (self.mode == TQPlayerViewControllerFullScreenMode) {
        return;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
        self.playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.playerView.center = self.view.center;
        [self currentPanel].alpha = 0;
    } completion:^(BOOL finished) {
        [self currentPanel].alpha = 1;
        [self currentPanel].hidden = NO;
        [[self currentPanel] removeFromSuperview];
        [self loadPlayerViewWithMode:TQPlayerViewControllerFullScreenMode];
        [self loadPanelViewWithMode:TQPlayerViewControllerFullScreenMode];
        [self setMode:TQPlayerViewControllerFullScreenMode];
        [self updateCurrentPanelUI];
        if (completion) {
            completion();
        }
    }];
}

- (void)updateCurrentPanelUI{
    [[self currentPanel] updatePlayPanelWithLive:self.isLive];
    [[self currentPanel] updatePlayPanelWithLoading:self.isLoadingAnimating];
    
    if (self.playerView.playerViewStatus == TQPlayerViewStatusPlay) {
        [[self currentPanel] updatePlayPanelWithPlaying:YES];
    }
    
    if (self.playerView.playerViewStatus == TQPlayerViewStatusPause || self.playerView.playerViewStatus == TQPlayerViewStatusFailed) {
        [[self currentPanel] updatePlayPanelWithPlaying:NO];
    }
    
    double duration = [self.playerView duration];
    double downloadProgress = [self.playerView currentLoadedTime];
    double playingProgress = [self.playerView currentTime];
    [[self currentPanel] updatePlayPanelWithDuration:duration downloadProgress:downloadProgress];
    [[self currentPanel] updatePlayPanelWithDuration:duration playingProgress:playingProgress];
}

- (void)startLoadingAnimating{
    [self.activityIndicatorView startAnimating];
    self.isLoadingAnimating = YES;
    [[self currentPanel] updatePlayPanelWithLoading:self.isLoadingAnimating];
}

- (void)stopLoadingAnimating{
    [self.activityIndicatorView stopAnimating];
    self.isLoadingAnimating = NO;
    [[self currentPanel] updatePlayPanelWithLoading:self.isLoadingAnimating];
}

#pragma mark - TQPlayerViewDelegate

- (void)playerView:(TQPlayerView *)playerView willLoadURL:(NSURL *)URL{
    [self startLoadingAnimating];
}

- (void)playerView:(TQPlayerView *)playerView didLoadURL:(NSURL *)URL{
    [self updateCurrentPanelUI];
}

- (void)playerViewReadyToPlay:(TQPlayerView *)playerView{

}

- (void)playerViewStateFailed:(TQPlayerView *)playerView error:(NSError *)error{
    
}

- (void)playerView:(TQPlayerView *)playerView statusChange:(TQPlayerViewStatus)status{
    
    switch (status) {
        case TQPlayerViewStatusUnknown:
            
            break;
        case TQPlayerViewStatusLoadedURL:
            
            break;
        case TQPlayerViewStatusReadyToPlay:
            
            break;
        case TQPlayerViewStatusPlay:
        {
            self.isPlaying = YES;
            [[self currentPanel] updatePlayPanelWithPlaying:YES];
        }
            break;
        case TQPlayerViewStatusPause:
        {
            [[self currentPanel] updatePlayPanelWithPlaying:NO];
        }
            break;
        case TQPlayerViewStatusPlayToEndTime:
            
            break;
        case TQPlayerViewStatusFailed:
        {
            [[self currentPanel] updatePlayPanelWithPlaying:YES];
        }
            break;
        default:
            break;
    }
    
    switch (status) {
        case TQPlayerViewStatusPlay:
        {
            self.isPlaying = YES;
        }
            break;
        default:
        {
            self.isPlaying = NO;
        }
            break;
    }
}

- (void)playerView:(TQPlayerView *)playerView playingProgress:(Float64)progress{
    if (self.playerViewGestureRecognizer.isFullScreenHorizontalTouch) {
        return;
    }
    [[self currentPanel] updatePlayPanelWithDuration:[playerView duration] playingProgress:progress];
}

- (void)playerView:(TQPlayerView *)playerView loadedTimeStart:(Float64)start loadedTimeDuration:(Float64)duration{
    [[self currentPanel] updatePlayPanelWithDuration:[playerView duration] downloadProgress:(start + duration)];
}

- (void)playerViewLoadedToEndTime:(TQPlayerView *)playerView{
    
}

- (void)playerViewDidPlayToEndTime:(TQPlayerView *)playerView{
    [[self currentPanel] updatePlayPanelWithPlaying:NO];
}

- (void)playerView:(TQPlayerView *)playerView durationChange:(Float64)durationChange{
    
}

- (void)playerView:(TQPlayerView *)playerView presentationSizeChange:(CGSize)presentationSize{
    
}

- (void)playerView:(TQPlayerView *)playerView isBufferingForPlay:(BOOL)isBufferingForPlay{
    if (isBufferingForPlay) {
        [self startLoadingAnimating];
    } else {
        [self stopLoadingAnimating];
    }
}

#pragma mark - TQPlayerPanelDelegate

- (void)playerPanelPlayEvent{
    [self play];
}

- (void)playerPanelPauseEvent{
    [self pause];
}

- (void)playerPanelCloseEvent{
    if (self.playerPanelCloseblock) {
        self.playerPanelCloseblock();
    }
}

- (void)playerPanelMiniScreenEvent{
    [self transformToMiniScreenModeWithAnimateCompletion:^{
        
    }];
}

- (void)playerPanelFullScreenEvent{
    [self transformToFullScreenModeWithAnimateCompletion:^{
       
    }];
}

- (void)playerPanelSeekToProgress:(double)progress completionHandler:(void (^)(BOOL finished))completionHandler{
    if (self.isLive) {
        return;
    }
    
    if (self.playerView){
        Float64 scends = [self.playerView duration] * progress;
        [self.playerView seekToSeconds:scends completionHandler:completionHandler];
    }
}

#pragma mark - TQPlayerViewGestureRecognizerDelegate

- (TQPlayerViewControllerMode)playerViewModeInRecognizer:(TQPlayerViewGestureRecognizer *)recognizer{
    return self.mode;
}

- (CGSize)minSizeOfPlayerViewInMiniMode{
    return kMinSizeOfPlayerViewInMiniMode;
}

- (CGSize)maxSizeOfPlayerViewInMiniMode{
    CGFloat max_w = self.view.bounds.size.width;
    CGFloat max_h = max_w * self.playerView.bounds.size.height / self.playerView.bounds.size.width;
    return CGSizeMake(max_w, max_h);;
}

- (void)playerViewRecognizer:(TQPlayerViewGestureRecognizer *)recognizer leftHalfVerticalTouchVariable:(float)variable oldVariable:(float)oldVariable recognizerState:(TQPlayerViewRecognizerState)state touching:(inout BOOL *)touching{
    switch (state) {
        case TQPlayerViewRecognizerStateBegan:
            
            break;
        case TQPlayerViewRecognizerStateChanged:
        {
            float offset = oldVariable - variable;
            [TQPlayerBrightness sharedBrightnessView].brightness = MAX(MIN(1.0, [TQPlayerBrightness sharedBrightnessView].brightness + offset), 0.0);
        }
            break;
        case TQPlayerViewRecognizerStateEnded:
            
            break;
        default:
            break;
    }
}

- (void)playerViewRecognizer:(TQPlayerViewGestureRecognizer *)recognizer rightHalfVerticalTouchVariable:(float)variable oldVariable:(float)oldVariable recognizerState:(TQPlayerViewRecognizerState)state touching:(inout BOOL *)touching{
    switch (state) {
        case TQPlayerViewRecognizerStateBegan:
            
            break;
        case TQPlayerViewRecognizerStateChanged:
        {
            float offset = oldVariable - variable;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
            float value = MAX(MIN(1.0, [MPMusicPlayerController applicationMusicPlayer].volume + offset), 0.0);
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:value];
#pragma clang diagnostic pop

        }
            break;
        case TQPlayerViewRecognizerStateEnded:
            
            break;
        default:
            break;
    }
}

- (void)playerViewRecognizer:(TQPlayerViewGestureRecognizer *)recognizer fullScreenHorizontalTouchVariable:(float)variable recognizerState:(TQPlayerViewRecognizerState)state touching:(inout BOOL *)touching{
    if (self.isLive) {
        return;
    }
    
    double seekTotleSeconds = 0;
    
    if ([self.playerView duration] <= 20 * 60){
        seekTotleSeconds = 60;
    }else{
        seekTotleSeconds = 10 * 60;
    }
    
    double seekSeconds = seekTotleSeconds * variable;
    
    switch (state) {
        case TQPlayerViewRecognizerStateBegan:
        {
            if ([self.playerView playbackLikelyToKeepUp]) {
                self.currentSeekTime = self.playerView.currentTime;
            }
            double seconds = MIN(self.playerView.duration, MAX(0, (self.currentSeekTime + seekSeconds)));
            [[self currentPanel] updatePlayPanelWithDuration:self.playerView.duration playingProgress:seconds];
        }
            break;
        case TQPlayerViewRecognizerStateChanged:
        {
            double seconds = MIN(self.playerView.duration, MAX(0, (self.currentSeekTime + seekSeconds)));
            [[self currentPanel] updatePlayPanelWithDuration:self.playerView.duration playingProgress:seconds];
        }
            break;
        case TQPlayerViewRecognizerStateEnded:
        {
            if (*touching == NO) {
                *touching = YES;
            }
            
            self.currentSeekTime = MIN(self.playerView.duration, MAX(0, (self.currentSeekTime + seekSeconds)));
            
            if (((self.currentSeekTime + seekSeconds) >= self.playerView.duration) || ((self.currentSeekTime + seekSeconds) < 0)){
                [self.playerView seekToSeconds:self.playerView.duration - 0.5 completionHandler:^(BOOL finished) {
                    *touching = NO;
                }];
            } else {
                [self.playerView seekToSeconds:self.currentSeekTime completionHandler:^(BOOL finished) {
                    *touching = NO;
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)playerViewRecognizerClicked{
    if (self.mode == TQPlayerViewControllerMiniScreenMode) {
        if (self.playerView.playerViewStatus == TQPlayerViewStatusPlay){
            [self pause];
        } else {
            [self play];
        }
    }
    
    if ([self currentPanel].playPanelHidden) {
        [[self currentPanel] showPlayPanelWithAnimationCompletion:^(BOOL finished) {
            
        }];
    } else {
        [[self currentPanel] hiddenPlayPanelWithAnimationCompletion:^(BOOL finished) {
            
        }];
    }
}

- (void)playerViewRecognizerDoubleClicked{
    if (self.mode == TQPlayerViewControllerMiniScreenMode) {
        [[self class] fitMiniModePlayerViewToScreenWidth:self.playerView];
    }
}

#pragma mark - TQPlayerCountdownTrigger

- (void)countdownTriggerTimeUp:(id)sender{
    [[self currentPanel] hiddenPlayPanelWithAnimationCompletion:^(BOOL finished) {
        
    }];
}

#pragma mark - Timer

- (void)timerTick:(id)sender{
    //当处于小窗模式时，如果应用中有浏览器调用系统播放器，会关闭TQPlayer
    if ([TQPlayerHelper isShowiOSAVPlayerView]) {
        [self playerPanelCloseEvent];
    }
}

@end
