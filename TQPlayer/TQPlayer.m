//
//  TQPlayer.m
//  TQPlayer
//
//  Created by qfu on 3/28/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayer.h"
#import "TQPlayerWindow.h"
#import "TQPlayerViewController.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>

@interface TQPlayer()

@property (nonatomic,strong) TQPlayerWindow *playerWindow;
@property (nonatomic,strong) CTCallCenter *callCenter;
@property (nonatomic,strong) NSMutableDictionary *callStateDictionary;

@end

@implementation TQPlayer

+ (instancetype)sharedPlayer{
    static id player = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        player = [[[self class] alloc] init];
    });
    return player;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        //处理来电后锁屏
        __weak __typeof__(self) weakSelf = self;
        self.callCenter = [[CTCallCenter alloc] init];
        self.callCenter.callEventHandler = ^(CTCall * call){
            TQPlayerViewController *playerViewController = [weakSelf currentPlayerViewController];
            BOOL isPlaying = playerViewController.isPlaying;
            if (weakSelf.callStateDictionary == nil){
                weakSelf.callStateDictionary = [NSMutableDictionary dictionary];
            }
            [weakSelf.callStateDictionary setObject:@(isPlaying) forKey:call.callState];
            if ([call.callState isEqualToString:CTCallStateIncoming]){
                if (isPlaying) {
                    [playerViewController pause];
                }
            } else if ([call.callState isEqualToString:CTCallStateDisconnected]){
                NSNumber *value = [weakSelf.callStateDictionary objectForKey:CTCallStateIncoming];
                if (value && [value boolValue]){
                    if (isPlaying == NO){
                        [playerViewController play];
                    }
                }
                weakSelf.callStateDictionary = nil;
            }
        };
    }
    return self;
}

#pragma mark - get & set

- (TQPlayerWindow *)playerWindow{
    if (_playerWindow == nil) {
        _playerWindow = [[TQPlayerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _playerWindow.windowLevel = UIWindowLevelStatusBar + 10;
    }
    return _playerWindow;
}

#pragma mark - public

- (void)playWithURL:(NSURL *)URL{
    if (URL == nil) {
        return;
    }
    [self playWithURL:URL live:NO];
}

- (void)playWithURL:(NSURL *)URL live:(BOOL)live{
    TQPlayerViewController *playerViewController = [self currentPlayerViewController];
    
    if (playerViewController) {
        [playerViewController.playerView playURL:URL];
    } else {
        TQPlayerViewController *viewController = [[TQPlayerViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        [viewController setPlayerPanelCloseblock:^{
            [weakSelf close];
        }];
        [self.playerWindow setRootViewController:viewController];
        [self.playerWindow makeKeyAndVisible];
        [viewController playURL:URL live:live];
        
        self.playerWindow.alpha = 0.0;
        [UIView animateWithDuration:0.45 animations:^{
            self.playerWindow.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)pause{
    TQPlayerViewController *playerViewController = [self currentPlayerViewController];
    if (playerViewController) {
        [playerViewController pause];
    }
}

- (void)close{
    [UIView animateWithDuration:0.45 animations:^{
        self.playerWindow.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.playerWindow) {
            self.playerWindow.rootViewController = nil;
            self.playerWindow = nil;
        }
    }];
}

- (void)resume{
    TQPlayerViewController *playerViewController = [self currentPlayerViewController];
    if (playerViewController) {
        [playerViewController play];
    }
}

#pragma mark - private

- (TQPlayerViewController *)currentPlayerViewController{
    if (self.playerWindow) {
        return (TQPlayerViewController *)self.playerWindow.rootViewController;
    }
    return nil;
}

#pragma mark - UIApplicationNotification

- (void)applicationDidBecomeActive:(id)sender{

}

- (void)applicationWillResignActive:(id)sender{

}

@end
