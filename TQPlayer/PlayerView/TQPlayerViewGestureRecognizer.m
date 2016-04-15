//
//  TQPlayerViewGestureRecognizer.m
//  TQPlayer
//
//  Created by qfu on 4/9/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerViewGestureRecognizer.h"

@interface TQPlayerViewGestureRecognizer() <UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIView *playerView;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic,assign) TQPlayerViewTouchStatus touchStatus;
@property (nonatomic,assign) float lastScale;
@property (nonatomic,assign) CGFloat oldRightHalfVerticalTouchVariable;
@property (nonatomic,assign) CGFloat oldLeftHalfVerticalTouchVariable;

@end

@implementation TQPlayerViewGestureRecognizer

- (instancetype)initWithPlayerView:(UIView *)playerView;
{
    self = [super init];
    if (self) {
        self.playerView = playerView;
        
        if (self.playerView){
            self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handlePanGestureRecognizer:)];
            self.panGestureRecognizer.maximumNumberOfTouches = 1;
            
            self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handlePinchGestureRecognizer:)];
            
            self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTapGestureRecognizer:)];
            self.tapGestureRecognizer.numberOfTapsRequired = 1;
            
            self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleDoubleTapGestureRecognizer:)];
            self.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
            
            [self.tapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
            
            [self.playerView addGestureRecognizer:self.panGestureRecognizer];
            [self.playerView addGestureRecognizer:self.pinchGestureRecognizer];
            [self.playerView addGestureRecognizer:self.tapGestureRecognizer];
            [self.playerView addGestureRecognizer:self.doubleTapGestureRecognizer];
        }
    }
    return self;
}

- (void)dealloc
{
    if (self.playerView) {
        [self.playerView removeGestureRecognizer:self.panGestureRecognizer];
        [self.playerView removeGestureRecognizer:self.pinchGestureRecognizer];
        [self.playerView removeGestureRecognizer:self.tapGestureRecognizer];
        [self.playerView removeGestureRecognizer:self.doubleTapGestureRecognizer];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (_enabled != enabled) {
        _enabled = enabled;

        self.panGestureRecognizer.enabled = enabled;
        self.pinchGestureRecognizer.enabled = enabled;
        self.tapGestureRecognizer.enabled = enabled;
        self.doubleTapGestureRecognizer.enabled = enabled;
    }
}

#pragma mark - GestureRecognizer

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    if (self.playerView == nil) {
        return;
    }
    
    CGPoint translation = [recognizer translationInView:self.playerView];
    CGPoint location = [recognizer locationInView:self.playerView];
    
    switch (recognizer.state){
        case UIGestureRecognizerStateBegan:{
            [self playerViewPanBegan:recognizer translation:translation location:location];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self playerViewPanChanged:recognizer translation:translation location:location];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            [self playerViewPanEnded:recognizer translation:translation location:location];
        }
            break;
        default:
            break;
    }
}

- (void)playerViewPanBegan:(UIPanGestureRecognizer *)recognizer translation:(CGPoint)translation location:(CGPoint)location
{
    if (self.delegate == nil) {
        return;
    }
    
    TQPlayerViewControllerMode mode = [self.delegate playerViewModeInRecognizer:self];
    
    if (mode == TQPlayerViewControllerFullScreenMode)
    {
        if([self isFullScreenHorizontalTouchWithTranslation:translation location:location])
        {
            self.touchStatus = TQPlayerViewFullScreenHorizontalTouch;
            float value = translation.x / self.playerView.bounds.size.width;
            self.isFullScreenHorizontalTouch = YES;
            BOOL * touching = &_isFullScreenHorizontalTouch;
            [self.delegate playerViewRecognizer:self fullScreenHorizontalTouchVariable:value recognizerState:TQPlayerViewRecognizerStateBegan touching:touching];
            return;
        }
        else
        {
            if ([self isLeftHalfVerticalTouchWithTranslation:translation location:location])
            {
                self.touchStatus = TQPlayerViewLeftHalfVerticalTouch;
                float value = translation.y / [self playerViewLeftHalfRect].size.height;
                self.oldLeftHalfVerticalTouchVariable = 0.0;
                self.isLeftHalfVerticalTouching = YES;
                BOOL * touching = &_isLeftHalfVerticalTouching;
                [self.delegate playerViewRecognizer:self leftHalfVerticalTouchVariable:value oldVariable:self.oldLeftHalfVerticalTouchVariable recognizerState:TQPlayerViewRecognizerStateBegan touching:touching];
                return;
            }
            else if([self isRightHalfVerticalTouchWithTranslation:translation location:location])
            {
                self.touchStatus = TQPlayerViewRightHalfVerticalTouch;
                float value = translation.y / [self playerViewRightHalfRect].size.height;
                self.oldRightHalfVerticalTouchVariable = 0.0;
                self.isRightHalfVerticalTouching = YES;
                BOOL * touching = &_isRightHalfVerticalTouching;
                [self.delegate playerViewRecognizer:self rightHalfVerticalTouchVariable:value oldVariable:self.oldRightHalfVerticalTouchVariable recognizerState:TQPlayerViewRecognizerStateBegan touching:touching];
                return;
            }
        }
    }
    else if(mode == TQPlayerViewControllerMiniScreenMode)
    {
        self.touchStatus = TQPlayerViewMiniModeDragTouch;
        
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.playerView.superview];
        if (recognizer.view.superview) {
            [recognizer.view.superview layoutIfNeeded];
        }
    }
}

