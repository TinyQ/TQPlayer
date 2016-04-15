//
//  TQPlayerWindow.m
//  TQPlayer
//
//  Created by qfu on 3/28/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerWindow.h"
#import "TQPlayerViewController.h"

@implementation TQPlayerWindow

- (void)sendEvent:(UIEvent *)event{
    [super sendEvent:event];
    if (event.type == UIEventTypeTouches) {
        TQPlayerViewController *playerViewController = (TQPlayerViewController *)self.rootViewController;
        if (playerViewController){
            [playerViewController.countdownTrigger reset];
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    TQPlayerViewController *playerViewController = (TQPlayerViewController *)self.rootViewController;
    
    if (playerViewController && playerViewController.playerView){
        UIView *playerView = playerViewController.playerView;
        CGPoint convertPoint = [self convertPoint:point toView:playerView];
        return CGRectContainsPoint(playerView.bounds, convertPoint);
    } else {
        return NO;
    }
}

@end
