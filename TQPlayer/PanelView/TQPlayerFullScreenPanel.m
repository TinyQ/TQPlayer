//
//  TQPlayerFullScreenPanel.m
//  TQPlayer
//
//  Created by qfu on 4/2/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerFullScreenPanel.h"
#import "TQPlayerHelper.h"
#import "TQPlayerResources.h"

#define kTOP_VIEW_HEIGHT (40)
#define kBOTTOM_VIEW_HEIGHT ((45) + ((31.5)/(2)))
#define kBOTTOM_VIEW_PROGRESS_BAR_HEIGHT 33.0
#define kBOTTOM_VIEW_PROGRESS_BAR_BACKGROUND 3.0
#define kBOOTOM_VIEW_PLAYBACK_LABEL_WIDTH 112.0
#define kBOTTOM_VIEW_PLAY_WIDTH 42.0
#define kBOTTOM_VIEW_PLAY_LEFT 14.0

typedef NS_ENUM(NSInteger, TQPlayerPlayPauseButtonStatus) {
    TQPlayerPlayButtonUnknown = 0,
    TQPlayerPlayPauseButtonPlay,
    TQPlayerPlayPauseButtonPause,
};

@implementation TQPlayerFullScreenPanelTopView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [TQPlayerHelper colorWithHexString:@"#1a1a1a" alpha:0.85];
        [self addSubview:self.closeButton];
        [self addSubview:self.miniScreenButton];
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    if (self.closeButton.superview) {
        if (self.closeButton.translatesAutoresizingMaskIntoConstraints) {
            self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.closeButtonConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.closeButtonConstraintTop]];
        }
        if (!self.closeButtonConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.closeButtonConstraintLeft]];
        }
        if (!self.closeButtonConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.closeButtonConstraintBottom]];
        }
    }
    
    if (self.miniScreenButton.superview) {
        if (self.miniScreenButton.translatesAutoresizingMaskIntoConstraints) {
            self.miniScreenButton.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.miniScreenButtonConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.miniScreenButtonConstraintTop]];
        }
        if (!self.miniScreenButtonConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.miniScreenButtonConstraintRight]];
        }
        if (!self.miniScreenButtonConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.miniScreenButtonConstraintBottom]];
        }
    }
}

- (UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor clearColor];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _closeButton.titleLabel.textColor = [UIColor whiteColor];
        _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        _closeButton.showsTouchWhenHighlighted = YES;
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (NSLayoutConstraint *)closeButtonConstraintTop{
    if (_closeButtonConstraintTop == nil) {
        _closeButtonConstraintTop = [NSLayoutConstraint constraintWithItem:self.closeButton
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0];
        _closeButtonConstraintTop.active = NO;
    }
    return _closeButtonConstraintTop;
}

- (NSLayoutConstraint *)closeButtonConstraintLeft{
    if (_closeButtonConstraintLeft == nil) {
        _closeButtonConstraintLeft = [NSLayoutConstraint constraintWithItem:self.closeButton
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:12];
        _closeButtonConstraintLeft.active = NO;
    }
    return _closeButtonConstraintLeft;
}

- (NSLayoutConstraint *)closeButtonConstraintBottom{
    if (_closeButtonConstraintBottom == nil) {
        _closeButtonConstraintBottom = [NSLayoutConstraint constraintWithItem:self.closeButton
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0];
        _closeButtonConstraintBottom.active = NO;
    }
    return _closeButtonConstraintBottom;
}

- (UIButton *)miniScreenButton{
    if (_miniScreenButton == nil) {
        _miniScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _miniScreenButton.backgroundColor = [UIColor clearColor];
        _miniScreenButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _miniScreenButton.titleLabel.textColor = [UIColor whiteColor];
        _miniScreenButton.translatesAutoresizingMaskIntoConstraints = NO;
        _miniScreenButton.showsTouchWhenHighlighted = YES;
        [_miniScreenButton setTitle:@"小窗" forState:UIControlStateNormal];
    }
    return _miniScreenButton;
}

- (NSLayoutConstraint *)miniScreenButtonConstraintTop{
    if (_miniScreenButtonConstraintTop == nil) {
        _miniScreenButtonConstraintTop = [NSLayoutConstraint constraintWithItem:self.miniScreenButton
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0];
        _miniScreenButtonConstraintTop.active = NO;
    }
    return _miniScreenButtonConstraintTop;
}

- (NSLayoutConstraint *)miniScreenButtonConstraintRight{
    if (_miniScreenButtonConstraintRight == nil) {
        _miniScreenButtonConstraintRight = [NSLayoutConstraint constraintWithItem:self.miniScreenButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:-12];
        _miniScreenButtonConstraintRight.active = NO;
    }
    return _miniScreenButtonConstraintRight;
}

