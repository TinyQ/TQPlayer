//
//  TQPlayerResources.h
//  TQPlayer
//
//  Created by qfu on 4/10/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultSizeOfPlayerViewInMiniMode (CGSizeMake(320, 320 * 9 / 16))
#define kMinSizeOfPlayerViewInMiniMode (CGSizeMake(160, 160 * 9 / 16))

@interface TQPlayerResources : NSObject

+ (UIImage *)close;
+ (UIImage *)full;
+ (UIImage *)pause;
+ (UIImage *)play;
+ (UIImage *)progress;
+ (UIImage *)brightness;

@end