- (void)playerViewPanChanged:(UIPanGestureRecognizer *)recognizer translation:(CGPoint)translation location:(CGPoint)location
{
    // in phone 6s & plus,in UIGestureRecognizerStateBegan, some unknown F make translation is (0,0) when 3D Touch is on status;
    //
    if (self.touchStatus == TQPlayerViewIdleTouch)
    {
        [self playerViewPanBegan:recognizer translation:translation location:location];
    }
    // for fix
    
    if (self.touchStatus == TQPlayerViewIdleTouch)
    {
        return;
    }
    else if (self.touchStatus == TQPlayerViewLeftHalfVerticalTouch)
    {
        if (self.delegate) {
            float value = translation.y / [self playerViewLeftHalfRect].size.height;
            BOOL * touching = &_isLeftHalfVerticalTouching;
            [self.delegate playerViewRecognizer:self leftHalfVerticalTouchVariable:value oldVariable:self.oldLeftHalfVerticalTouchVariable recognizerState:TQPlayerViewRecognizerStateChanged touching:touching];
            self.oldLeftHalfVerticalTouchVariable = value;
        }
    }
    else if(self.touchStatus == TQPlayerViewRightHalfVerticalTouch)
    {
        if (self.delegate) {
            float value = translation.y / [self playerViewRightHalfRect].size.height;
            BOOL * touching = &_isRightHalfVerticalTouching;
            [self.delegate playerViewRecognizer:self rightHalfVerticalTouchVariable:value oldVariable:self.oldRightHalfVerticalTouchVariable recognizerState:TQPlayerViewRecognizerStateChanged touching:touching];
            self.oldRightHalfVerticalTouchVariable = value;
        }
    }
    else if(self.touchStatus == TQPlayerViewFullScreenHorizontalTouch)
    {
        if (self.delegate) {
            float value = translation.x / self.playerView.bounds.size.width;
            BOOL * touching = &_isFullScreenHorizontalTouch;
            [self.delegate playerViewRecognizer:self fullScreenHorizontalTouchVariable:value recognizerState:TQPlayerViewRecognizerStateChanged touching:touching];
        }
    }
    else if(self.touchStatus == TQPlayerViewMiniModeDragTouch)
    {
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.playerView.superview];
        if (recognizer.view.superview) {
            [recognizer.view.superview layoutIfNeeded];
        }
    }
}

- (void)playerViewPanEnded:(UIPanGestureRecognizer *)recognizer translation:(CGPoint)translation location:(CGPoint)location
{
    if (self.touchStatus == TQPlayerViewLeftHalfVerticalTouch)
    {
        if (self.delegate) {
            float value = translation.y / [self playerViewLeftHalfRect].size.height;
            self.isLeftHalfVerticalTouching = NO;
            BOOL * touching = &_isLeftHalfVerticalTouching;
            [self.delegate playerViewRecognizer:self leftHalfVerticalTouchVariable:value oldVariable:self.oldLeftHalfVerticalTouchVariable recognizerState:TQPlayerViewRecognizerStateEnded touching:touching];
        }
    }
    else if(self.touchStatus == TQPlayerViewRightHalfVerticalTouch)
    {
        if (self.delegate) {
            float value = translation.y / [self playerViewRightHalfRect].size.height;
            self.isRightHalfVerticalTouching = NO;
            BOOL * touching = &_isRightHalfVerticalTouching;
            [self.delegate playerViewRecognizer:self rightHalfVerticalTouchVariable:value oldVariable:self.oldRightHalfVerticalTouchVariable recognizerState:TQPlayerViewRecognizerStateEnded touching:touching];
        }
    }
    else if(self.touchStatus == TQPlayerViewFullScreenHorizontalTouch)
    {
        if (self.delegate) {
            float value = translation.x / self.playerView.bounds.size.width;
            self.isFullScreenHorizontalTouch = NO;
            BOOL * touching = &_isFullScreenHorizontalTouch;
            [self.delegate playerViewRecognizer:self fullScreenHorizontalTouchVariable:value recognizerState:TQPlayerViewRecognizerStateEnded touching:touching];
        }
    }
    else if(self.touchStatus == TQPlayerViewMiniModeDragTouch)
    {
        CGPoint velocity = [recognizer velocityInView:self.playerView];
        
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        
        CGFloat x_min = self.playerView.bounds.size.width / 2;
        CGFloat x_max = self.playerView.superview.bounds.size.width - x_min;
        CGFloat y_min = self.playerView.bounds.size.height / 2;
        CGFloat y_max = self.playerView.superview.bounds.size.height - y_min;
        
        finalPoint.x = MIN(MAX(finalPoint.x, x_min), x_max);
        finalPoint.y = MIN(MAX(finalPoint.y, y_min), y_max);
        
        [UIView animateWithDuration:slideFactor delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
            if (recognizer.view.superview) {
                [recognizer.view.superview layoutIfNeeded];
            }
        } completion:^(BOOL finished) {
            self.touchStatus = TQPlayerViewIdleTouch;
        }];
    }
    
    if (self.touchStatus != TQPlayerViewIdleTouch && self.touchStatus != TQPlayerViewMiniModeDragTouch){
        self.touchStatus = TQPlayerViewIdleTouch;
    }
}