- (NSLayoutConstraint *)miniScreenButtonConstraintBottom{
    if (_miniScreenButtonConstraintBottom == nil) {
        _miniScreenButtonConstraintBottom = [NSLayoutConstraint constraintWithItem:self.miniScreenButton
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0];
        _miniScreenButtonConstraintBottom.active = NO;
    }
    return _miniScreenButtonConstraintBottom;
}

@end

@implementation TQPlayerFullScreenPanelBottomView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.backgroundView];
        [self.progressBarContainer addSubview:self.progressBarBackground];
        [self.progressBarContainer addSubview:self.progressBarDownload];
        [self.progressBarContainer addSubview:self.progressBarPlaying];
        [self.progressBarContainer addSubview:self.progressBarSliderPath];
        [self.progressBarContainer addSubview:self.progressBarSlider];
        [self addSubview:self.progressBarContainer];
        [self addSubview:self.playPauseButton];
        [self addSubview:self.playbackLabel];
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];

    if (self.backgroundView.superview) {
        if (self.backgroundView.translatesAutoresizingMaskIntoConstraints) {
            self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        if (!self.backgroundViewConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.backgroundViewConstraintTop]];
        }
        if (!self.backgroundViewConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.backgroundViewConstraintLeft]];
        }
        if (!self.backgroundViewConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.backgroundViewConstraintRight]];
        }
        if (!self.backgroundViewConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.backgroundViewConstraintBottom]];
        }
    }
    
    if (self.progressBarContainer.superview) {
        if (self.progressBarContainer.translatesAutoresizingMaskIntoConstraints) {
            self.progressBarContainer.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.progressBarContainerConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarContainerConstraintHeight]];
        }
        if (!self.progressBarContainerConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarContainerConstraintLeft]];
        }
        if (!self.progressBarContainerConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarContainerConstraintRight]];
        }
        if (!self.progressBarContainerConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarContainerConstraintTop]];
        }
    }
    
    if (self.progressBarBackground.superview) {
        if (self.progressBarBackground.translatesAutoresizingMaskIntoConstraints) {
            self.progressBarBackground.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.progressBarBackgroundConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarBackgroundConstraintHeight]];
        }
        if (!self.progressBarBackgroundConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarBackgroundConstraintLeft]];
        }
        if (!self.progressBarBackgroundConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarBackgroundConstraintRight]];
        }
        if (!self.progressBarBackgroundConstraintCenterY.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarBackgroundConstraintCenterY]];
        }
    }
    
    if (self.progressBarDownload.superview) {
        if (self.progressBarDownload.translatesAutoresizingMaskIntoConstraints) {
            self.progressBarDownload.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.progressBarDownloadConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarDownloadConstraintLeft]];
        }
        if (!self.progressBarDownloadConstraintWidth.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarDownloadConstraintWidth]];
        }
        if (!self.progressBarDownloadConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarDownloadConstraintHeight]];
        }
        if (!self.progressBarDownloadConstraintCenterY.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarDownloadConstraintCenterY]];
        }
    }
    
    if (self.progressBarPlaying.superview) {
        if (self.progressBarPlaying.translatesAutoresizingMaskIntoConstraints) {
            self.progressBarPlaying.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.progressBarPlayingConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarPlayingConstraintLeft]];
        }
        if (!self.progressBarPlayingConstraintWidth.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarPlayingConstraintWidth]];
        }
        if (!self.progressBarPlayingConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarPlayingConstraintHeight]];
        }
        if (!self.progressBarPlayingConstraintCenterY.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarPlayingConstraintCenterY]];
        }
    }
    
    if (self.progressBarSliderPath.superview) {
        if (self.progressBarSliderPath.translatesAutoresizingMaskIntoConstraints) {
            self.progressBarSliderPath.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.progressBarSliderPathConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarSliderPathConstraintTop]];
        }
        if (!self.progressBarSliderPathConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarSliderPathConstraintLeft]];
        }
        if (!self.progressBarSliderPathConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarSliderPathConstraintRight]];
        }
        if (!self.progressBarSliderPathConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarSliderPathConstraintBottom]];
        }
    }
    
    if (self.progressBarSlider.superview) {
        if (self.progressBarSlider.translatesAutoresizingMaskIntoConstraints) {
            self.progressBarSlider.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.progressBarSliderConstraintWidth.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarSliderConstraintWidth]];
        }
        if (!self.progressBarSliderConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarSliderConstraintHeight]];
        }
        if (!self.progressBarSliderConstraintCenterX.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarSliderConstraintCenterX]];
        }
        if (!self.progressBarSliderConstraintCenterY.active) {
            [NSLayoutConstraint activateConstraints:@[self.progressBarSliderConstraintCenterY]];
        }
    }
    
    if (self.playPauseButton.superview) {
        if (self.playPauseButton.translatesAutoresizingMaskIntoConstraints) {
            self.playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.playPauseButtonConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.playPauseButtonConstraintTop]];
        }
        if (!self.playPauseButtonConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.playPauseButtonConstraintLeft]];
        }
        if (!self.playPauseButtonConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.playPauseButtonConstraintBottom]];
        }
        if (!self.playPauseButtonConstraintWidth.active) {
            [NSLayoutConstraint activateConstraints:@[self.playPauseButtonConstraintWidth]];
        }
    }
    
    if (self.playbackLabel.superview) {
        if (self.playbackLabel.translatesAutoresizingMaskIntoConstraints) {
            self.playbackLabel.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.playbackLabelConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.playbackLabelConstraintTop]];
        }
        if (!self.playbackLabelConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.playbackLabelConstraintLeft]];
        }
        if (!self.playbackLabelConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.playbackLabelConstraintBottom]];
        }
        if (!self.playbackLabelConstraintWidth.active) {
            [NSLayoutConstraint activateConstraints:@[self.playbackLabelConstraintWidth]];
        }
    }
}

