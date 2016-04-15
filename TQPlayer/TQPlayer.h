//
//  TQPlayer.h
//  TQPlayer
//
//  Created by qfu on 3/28/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQPlayer : NSObject

+ (instancetype)sharedPlayer;

- (void)playWithURL:(NSURL *)URL;
- (void)playWithURL:(NSURL *)URL live:(BOOL)live;
- (void)pause;
- (void)close;
- (void)resume;

@end
