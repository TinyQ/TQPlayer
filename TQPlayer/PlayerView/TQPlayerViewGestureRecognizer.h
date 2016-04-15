//
//  TQPlayerViewGestureRecognizer.h
//  TQPlayer
//
//  Created by qfu on 4/9/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQPlayerViewController.h"

typedef NS_ENUM(NSInteger, TQPlayerViewTouchStatus) {
    TQPlayerViewIdleTouch,
    TQPlayerViewLeftHalfVerticalTouch,
    TQPlayerViewRightHalfVerticalTouch,
    TQPlayerViewFullScreenHorizontalTouch,
    TQPlayerViewMiniModeDragTouch,
};

typedef NS_ENUM(NSInteger, TQPlayerViewRecognizerState) {
    TQPlayerViewRecognizerStateBegan,
    TQPlayerViewRecognizerStateChanged,
    TQPlayerViewRecognizerStateEnded,
    TQPlayerViewRecognizerStateBeginDecelerating,
    TQPlayerViewRecognizerStateEndDecelerating,
};

@protocol TQPlayerViewGestureRecognizerDelegate;

@interface TQPlayerViewGestureRecognizer : NSObject

@property (nonatomic,weak) id <TQPlayerViewGestureRecognizerDelegate> delegate;
@property (nonatomic,assign,readonly) TQPlayerViewTouchStatus touchStatus;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL isLeftHalfVerticalTouching;
@property (nonatomic) BOOL isRightHalfVerticalTouching;
@property (nonatomic) BOOL isFullScreenHorizontalTouch;

- (instancetype)initWithPlayerView:(UIView *)playerView;;

@end

@protocol TQPlayerViewGestureRecognizerDelegate <NSObject>

- (TQPlayerViewControllerMode)playerViewModeInRecognizer:(TQPlayerViewGestureRecognizer *)recognizer;
- (CGSize)minSizeOfPlayerViewInMiniMode;
- (CGSize)maxSizeOfPlayerViewInMiniMode;
- (void)playerViewRecognizer:(TQPlayerViewGestureRecognizer *)recognizer leftHalfVerticalTouchVariable:(float)variable oldVariable:(float)oldVariable recognizerState:(TQPlayerViewRecognizerState)state touching:(inout BOOL *)touching;
- (void)playerViewRecognizer:(TQPlayerViewGestureRecognizer *)recognizer rightHalfVerticalTouchVariable:(float)variable oldVariable:(float)oldVariable recognizerState:(TQPlayerViewRecognizerState)state touching:(inout BOOL *)touching;
- (void)playerViewRecognizer:(TQPlayerViewGestureRecognizer *)recognizer fullScreenHorizontalTouchVariable:(float)variable recognizerState:(TQPlayerViewRecognizerState)state touching:(inout BOOL *)touching;
- (void)playerViewRecognizerClicked;
- (void)playerViewRecognizerDoubleClicked;

@end
