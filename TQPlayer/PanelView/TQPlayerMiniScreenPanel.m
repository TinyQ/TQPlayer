//
//  TQPlayerMiniScreenPanel.m
//  TQPlayer
//
//  Created by qfu on 4/2/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerMiniScreenPanel.h"
#import "TQPlayerResources.h"

@interface TQPlayerMiniScreenPanel()

@property (nonatomic,assign) BOOL playPanelHidden;

@end

@implementation TQPlayerMiniScreenPanel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.closeButton];
        [self addSubview:self.fullScreenButton];
        [self addSubview:self.playImageView];
        
        [self.closeButton addTarget:self action:@selector(closeButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullScreenButton addTarget:self action:@selector(fullScreenButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.closeButton.bounds, [self convertPoint:point toView:self.closeButton])){
        return YES;
    }
    
    if (CGRectContainsPoint(self.fullScreenButton.bounds, [self convertPoint:point toView:self.fullScreenButton])){
        return YES;
    }
    
    return NO;
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
        if (!self.closeButtonConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.closeButtonConstraintHeight]];
        }
        if (!self.closeButtonConstraintWidth.active) {
            [NSLayoutConstraint activateConstraints:@[self.closeButtonConstraintWidth]];
        }
    }
    
    if (self.fullScreenButton.superview) {
        if (self.fullScreenButton.translatesAutoresizingMaskIntoConstraints) {
            self.fullScreenButton.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.fullScreenButtonConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.fullScreenButtonConstraintBottom]];
        }
        if (!self.fullScreenButtonConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.fullScreenButtonConstraintRight]];
        }
        if (!self.fullScreenButtonConstraintHeight.active) {
            [NSLayoutConstraint activateConstraints:@[self.fullScreenButtonConstraintHeight]];
        }
        if (!self.fullScreenButtonConstraintWidth.active) {
            [NSLayoutConstraint activateConstraints:@[self.fullScreenButtonConstraintWidth]];
        }
    }
    
    if (self.playImageView.superview) {
        if (self.playImageView.translatesAutoresizingMaskIntoConstraints) {
            self.playImageView.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (!self.playImageViewConstraintTop.active) {
            [NSLayoutConstraint activateConstraints:@[self.playImageViewConstraintTop]];
        }
        if (!self.playImageViewConstraintBottom.active) {
            [NSLayoutConstraint activateConstraints:@[self.playImageViewConstraintBottom]];
        }
        if (!self.playImageViewConstraintRight.active) {
            [NSLayoutConstraint activateConstraints:@[self.playImageViewConstraintRight]];
        }
        if (!self.playImageViewConstraintLeft.active) {
            [NSLayoutConstraint activateConstraints:@[self.playImageViewConstraintLeft]];
        }
    }
}

- (UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton setImage:[TQPlayerResources close] forState:UIControlStateNormal];
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
                                                                   constant:0];
        _closeButtonConstraintLeft.active = NO;
    }
    return _closeButtonConstraintLeft;
}

- (NSLayoutConstraint *)closeButtonConstraintHeight{
    if (_closeButtonConstraintHeight == nil) {
        _closeButtonConstraintHeight = [NSLayoutConstraint constraintWithItem:self.closeButton
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:10 + 9 + 10];
        _closeButtonConstraintHeight.active = NO;
    }
    return _closeButtonConstraintHeight;
}

- (NSLayoutConstraint *)closeButtonConstraintWidth{
    if (_closeButtonConstraintWidth == nil) {
        _closeButtonConstraintWidth = [NSLayoutConstraint constraintWithItem:self.closeButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:10 + 9 + 10];
        _closeButtonConstraintWidth.active = NO;
    }
    return _closeButtonConstraintWidth;
}

- (UIButton *)fullScreenButton{
    if (_fullScreenButton == nil) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenButton.backgroundColor = [UIColor clearColor];
        [_fullScreenButton setImage:[TQPlayerResources full] forState:UIControlStateNormal];
    }
    return _fullScreenButton;
}

- (NSLayoutConstraint *)fullScreenButtonConstraintBottom{
    if (_fullScreenButtonConstraintBottom == nil) {
        _fullScreenButtonConstraintBottom = [NSLayoutConstraint constraintWithItem:self.fullScreenButton
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0];
        _fullScreenButtonConstraintBottom.active = NO;
    }
    return _fullScreenButtonConstraintBottom;
}

