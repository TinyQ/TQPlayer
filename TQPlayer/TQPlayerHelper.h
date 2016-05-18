//
//  TQPlayerHelper.h
//  TQPlayer
//
//  Created by qfu on 4/4/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TQPlayerDegreesToRadians(x) ((x) * M_PI / 180.0)

@interface TQPlayerHelper : NSObject

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (NSString *)timeStringFromSecondsValue:(int)seconds;

+ (UIWindow *)normalLevelWindow;

+ (BOOL)shouldAutorotateFromWindow:(UIWindow *)window;

+ (UIInterfaceOrientation)currentInterfaceOrientationFromWindow:(UIWindow *)window;

+ (CGFloat)degreesFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation;

+ (void)updateWindow:(UIWindow *)window toInterfaceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

+ (void)updateWindow:(UIWindow *)window toInterfaceOrientation:(UIInterfaceOrientation)orientation completion:(void (^)(BOOL finished))completion;

+ (void)updateWindow:(UIWindow *)window toInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(double)duration force:(BOOL)force;

+ (void)updateWindow:(UIWindow *)window rotatableViewOrientation:(UIInterfaceOrientation)orientation updateStatusBar:(BOOL)updateStatusBar duration:(double)duration;

+ (UIView *)iOSAVPlayerView;

+ (BOOL)isShowiOSAVPlayerView;

+ (UIWindow *)TQPlayerWindow;

@end