- (UIView *)backgroundView{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [TQPlayerHelper colorWithHexString:@"#1a1a1a" alpha:0.85];
    }
    return _backgroundView;
}

- (NSLayoutConstraint *)backgroundViewConstraintTop{
    if (_backgroundViewConstraintTop == nil) {
        _backgroundViewConstraintTop = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.progressBarContainer
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                     constant:0];
        _backgroundViewConstraintTop.active = NO;
    }
    return _backgroundViewConstraintTop;
}

- (NSLayoutConstraint *)backgroundViewConstraintLeft{
    if (_backgroundViewConstraintLeft == nil) {
        _backgroundViewConstraintLeft = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                    constant:0];
        _backgroundViewConstraintLeft.active = NO;
    }
    return _backgroundViewConstraintLeft;
}

- (NSLayoutConstraint *)backgroundViewConstraintRight{
    if (_backgroundViewConstraintRight == nil) {
        _backgroundViewConstraintRight = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
        _backgroundViewConstraintRight.active = NO;
    }
    return _backgroundViewConstraintRight;
}

- (NSLayoutConstraint *)backgroundViewConstraintBottom{
    if (_backgroundViewConstraintBottom == nil) {
        _backgroundViewConstraintBottom = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0];
        _backgroundViewConstraintBottom.active = NO;
    }
    return _backgroundViewConstraintBottom;
}

- (UIView *)progressBarContainer{
    if (_progressBarContainer == nil) {
        _progressBarContainer = [[UIView alloc] init];
        _progressBarContainer.backgroundColor = [UIColor clearColor];
    }
    return _progressBarContainer;
}

- (NSLayoutConstraint *)progressBarContainerConstraintHeight{
    if (_progressBarContainerConstraintHeight == nil) {
        _progressBarContainerConstraintHeight = [NSLayoutConstraint constraintWithItem:self.progressBarContainer
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0
                                                                              constant:kBOTTOM_VIEW_PROGRESS_BAR_HEIGHT];
        _progressBarContainerConstraintHeight.active = NO;
    }
    return _progressBarContainerConstraintHeight;
}

- (NSLayoutConstraint *)progressBarContainerConstraintLeft{
    if (_progressBarContainerConstraintLeft == nil) {
        _progressBarContainerConstraintLeft = [NSLayoutConstraint constraintWithItem:self.progressBarContainer
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0
                                                                            constant:0];
        _progressBarContainerConstraintLeft.active = NO;
    }
    return _progressBarContainerConstraintLeft;
}

- (NSLayoutConstraint *)progressBarContainerConstraintRight{
    if (_progressBarContainerConstraintRight == nil) {
        _progressBarContainerConstraintRight = [NSLayoutConstraint constraintWithItem:self.progressBarContainer
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0
                                                                             constant:0];
        _progressBarContainerConstraintRight.active = NO;
    }
    return _progressBarContainerConstraintRight;
}

- (NSLayoutConstraint *)progressBarContainerConstraintTop{
    if (_progressBarContainerConstraintTop == nil) {
        _progressBarContainerConstraintTop = [NSLayoutConstraint constraintWithItem:self.progressBarContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:0];
        _progressBarContainerConstraintTop.active = NO;
    }
    return _progressBarContainerConstraintTop;
}

- (UIView *)progressBarBackground{
    if (_progressBarBackground == nil) {
        _progressBarBackground = [[UIView alloc] init];
        _progressBarBackground.backgroundColor = [UIColor whiteColor];
    }
    return _progressBarBackground;
}

- (NSLayoutConstraint *)progressBarBackgroundConstraintHeight{
    if (_progressBarBackgroundConstraintHeight == nil) {
        _progressBarBackgroundConstraintHeight = [NSLayoutConstraint constraintWithItem:self.progressBarBackground
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.0
                                                                               constant:kBOTTOM_VIEW_PROGRESS_BAR_BACKGROUND];
        _progressBarBackgroundConstraintHeight.active = NO;
    }
    return _progressBarBackgroundConstraintHeight;
}

