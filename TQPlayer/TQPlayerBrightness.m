//
//  TQPlayerBrightnessView.m
//  TQPlayer
//
//  Created by qfu on 4/13/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerBrightness.h"
#import "TQPlayerHelper.h"
#import "TQPlayerCountdownTrigger.h"
#import "TQPlayerResources.h"

#pragma mark - TQPlayerBrightnessView

@interface TQPlayerBrightnessView : UIView

@property (nonatomic,strong) UIView *brightnessContainer;

- (void)updateUIWithbrightness:(CGFloat)brightness;

@end

@implementation TQPlayerBrightnessView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,0, 155, 155);
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.backgroundColor = [UIColor clearColor];
        
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        effectview.frame = self.bounds;
        effectview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:effectview];
        
        UILabel *titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
        titleLabel.text          = @"亮度";
        titleLabel.font          = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor     = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.alpha         = 0.7;
        [self addSubview:titleLabel];
        
        UIImageView *brightnessImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        brightnessImage.image        = [TQPlayerResources brightness];
        brightnessImage.center       = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        brightnessImage.alpha        = 0.7;
        [self addSubview:brightnessImage];
        
        UIView *brightnessContainer = [[UIView alloc] init];
        brightnessContainer.frame  = CGRectMake(13, 132, self.bounds.size.width - 26, 7);
        brightnessContainer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [self addSubview:brightnessContainer];
        self.brightnessContainer = brightnessContainer;
    }
    return self;
}

- (void)layoutSubviews{
    if (self.superview.bounds.size.width > self.superview.bounds.size.height) {
        //Landscape
        self.center = CGPointMake(self.superview.bounds.size.width / 2 + 0.5, (self.superview.bounds.size.height) / 2);
    } else {
        //Portrait
        self.center = CGPointMake(self.superview.bounds.size.width / 2 + 0.5, (self.superview.bounds.size.height - 10) / 2 + 0.5);
    }
}

- (void)updateUIWithbrightness:(CGFloat)brightness{
    const int count = 16;
    const int space = 1;
    if (self.brightnessContainer.subviews.count <= 0) {
        for (int i = 0 ; i < count; i++) {
            CGFloat h = self.brightnessContainer.bounds.size.height - space * 2;
            CGFloat y = space;
            CGFloat w = (self.brightnessContainer.bounds.size.width - (count * space + space)) / count;
            CGFloat x = i * (w + space) + space;
            
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(x, y, w, h);
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i;
            [self.brightnessContainer addSubview:view];
        }
    }
    
    int index = brightness / (1.0 / count);
    
    for (UIView *view in self.brightnessContainer.subviews) {
        if (view.tag < index ) {
            view.hidden = NO;
        } else {
            view.hidden = YES;
        }
    }
}

@end

#pragma mark - TQPlayerBrightness

@interface TQPlayerBrightness()

@property (nonatomic,strong) TQPlayerCountdownTrigger *countdownTrigger;

@end

@implementation TQPlayerBrightness

+ (instancetype)sharedBrightnessView{
    static id view = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        view = [[[self class] alloc] init];
    });
    return view;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - get & set

- (CGFloat)brightness{
    return [UIScreen mainScreen].brightness;
}

- (void)setBrightness:(CGFloat)brightness{
    [UIScreen mainScreen].brightness = brightness;
    [self showBrightnessViewWith:brightness];
    [self.countdownTrigger reset];
}

- (TQPlayerCountdownTrigger *)countdownTrigger{
    if (_countdownTrigger == nil) {
        _countdownTrigger = [[TQPlayerCountdownTrigger alloc] initWithTarget:self
                                                                    selector:@selector(countdownTriggerTimeUp:)
                                                                   tickTimes:1
                                                                    tickUnit:TQTimeSecond
                                                                     repeats:YES];
    }
    return _countdownTrigger;
}

#pragma mark - private

- (void)showBrightnessViewWith:(CGFloat)brightness{
    UIWindow *window = [TQPlayerHelper TQPlayerWindow];
    TQPlayerBrightnessView *brightnessView = [self brightnessView];
    if (brightnessView == nil) {
        brightnessView = [[TQPlayerBrightnessView alloc] init];
        [window addSubview:brightnessView];
    }
    [brightnessView updateUIWithbrightness:brightness];
}

- (TQPlayerBrightnessView *)brightnessView{
    TQPlayerBrightnessView *brightnessView = nil;
    UIWindow *window = [TQPlayerHelper TQPlayerWindow];
    if (window) {
        for (UIView *view in window.subviews) {
            if ([view isKindOfClass:[TQPlayerBrightnessView class]]) {
                brightnessView = (TQPlayerBrightnessView *)view;
                break;
            }
        }
    }
    return brightnessView;
}

#pragma mark - CountdownTriggerTimeUp

- (void)countdownTriggerTimeUp:(id)sender{
    __block TQPlayerBrightnessView *brightnessView = [self brightnessView];
    if (brightnessView) {
        [UIView animateWithDuration:0.5 animations:^{
            brightnessView.alpha = 0;
        } completion:^(BOOL finished) {
            [brightnessView removeFromSuperview];
            brightnessView.alpha = 1;
        }];
    }
    [self.countdownTrigger invalidate];
    self.countdownTrigger = nil;
}

@end
