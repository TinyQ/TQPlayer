//
//  TQPlayerMiniScreenPanel.h
//  TQPlayer
//
//  Created by qfu on 4/2/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQPlayerPanelProtocol.h"

@interface TQPlayerMiniScreenPanel : UIView <TQPlayerPanelProtocol>

@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) NSLayoutConstraint *closeButtonConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *closeButtonConstraintLeft;
@property (nonatomic,strong) NSLayoutConstraint *closeButtonConstraintHeight;
@property (nonatomic,strong) NSLayoutConstraint *closeButtonConstraintWidth;

@property (nonatomic,strong) UIButton *fullScreenButton;
@property (nonatomic,strong) NSLayoutConstraint *fullScreenButtonConstraintBottom;
@property (nonatomic,strong) NSLayoutConstraint *fullScreenButtonConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *fullScreenButtonConstraintHeight;
@property (nonatomic,strong) NSLayoutConstraint *fullScreenButtonConstraintWidth;

@property (nonatomic,strong) UIImageView *playImageView;
@property (nonatomic,strong) NSLayoutConstraint *playImageViewConstraintTop;
@property (nonatomic,strong) NSLayoutConstraint *playImageViewConstraintBottom;
@property (nonatomic,strong) NSLayoutConstraint *playImageViewConstraintRight;
@property (nonatomic,strong) NSLayoutConstraint *playImageViewConstraintLeft;

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