- (NSLayoutConstraint *)progressBarBackgroundConstraintLeft{
    if (_progressBarBackgroundConstraintLeft == nil) {
        _progressBarBackgroundConstraintLeft = [NSLayoutConstraint constraintWithItem:self.progressBarBackground
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.progressBarContainer
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0
                                                                             constant:0];
        _progressBarBackgroundConstraintLeft.active = NO;
    }
    return _progressBarBackgroundConstraintLeft;
}

- (NSLayoutConstraint *)progressBarBackgroundConstraintRight{
    if (_progressBarBackgroundConstraintRight == nil) {
        _progressBarBackgroundConstraintRight = [NSLayoutConstraint constraintWithItem:self.progressBarBackground
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.progressBarContainer
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0
                                                                              constant:0];
        _progressBarBackgroundConstraintRight.active = NO;
    }
    return _progressBarBackgroundConstraintRight;
}

- (NSLayoutConstraint *)progressBarBackgroundConstraintCenterY{
    if (_progressBarBackgroundConstraintCenterY == nil) {
        _progressBarBackgroundConstraintCenterY = [NSLayoutConstraint constraintWithItem:self.progressBarBackground
                                                                               attribute:NSLayoutAttributeCenterY
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.progressBarContainer
                                                                               attribute:NSLayoutAttributeCenterY
                                                                              multiplier:1.0
                                                                                constant:0];
        _progressBarBackgroundConstraintCenterY.active = NO;
    }
    return _progressBarBackgroundConstraintCenterY;
}

- (UIView *)progressBarDownload{
    if (_progressBarDownload == nil) {
        _progressBarDownload = [[UIView alloc] init];
        _progressBarDownload.backgroundColor = [TQPlayerHelper colorWithHexString:@"#cdcdcd"];
    }
    return _progressBarDownload;
}

- (NSLayoutConstraint *)progressBarDownloadConstraintLeft{
    if (_progressBarDownloadConstraintLeft == nil) {
        _progressBarDownloadConstraintLeft = [NSLayoutConstraint constraintWithItem:self.progressBarDownload
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.progressBarBackground
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0
                                                                           constant:0];
        _progressBarDownloadConstraintLeft.active = NO;
    }
    return _progressBarDownloadConstraintLeft;
}

- (NSLayoutConstraint *)progressBarDownloadConstraintHeight{
    if (_progressBarDownloadConstraintHeight == nil) {
        _progressBarDownloadConstraintHeight = [NSLayoutConstraint constraintWithItem:self.progressBarDownload
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.progressBarBackground
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:1.0
                                                                             constant:0];
        _progressBarDownloadConstraintHeight.active = NO;
    }
    return _progressBarDownloadConstraintHeight;
}

- (NSLayoutConstraint *)progressBarDownloadConstraintWidth{
    if (_progressBarDownloadConstraintWidth == nil) {
        _progressBarDownloadConstraintWidth = [NSLayoutConstraint constraintWithItem:self.progressBarDownload
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:0];
        _progressBarDownloadConstraintWidth.active = NO;
    }
    return _progressBarDownloadConstraintWidth;
}

- (NSLayoutConstraint *)progressBarDownloadConstraintCenterY{
    if (_progressBarDownloadConstraintCenterY == nil) {
        _progressBarDownloadConstraintCenterY = [NSLayoutConstraint constraintWithItem:self.progressBarDownload
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.progressBarBackground
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1.0
                                                                              constant:0];
        _progressBarDownloadConstraintCenterY.active = NO;
    }
    return _progressBarDownloadConstraintCenterY;
}

- (UIView *)progressBarPlaying{
    if (_progressBarPlaying == nil) {
        _progressBarPlaying = [[UIView alloc] init];
        _progressBarPlaying.backgroundColor = [TQPlayerHelper colorWithHexString:@"#06438e"];
    }
    return _progressBarPlaying;
}

- (NSLayoutConstraint *)progressBarPlayingConstraintLeft{
    if (_progressBarPlayingConstraintLeft == nil) {
        _progressBarPlayingConstraintLeft = [NSLayoutConstraint constraintWithItem:self.progressBarPlaying
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.progressBarBackground
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:0];
        _progressBarPlayingConstraintLeft.active = NO;
    }
    return _progressBarPlayingConstraintLeft;
}

- (NSLayoutConstraint *)progressBarPlayingConstraintHeight{
    if (_progressBarPlayingConstraintHeight == nil) {
        _progressBarPlayingConstraintHeight = [NSLayoutConstraint constraintWithItem:self.progressBarPlaying
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.progressBarBackground
                                                                           attribute:NSLayoutAttributeHeight
                                                                          multiplier:1.0
                                                                            constant:0];
        _progressBarPlayingConstraintHeight.active = NO;
    }
    return _progressBarPlayingConstraintHeight;
}