- (void)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer
{
    if (self.playerView == nil || self.delegate == nil) {
        return;
    }
    
    TQPlayerViewControllerMode mode = [self.delegate playerViewModeInRecognizer:self];
    if(mode == TQPlayerViewControllerMiniScreenMode)
    {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.lastScale = 1.0;
        }
        
        // Scale
        CGFloat scale = 1.0 - (self.lastScale - recognizer.scale);
        
        CGFloat width = self.playerView.bounds.size.width * scale;
        CGFloat height = self.playerView.bounds.size.height * scale;
        CGFloat x = self.playerView.frame.origin.x - (width - self.playerView.bounds.size.width) / 2.0;
        CGFloat y = self.playerView.frame.origin.y - (height - self.playerView.bounds.size.height) / 2.0;
        
        if (width <= [self.delegate maxSizeOfPlayerViewInMiniMode].width && width >= [self.delegate minSizeOfPlayerViewInMiniMode].width){
            self.playerView.frame = CGRectMake(x, y, width, height);
            if (self.playerView.superview) {
                [self.playerView.superview layoutIfNeeded];
            }
        }
        
        self.lastScale = recognizer.scale;
        
        if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
            CGSize size_MIN = [self.delegate minSizeOfPlayerViewInMiniMode];
            CGSize size_MAX = [self.delegate maxSizeOfPlayerViewInMiniMode];
            
            if (width > size_MAX.width){
                width  = size_MAX.width;
                height = width * self.playerView.bounds.size.height / self.playerView.bounds.size.width;
            } else if (self.playerView.frame.size.width < size_MIN.width){
                width  = size_MIN.width;
                height = width * self.playerView.bounds.size.height / self.playerView.bounds.size.width;
            }
            
            CGPoint finalPoint = self.playerView.frame.origin;
            
            CGFloat x_min = 0;
            CGFloat x_max = self.playerView.superview.bounds.size.width;
            CGFloat y_min = 0;
            CGFloat y_max = self.playerView.superview.bounds.size.height;
            finalPoint.x = MIN(MAX(finalPoint.x, x_min), x_max);
            finalPoint.y = MIN(MAX(finalPoint.y, y_min), y_max);
            
            [UIView animateWithDuration:0.25 animations:^{
                self.playerView.frame = CGRectMake(finalPoint.x, finalPoint.y, width, height);
                if (self.playerView.superview) {
                    [self.playerView.superview layoutIfNeeded];
                }
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate) {
        [self.delegate playerViewRecognizerClicked];
    }
}

- (void)handleDoubleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate) {
        [self.delegate playerViewRecognizerDoubleClicked];
    }
}

#pragma mark - helper

- (CGRect)playerViewLeftHalfRect
{
    return (CGRect){
        .origin = CGPointZero,
        .size.width = self.playerView.bounds.size.width / 2.0,
        .size.height = self.playerView.bounds.size.height,
    };
}

- (CGRect)playerViewRightHalfRect
{
    return (CGRect){
        .origin.x = self.playerView.bounds.size.width / 2.0,
        .origin.y = 0,
        .size.width = self.playerView.bounds.size.width / 2.0,
        .size.height = self.playerView.bounds.size.height,
    };
}

- (BOOL)isLeftHalfVerticalTouchWithTranslation:(CGPoint)translation location:(CGPoint)location
{
    return (fabs(translation.x) < fabs(translation.y) && CGRectContainsPoint([self playerViewLeftHalfRect], location));
}

- (BOOL)isRightHalfVerticalTouchWithTranslation:(CGPoint)translation location:(CGPoint)location
{
    return (fabs(translation.x) < fabs(translation.y) && CGRectContainsPoint([self playerViewRightHalfRect], location));
}

- (BOOL)isFullScreenHorizontalTouchWithTranslation:(CGPoint)translation location:(CGPoint)location
{
    return  fabs(translation.x) > fabs(translation.y);
}

@end
