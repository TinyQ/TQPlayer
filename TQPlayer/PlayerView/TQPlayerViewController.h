//
//  TQPlayerViewController.h
//  TQPlayer
//
//  Created by qfu on 3/30/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQPlayerView.h"
#import "TQPlayerCountdownTrigger.h"

typedef NS_ENUM(NSInteger, TQPlayerViewControllerMode) {
    TQPlayerViewControllerFullScreenMode,
    TQPlayerViewControllerMiniScreenMode
};

typedef void(^TQPlayerPanelCloseblock)(void);

@interface TQPlayerViewController : UIViewController

@property (nonatomic,assign,readonly) TQPlayerViewControllerMode mode;
@property (nonatomic,strong,readonly) TQPlayerView *playerView;
@property (nonatomic,strong,readonly) TQPlayerCountdownTrigger *countdownTrigger;
@property (nonatomic,assign,readonly) BOOL isPlaying;
@property (nonatomic,assign,readonly) BOOL isLive;
@property (nonatomic,copy) TQPlayerPanelCloseblock playerPanelCloseblock;

- (instancetype)init;
- (void)playURL:(NSURL *)URL;
- (void)playURL:(NSURL *)URL live:(BOOL)live;
- (void)play;
- (void)pause;

@end