- (NSLayoutConstraint *)progressBarPlayingConstraintWidth{
    if (_progressBarPlayingConstraintWidth == nil) {
        _progressBarPlayingConstraintWidth = [NSLayoutConstraint constraintWithItem:self.progressBarPlaying
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0
                                                                           constant:0];
        _progressBarPlayingConstraintWidth.active = NO;
    }
    return _progressBarPlayingConstraintWidth;
}

- (NSLayoutConstraint *)progressBarPlayingConstraintCenterY{
    if (_progressBarPlayingConstraintCenterY == nil) {
        _progressBarPlayingConstraintCenterY = [NSLayoutConstraint constraintWithItem:self.progressBarPlaying
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.progressBarBackground
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1.0
                                                                             constant:0];
        _progressBarPlayingConstraintCenterY.active = NO;
    }
    return _progressBarPlayingConstraintCenterY;
}

- (UIView *)progressBarSliderPath{
    if (_progressBarSliderPath == nil) {
        _progressBarSliderPath = [[UIView alloc] init];
        _progressBarSliderPath.backgroundColor = [UIColor clearColor];
    }
    return _progressBarSliderPath;
}

- (NSLayoutConstraint *)progressBarSliderPathConstraintTop{
    if (_progressBarSliderPathConstraintTop == nil) {
        _progressBarSliderPathConstraintTop = [NSLayoutConstraint constraintWithItem:self.progressBarSliderPath
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.progressBarContainer
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:0];
        _progressBarSliderPathConstraintTop.active = NO;
    }
    return _progressBarSliderPathConstraintTop;
}

- (NSLayoutConstraint *)progressBarSliderPathConstraintLeft{
    if (_progressBarSliderPathConstraintLeft == nil) {
        _progressBarSliderPathConstraintLeft = [NSLayoutConstraint constraintWithItem:self.progressBarSliderPath
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.progressBarBackground
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0
                                                                             constant:56/2/2 - 6.5];
        _progressBarSliderPathConstraintLeft.active = NO;
    }
    return _progressBarSliderPathConstraintLeft;
}

- (NSLayoutConstraint *)progressBarSliderPathConstraintRight{
    if (_progressBarSliderPathConstraintRight == nil) {
        _progressBarSliderPathConstraintRight = [NSLayoutConstraint constraintWithItem:self.progressBarSliderPath
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.progressBarBackground
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0
                                                                             constant:-(56/2/2 - 6.5)];
        _progressBarSliderPathConstraintRight.active = NO;
    }
    return _progressBarSliderPathConstraintRight;
}

- (NSLayoutConstraint *)progressBarSliderPathConstraintBottom{
    if (_progressBarSliderPathConstraintBottom == nil) {
        _progressBarSliderPathConstraintBottom = [NSLayoutConstraint constraintWithItem:self.progressBarSliderPath
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.progressBarContainer
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:0];
        _progressBarSliderPathConstraintBottom.active = NO;
    }
    return _progressBarSliderPathConstraintBottom;
}

- (UIImageView *)progressBarSlider{
    if (_progressBarSlider == nil) {
        _progressBarSlider = [[UIImageView alloc] init];
        _progressBarSlider.image = [TQPlayerResources progress];
        _progressBarSlider.userInteractionEnabled = YES;
    }
    return _progressBarSlider;
}

- (NSLayoutConstraint *)progressBarSliderConstraintWidth{
    if (_progressBarSliderConstraintWidth == nil) {
        _progressBarSliderConstraintWidth = [NSLayoutConstraint constraintWithItem:self.progressBarSlider
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:56/2];
        _progressBarSliderConstraintWidth.active = NO;
    }
    return _progressBarSliderConstraintWidth;
}

- (NSLayoutConstraint *)progressBarSliderConstraintHeight{
    if (_progressBarSliderConstraintHeight == nil) {
        _progressBarSliderConstraintHeight = [NSLayoutConstraint constraintWithItem:self.progressBarSlider
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0
                                                                           constant:66/2];
        _progressBarSliderConstraintHeight.active = NO;
    }
    return _progressBarSliderConstraintHeight;
}

- (NSLayoutConstraint *)progressBarSliderConstraintCenterX{
    if (_progressBarSliderConstraintCenterX == nil) {
        _progressBarSliderConstraintCenterX = [NSLayoutConstraint constraintWithItem:self.progressBarSlider
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.progressBarSliderPath
                                                                           attribute:NSLayoutAttributeLeading
                                                                          multiplier:1.0
                                                                            constant:0];
        _progressBarSliderConstraintCenterX.active = NO;
    }
    return _progressBarSliderConstraintCenterX;
}

- (NSLayoutConstraint *)progressBarSliderConstraintCenterY{
    if (_progressBarSliderConstraintCenterY == nil) {
        _progressBarSliderConstraintCenterY = [NSLayoutConstraint constraintWithItem:self.progressBarSlider
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.progressBarSliderPath
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1.0
                                                                            constant:0];
        _progressBarSliderConstraintCenterY.active = NO;
    }
    return _progressBarSliderConstraintCenterY;
}

