//
//  TQPlayerFullScreenPanel.h
//  TQPlayer
//
//  Created by qfu on 4/2/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQPlayerPanelProtocol.h"

@interface TQPlayerFullScreenPanelTopView : UIView

@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) NSLayoutConstraint *closeButtonConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *closeButtonConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *closeButtonConstraintBottom;

@property (nonatomic,strong) UIButton *miniScreenButton;
@property (nonatomic,strong) NSLayoutConstraint *miniScreenButtonConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *miniScreenButtonConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *miniScreenButtonConstraintBottom;

@end

@interface TQPlayerFullScreenPanelBottomView : UIView

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) NSLayoutConstraint *backgroundViewConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *backgroundViewConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *backgroundViewConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *backgroundViewConstraintBottom;

@property (nonatomic,strong) UIView *progressBarContainer;
@property (nonatomic,strong) NSLayoutConstraint *progressBarContainerConstraintHeight;
@property (nonatomic,strong) NSLayoutConstraint *progressBarContainerConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *progressBarContainerConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *progressBarContainerConstraintTop;

@property (nonatomic,strong) UIView *progressBarBackground;
@property (nonatomic,strong) NSLayoutConstraint *progressBarBackgroundConstraintHeight;
@property (nonatomic,strong) NSLayoutConstraint *progressBarBackgroundConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *progressBarBackgroundConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *progressBarBackgroundConstraintCenterY;

@property (nonatomic,strong) UIView *progressBarDownload;
@property (nonatomic,strong) NSLayoutConstraint *progressBarDownloadConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *progressBarDownloadConstraintWidth;
@property (nonatomic,strong) NSLayoutConstraint *progressBarDownloadConstraintHeight;
@property (nonatomic,strong) NSLayoutConstraint *progressBarDownloadConstraintCenterY;

@property (nonatomic,strong) UIView *progressBarPlaying;
@property (nonatomic,strong) NSLayoutConstraint *progressBarPlayingConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *progressBarPlayingConstraintWidth;
@property (nonatomic,strong) NSLayoutConstraint *progressBarPlayingConstraintHeight;
@property (nonatomic,strong) NSLayoutConstraint *progressBarPlayingConstraintCenterY;

@property (nonatomic,strong) UIView *progressBarSliderPath;
@property (nonatomic,strong) NSLayoutConstraint *progressBarSliderPathConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *progressBarSliderPathConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *progressBarSliderPathConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *progressBarSliderPathConstraintBottom;

@property (nonatomic,strong) UIImageView *progressBarSlider;
@property (nonatomic,strong) NSLayoutConstraint *progressBarSliderConstraintWidth;
@property (nonatomic,strong) NSLayoutConstraint *progressBarSliderConstraintHeight;
@property (nonatomic,strong) NSLayoutConstraint *progressBarSliderConstraintCenterX;
@property (nonatomic,strong) NSLayoutConstraint *progressBarSliderConstraintCenterY;

@property (nonatomic,strong) UIButton *playPauseButton;
@property (nonatomic,strong) NSLayoutConstraint *playPauseButtonConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *playPauseButtonConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *playPauseButtonConstraintBottom;
@property (nonatomic,strong) NSLayoutConstraint *playPauseButtonConstraintWidth;

@property (nonatomic,strong) UILabel *playbackLabel;
@property (nonatomic,strong) NSLayoutConstraint *playbackLabelConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *playbackLabelConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *playbackLabelConstraintBottom;
@property (nonatomic,strong) NSLayoutConstraint *playbackLabelConstraintWidth;

- (void)layoutWithDownloadProgress:(double)progress;
- (void)layoutWithPlayingProgress:(double)progress;
@end

@interface TQPlayerFullScreenPanel : UIView <TQPlayerPanelProtocol>

@property (nonatomic,strong) TQPlayerFullScreenPanelTopView *topView;
@property (nonatomic,strong) NSLayoutConstraint *topViewConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *topViewConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *topViewConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *topViewConstraintHeight;

@property (nonatomic,strong) TQPlayerFullScreenPanelBottomView *bottomView;
@property (nonatomic,strong) NSLayoutConstraint *bottomViewConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *bottomViewConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *bottomViewConstraintBottom;
@property (nonatomic,strong) NSLayoutConstraint *bottomViewConstraintHeight;

@property (nonatomic,strong) UIPanGestureRecognizer *progressBarSliderPanGestureRecognizer;
@property (nonatomic,assign) BOOL progressBarSliderIsBusy;

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