- (NSLayoutConstraint *)fullScreenButtonConstraintRight{
    if (_fullScreenButtonConstraintRight == nil) {
        _fullScreenButtonConstraintRight = [NSLayoutConstraint constraintWithItem:self.fullScreenButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:0];
        _fullScreenButtonConstraintRight.active = NO;
    }
    return _fullScreenButtonConstraintRight;
}

- (NSLayoutConstraint *)fullScreenButtonConstraintHeight{
    if (_fullScreenButtonConstraintHeight == nil) {
        _fullScreenButtonConstraintHeight = [NSLayoutConstraint constraintWithItem:self.fullScreenButton
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:10 + 11 + 10];
        _fullScreenButtonConstraintHeight.active = NO;
    }
    return _fullScreenButtonConstraintHeight;
}

- (NSLayoutConstraint *)fullScreenButtonConstraintWidth{
    if (_fullScreenButtonConstraintWidth == nil) {
        _fullScreenButtonConstraintWidth = [NSLayoutConstraint constraintWithItem:self.fullScreenButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:10 + 11 + 10];
        _fullScreenButtonConstraintWidth.active = NO;
    }
    return _fullScreenButtonConstraintWidth;
}

- (UIImageView *)playImageView{
    if (_playImageView == nil) {
        _playImageView = [[UIImageView alloc] init];
        _playImageView.image = [TQPlayerResources play];
        _playImageView.contentMode =  UIViewContentModeCenter;
    }
    return _playImageView;
}

- (NSLayoutConstraint *)playImageViewConstraintTop{
    if (_playImageViewConstraintTop == nil) {
        _playImageViewConstraintTop = [NSLayoutConstraint constraintWithItem:self.playImageView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:0];
        _playImageViewConstraintTop.active = NO;
    }
    return _playImageViewConstraintTop;
}

- (NSLayoutConstraint *)playImageViewConstraintBottom{
    if (_playImageViewConstraintBottom == nil) {
        _playImageViewConstraintBottom = [NSLayoutConstraint constraintWithItem:self.playImageView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:0];
        _playImageViewConstraintBottom.active = NO;
    }
    return _playImageViewConstraintBottom;
}

- (NSLayoutConstraint *)playImageViewConstraintRight{
    if (_playImageViewConstraintRight == nil) {
        _playImageViewConstraintRight = [NSLayoutConstraint constraintWithItem:self.playImageView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:0];
        _playImageViewConstraintRight.active = NO;
    }
    return _playImageViewConstraintRight;
}

- (NSLayoutConstraint *)playImageViewConstraintLeft{
    if (_playImageViewConstraintLeft == nil) {
        _playImageViewConstraintLeft = [NSLayoutConstraint constraintWithItem:self.playImageView
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:0];
        _playImageViewConstraintLeft.active = NO;
    }
    return _playImageViewConstraintLeft;
}

#pragma mark - Action

- (void)closeButtonTouchUpInside:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPanelCloseEvent)]) {
        [self.delegate playerPanelCloseEvent];
    }
}

- (void)fullScreenButtonTouchUpInside:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPanelFullScreenEvent)]) {
        [self.delegate playerPanelFullScreenEvent];
    }
}

#pragma mark - TQPlayerPanelProtocol

- (void)updatePlayPanelWithLive:(BOOL)isLive{
    
}

- (void)updatePlayPanelWithLoading:(BOOL)isLoading{
    if (isLoading) {
        [self.playImageView setHidden:YES];
    }
}

- (void)updatePlayPanelWithPlaying:(BOOL)isPlaying{
    [self.playImageView setHidden:isPlaying];
}

- (void)updatePlayPanelWithDuration:(double)duration downloadProgress:(double)downloadProgress{
    // ignore
}

- (void)updatePlayPanelWithDuration:(double)duration playingProgress:(double)playingProgress{
    // ignore
}

- (void)showPlayPanelWithAnimationCompletion:(void (^)(BOOL finished))completion{
    self.playPanelHidden = NO;
    if (completion) {
        completion(YES);
    }
}

- (void)hiddenPlayPanelWithAnimationCompletion:(void (^)(BOOL finished))completion{
    self.playPanelHidden = YES;
    if (completion) {
        completion(YES);
    }
}

@end