- (UIButton *)playPauseButton{
    if (_playPauseButton == nil) {
        _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playPauseButton.backgroundColor = [UIColor clearColor];
        [_playPauseButton setImage:[TQPlayerResources play] forState:UIControlStateNormal];
        _playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _playPauseButton;
}

- (NSLayoutConstraint *)playPauseButtonConstraintTop{
    if (_playPauseButtonConstraintTop == nil) {
        _playPauseButtonConstraintTop = [NSLayoutConstraint constraintWithItem:self.playPauseButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.backgroundView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
        _playPauseButtonConstraintTop.active = NO;
    }
    return _playPauseButtonConstraintTop;
}

- (NSLayoutConstraint *)playPauseButtonConstraintLeft{
    if (_playPauseButtonConstraintLeft == nil) {
        _playPauseButtonConstraintLeft = [NSLayoutConstraint constraintWithItem:self.playPauseButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:kBOTTOM_VIEW_PLAY_LEFT];
        _playPauseButtonConstraintLeft.active = NO;
    }
    return _playPauseButtonConstraintLeft;
}

- (NSLayoutConstraint *)playPauseButtonConstraintBottom{
    if (_playPauseButtonConstraintBottom == nil) {
        _playPauseButtonConstraintBottom = [NSLayoutConstraint constraintWithItem:self.playPauseButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0];
        _playPauseButtonConstraintBottom.active = NO;
    }
    return _playPauseButtonConstraintBottom;
}

- (NSLayoutConstraint *)playPauseButtonConstraintWidth{
    if (_playPauseButtonConstraintWidth == nil) {
        _playPauseButtonConstraintWidth = [NSLayoutConstraint constraintWithItem:self.playPauseButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:kBOTTOM_VIEW_PLAY_WIDTH];
        _playPauseButtonConstraintWidth.active = NO;
    }
    return _playPauseButtonConstraintWidth;
}

- (UILabel *)playbackLabel{
    if (_playbackLabel == nil) {
        _playbackLabel = [[UILabel alloc] init];
        _playbackLabel.backgroundColor = [UIColor clearColor];
        _playbackLabel.text = @"00:00:00/00:00:00";
        _playbackLabel.textColor = [UIColor whiteColor];
        _playbackLabel.font = [UIFont systemFontOfSize:11];
        _playbackLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _playbackLabel;
}

- (NSLayoutConstraint *)playbackLabelConstraintTop{
    if (_playbackLabelConstraintTop == nil) {
        _playbackLabelConstraintTop = [NSLayoutConstraint constraintWithItem:self.playbackLabel
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.backgroundView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:0];
        _playbackLabelConstraintTop.active = NO;
    }
    return _playbackLabelConstraintTop;
}

- (NSLayoutConstraint *)playbackLabelConstraintLeft{
    if (_playbackLabelConstraintLeft == nil) {
        _playbackLabelConstraintLeft = [NSLayoutConstraint constraintWithItem:self.playbackLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.playPauseButton
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:kBOTTOM_VIEW_PLAY_LEFT];
        _playbackLabelConstraintLeft.active = NO;
    }
    return _playbackLabelConstraintLeft;
}

- (NSLayoutConstraint *)playbackLabelConstraintBottom{
    if (_playbackLabelConstraintBottom == nil) {
        _playbackLabelConstraintBottom = [NSLayoutConstraint constraintWithItem:self.playbackLabel
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.backgroundView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:0];
        _playbackLabelConstraintBottom.active = NO;
    }
    return _playbackLabelConstraintBottom;
}

- (NSLayoutConstraint *)playbackLabelConstraintWidth{
    if (_playbackLabelConstraintWidth == nil) {
        _playbackLabelConstraintWidth = [NSLayoutConstraint constraintWithItem:self.playbackLabel
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:kBOOTOM_VIEW_PLAYBACK_LABEL_WIDTH];
        _playbackLabelConstraintWidth.active = NO;
    }
    return _playbackLabelConstraintWidth;
}

- (void)layoutWithDownloadProgress:(double)progress{
    [NSLayoutConstraint deactivateConstraints:@[self.progressBarDownloadConstraintWidth]];
    if (progress == 0.0) {
        self.progressBarDownloadConstraintWidth = [NSLayoutConstraint constraintWithItem:self.progressBarDownload
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1.0
                                                                                constant:0];
    } else {
        
        self.progressBarDownloadConstraintWidth = [NSLayoutConstraint constraintWithItem:self.progressBarDownload
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.progressBarBackground
                                                                               attribute:NSLayoutAttributeWidth
                                                                              multiplier:progress
                                                                                constant:0];
    }
    [NSLayoutConstraint activateConstraints:@[self.progressBarDownloadConstraintWidth]];
}

- (void)layoutWithPlayingProgress:(double)progress{
    [NSLayoutConstraint deactivateConstraints:@[self.progressBarPlayingConstraintWidth,self.progressBarSliderConstraintCenterX]];
    [NSLayoutConstraint deactivateConstraints:@[self.progressBarSliderConstraintCenterX]];
    
    if (progress == 0.0) {
        self.progressBarPlayingConstraintWidth = [NSLayoutConstraint constraintWithItem:self.progressBarPlaying
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.0
                                                                               constant:0];
        self.progressBarSliderConstraintCenterX = [NSLayoutConstraint constraintWithItem:self.progressBarSlider
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.progressBarSliderPath
                                                                               attribute:NSLayoutAttributeLeading
                                                                              multiplier:1.0
                                                                                constant:0];
    } else {
        self.progressBarPlayingConstraintWidth = [NSLayoutConstraint constraintWithItem:self.progressBarPlaying
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.progressBarBackground
                                                                              attribute:NSLayoutAttributeWidth
                                                                             multiplier:progress
                                                                               constant:0];
        self.progressBarSliderConstraintCenterX = [NSLayoutConstraint constraintWithItem:self.progressBarSlider
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.progressBarSliderPath
                                                                               attribute:NSLayoutAttributeTrailing
                                                                              multiplier:progress
                                                                                constant:0];
    }
    [NSLayoutConstraint activateConstraints:@[self.progressBarPlayingConstraintWidth,self.progressBarSliderConstraintCenterX]];
}

@end

@interface TQPlayerFullScreenPanel()

@property (nonatomic,assign) BOOL playPanelHidden;

@end

@implementation TQPlayerFullScreenPanel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self.topView.closeButton addTarget:self action:@selector(topViewCloseButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView.miniScreenButton addTarget:self action:@selector(topViewMiniScreenButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView.playPauseButton addTarget:self action:@selector(bottomViewPlayPauseButtonButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        self.progressBarSliderPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleProgressBarSliderPanGestureRecognizer:)];
        
        self.progressBarSliderPanGestureRecognizer.maximumNumberOfTouches = 1;
        [self.bottomView.progressBarSlider addGestureRecognizer:self.progressBarSliderPanGestureRecognizer];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint topViewPoint = [self convertPoint:point toView:self.topView];
    CGPoint bottomViewPoint = [self convertPoint:point toView:self.bottomView];
    
    if (CGRectContainsPoint(self.topView.bounds, topViewPoint))
    {
        return YES;
    }
    
    if (CGRectContainsPoint(self.bottomView.bounds, bottomViewPoint))
    {
        return YES;
    }
    
    return NO;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    if (self.topView.superview) {
        if (!self.topViewConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.topViewConstraintTop]];
        }
        if (!self.topViewConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.topViewConstraintLeft]];
        }
        if (!self.topViewConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.topViewConstraintRight]];
        }
        if (!self.topViewConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.topViewConstraintHeight]];
        }
    }
    
    if (self.bottomView.superview) {
        if (!self.bottomViewConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.bottomViewConstraintLeft]];
        }
        if (!self.bottomViewConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.bottomViewConstraintRight]];
        }
        if (!self.bottomViewConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.bottomViewConstraintBottom]];
        }
        if (!self.bottomViewConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.bottomViewConstraintHeight]];
        }
    }
}

