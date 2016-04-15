//
//  TQPlayerHelper.m
//  TQPlayer
//
//  Created by qfu on 4/4/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerHelper.h"

@implementation TQPlayerHelper

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6){
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6){
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)color{
    return [self colorWithHexString:color alpha:1.0f];
}

+ (NSString *)timeStringFromSecondsValue:(int)seconds{
    int hours   = seconds / 3600;
    int minutes = (seconds / 60) % 60;
    int secs    = seconds % 60;
    NSString * retVal = nil;
    
    if (hours > 0) {
        retVal = [NSString stringWithFormat:@"%01d:%02d:%02d", hours, minutes, secs];
    } else {
        retVal = [NSString stringWithFormat:@"%02d:%02d", minutes, secs];
    }
    return retVal;
}

+ (UIWindow *)normalLevelWindow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows) {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    return nil;
}

+ (BOOL)shouldAutorotateFromWindow:(UIWindow *)window;{
    if (window.rootViewController == nil) {
        return NO;
    }
    UIViewController *controller = window.rootViewController;
    if (controller.presentedViewController){
        return [controller.presentedViewController shouldAutorotate];
    }
    return [controller shouldAutorotate];
}

+ (UIInterfaceOrientation)currentInterfaceOrientationFromWindow:(UIWindow *)window;{
    if ([[self class] shouldAutorotateFromWindow:window]){
        UIViewController *controller = window.rootViewController;
        if (controller.presentedViewController){
            controller = controller.presentedViewController;
        }
        return [[controller valueForKey:@"interfaceOrientation"] integerValue];
    } else {
        return UIInterfaceOrientationPortrait;
    }
}

+ (CGFloat)degreesFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation{
    
    //用来计算从1个用户方向转换到另一个用户方向需要转动的角度。
    
    //           ↑   ↓   ←   →
    //   *   0   1   2   3   4
    //
    //   0   0   0   0   0   0
    //
    // ↑ 1   0   0  180 90  -90
    //
    // ↓ 2   0  180  0  -90  90
    //
    // ← 3   0  -90  90  0  180
    //
    // → 4   0   90 -90 180   0
    
    int table[5][5] =
    {
        {0,  0,  0,  0,  0},
        {0,  0,180, 90,-90},
        {0,180,  0,-90, 90},
        {0,-90, 90,  0,180},
        {0, 90,-90,180,  0},
    };
    
    CGFloat radians = 0;
    
    if (fromOrientation <= 4 && toOrientation <= 4){
        radians = table[fromOrientation][toOrientation];
    }
    
    return radians;
}

+ (void)updateWindow:(UIWindow *)window toInterfaceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated{
    NSString *selector = @"_updateToInterfaceOrientation:animated:";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL mySelector = NSSelectorFromString(selector);
#pragma clang diagnostic pop
    NSMethodSignature * sig = [[window class] instanceMethodSignatureForSelector:mySelector];
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature: sig];
    [myInvocation setTarget:window];
    [myInvocation setSelector: mySelector];
    [myInvocation setArgument:&orientation atIndex:2];
    [myInvocation setArgument:&animated atIndex:3];
    [myInvocation retainArguments];
    [myInvocation invoke];
}

+ (void)updateWindow:(UIWindow *)window toInterfaceOrientation:(UIInterfaceOrientation)orientation completion:(void (^)(BOOL finished))completion{
    [[self class] updateWindow:window toInterfaceOrientation:orientation animated:YES];
    NSTimeInterval duration = 0;
    duration += [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    duration += 0.01;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(YES);
        }
    });
}

+ (void)updateWindow:(UIWindow *)window toInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(double)duration force:(BOOL)force{
    NSString *selector = @"_updateToInterfaceOrientation:duration:force:";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL mySelector = NSSelectorFromString(selector);
#pragma clang diagnostic pop
    NSMethodSignature * sig = [[window class] instanceMethodSignatureForSelector:mySelector];
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature: sig];
    [myInvocation setTarget:window];
    [myInvocation setSelector: mySelector];
    [myInvocation setArgument:&orientation atIndex:2];
    [myInvocation setArgument:&duration atIndex:3];
    [myInvocation setArgument:&force atIndex:4];
    [myInvocation retainArguments];
    [myInvocation invoke];
}

+ (void)updateWindow:(UIWindow *)window rotatableViewOrientation:(UIInterfaceOrientation)orientation updateStatusBar:(BOOL)updateStatusBar duration:(double)duration{
    NSString *selector = @"_setRotatableViewOrientation:updateStatusBar:duration:";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL mySelector = NSSelectorFromString(selector);
#pragma clang diagnostic pop
    NSMethodSignature * sig = [[window class] instanceMethodSignatureForSelector:mySelector];
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:sig];
    [myInvocation setTarget:window];
    [myInvocation setSelector: mySelector];
    [myInvocation setArgument:&orientation atIndex:2];
    [myInvocation setArgument:&updateStatusBar atIndex:3];
    [myInvocation setArgument:&duration atIndex:4];
    [myInvocation retainArguments];
    [myInvocation invoke];
}

+ (UIView *)iOSAVPlayerView{
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows) {
        for (UIWindow *window in windows) {
            NSString *windowClassName = [NSString stringWithUTF8String:object_getClassName(window)];
            if ([windowClassName isEqualToString:@"UIWindow"] && window.rootViewController) {
                UIView *view = window.rootViewController.view;
                UIView *videoView = nil;
                for (UIView *item in view.subviews){
                    NSString *itemName = [NSString stringWithUTF8String:object_getClassName(item)];
                    //NSKVONotifying_AVPlayerView
                    if (itemName){
                        if ([@"AVPlayerView" isEqualToString:itemName] || [@"NSKVONotifying_AVPlayerView" isEqualToString:itemName]){
                            videoView = item;
                            break;
                        }
                    }
                    //NSLog(@"itemName : %@",itemName);
                }
                if (videoView) {
                    return videoView;
                }
                break;
            }
        }
    }
    return nil;
}

+ (BOOL)isShowiOSAVPlayerView{
    UIView *player = [[self class] iOSAVPlayerView];
    return player != nil;
}

+ (UIWindow *)TQPlayerWindow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows) {
        for (UIWindow *window in windows) {
            NSString *windowClassName = [NSString stringWithUTF8String:object_getClassName(window)];
            if ([windowClassName isEqualToString:@"TQPlayerWindow"]) {
                return window;
            }
        }
    }
    return nil;
}

@end