#pragma mark - topView

- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[TQPlayerFullScreenPanelTopView alloc] init];
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _topView;
}

- (NSLayoutConstraint *)topViewConstraintTop{
    if (_topViewConstraintTop == nil) {
        _topViewConstraintTop = [NSLayoutConstraint constraintWithItem:self.topView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0];
        _topViewConstraintTop.active = NO;
    }
    return _topViewConstraintTop;
}

- (NSLayoutConstraint *)topViewConstraintHeight{
    if (_topViewConstraintHeight == nil) {
        _topViewConstraintHeight = [NSLayoutConstraint constraintWithItem:self.topView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:kTOP_VIEW_HEIGHT];
        _topViewConstraintHeight.active = NO;
    }
    return _topViewConstraintHeight;
}

- (NSLayoutConstraint *)topViewConstraintLeft{
    if (_topViewConstraintLeft == nil) {
        _topViewConstraintLeft = [NSLayoutConstraint constraintWithItem:self.topView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:0];
        _topViewConstraintLeft.active = NO;
    }
    return _topViewConstraintLeft;
}

- (NSLayoutConstraint *)topViewConstraintRight{
    if (_topViewConstraintRight == nil) {
        _topViewConstraintRight = [NSLayoutConstraint constraintWithItem:self.topView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:0];
        _topViewConstraintRight.active = NO;
    }
    return _topViewConstraintRight;
}

#pragma mark - bottomView

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[TQPlayerFullScreenPanelBottomView alloc] init];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bottomView;
}

- (NSLayoutConstraint *)bottomViewConstraintLeft{
    if (_bottomViewConstraintLeft == nil) {
        _bottomViewConstraintLeft = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0];
        _bottomViewConstraintLeft.active = NO;
    }
    return _bottomViewConstraintLeft;
}

- (NSLayoutConstraint *)bottomViewConstraintRight{
    if (_bottomViewConstraintRight == nil) {
        _bottomViewConstraintRight = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:0];
        _bottomViewConstraintRight.active = NO;
    }
    return _bottomViewConstraintRight;
}

- (NSLayoutConstraint *)bottomViewConstraintBottom{
    if (_bottomViewConstraintBottom == nil) {
        _bottomViewConstraintBottom = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:0];
        _bottomViewConstraintBottom.active = NO;
    }
    return _bottomViewConstraintBottom;
}

- (NSLayoutConstraint *)bottomViewConstraintHeight{
    if (_bottomViewConstraintHeight == nil) {
        _bottomViewConstraintHeight = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:kBOTTOM_VIEW_HEIGHT];
        _bottomViewConstraintHeight.active = NO;
    }
    return _bottomViewConstraintHeight;
}

#pragma mark - Action

- (void)topViewCloseButtonTouchUpInside:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPanelCloseEvent)]) {
        [self.delegate playerPanelCloseEvent];
    }
}

- (void)topViewMiniScreenButtonTouchUpInside:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPanelMiniScreenEvent)]) {
        [self.delegate playerPanelMiniScreenEvent];
    }
}

- (void)bottomViewPlayPauseButtonButtonTouchUpInside:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == TQPlayerPlayButtonUnknown){
        //Unknown
    } else if (button.tag == TQPlayerPlayPauseButtonPause){
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerPanelPauseEvent)]){
            [self.delegate playerPanelPauseEvent];
        }
    } else if (button.tag == TQPlayerPlayPauseButtonPlay){
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerPanelPlayEvent)]){
            [self.delegate playerPanelPlayEvent];
        }
    }
}

- (void)handleProgressBarSliderPanGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view.superview];
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.progressBarSliderIsBusy = YES;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat progress = (CGFloat)MIN(MAX(0.0,(location.x / recognizer.view.superview.frame.size.width)),1.0);
            [self.bottomView layoutWithPlayingProgress:progress];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGFloat value = location.x / recognizer.view.superview.frame.size.width;
            CGFloat progress = (CGFloat)MIN(MAX(0.0, value), 1.0);
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerPanelSeekToProgress: completionHandler:)]){
                __weak typeof(self) weakSelf = self;
                [self.delegate playerPanelSeekToProgress:progress completionHandler:^(BOOL finished) {
                    weakSelf.progressBarSliderIsBusy = NO;
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - TQPlayerPanelProtocol

- (void)updatePlayPanelWithLive:(BOOL)isLive{
    self.bottomView.progressBarSlider.hidden = isLive;
}

- (void)updatePlayPanelWithLoading:(BOOL)isLoading{
    // ignore
}

- (void)updatePlayPanelWithPlaying:(BOOL)isPlaying{
    if (isPlaying){
        [self.bottomView.playPauseButton setTag:TQPlayerPlayPauseButtonPause];
        [self.bottomView.playPauseButton setImage:[TQPlayerResources pause] forState:UIControlStateNormal];
    }
    else
    {
        [self.bottomView.playPauseButton setTag:TQPlayerPlayPauseButtonPlay];
        [self.bottomView.playPauseButton setImage:[TQPlayerResources play] forState:UIControlStateNormal];
    }
}

- (void)updatePlayPanelWithDuration:(double)duration downloadProgress:(double)downloadProgress{
    if (duration <= 0.0) {
        return;
    }
    double progress = (double)MIN(MAX(0.0, (downloadProgress / duration)), 1.0);
    [self.bottomView layoutWithDownloadProgress:progress];
}

- (void)updatePlayPanelWithDuration:(double)duration playingProgress:(double)playingProgress{
    if (playingProgress <= 0.0) {
        return;
    }
    
    if (self.progressBarSliderIsBusy == NO) {
        double progress = (double)MIN(MAX(0.0, (playingProgress / duration)), 1.0);
        [self.bottomView layoutWithPlayingProgress:progress];
    }
    
    NSString *str_duration = [TQPlayerHelper timeStringFromSecondsValue:duration];
    NSString *str_seconds = [TQPlayerHelper timeStringFromSecondsValue:playingProgress];
    
    self.bottomView.playbackLabel.text = [NSString stringWithFormat:@"%@/%@",str_seconds,str_duration];
}

- (void)showPlayPanelWithAnimationCompletion:(void (^)(BOOL finished))completion{
    self.playPanelHidden = NO;
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    self.topViewConstraintTop.constant = 0;
    self.bottomViewConstraintBottom.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

- (void)hiddenPlayPanelWithAnimationCompletion:(void (^)(BOOL finished))completion{
    self.playPanelHidden = YES;
    self.topViewConstraintTop.constant = -kTOP_VIEW_HEIGHT;
    self.bottomViewConstraintBottom.constant = kBOTTOM_VIEW_HEIGHT;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        completion(finished);
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
    }];
}

@end
