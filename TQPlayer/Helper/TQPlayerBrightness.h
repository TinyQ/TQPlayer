//
//  TQPlayerBrightnessView.h
//  TQPlayer
//
//  Created by qfu on 4/13/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQPlayerBrightness : NSObject

@property(nonatomic) CGFloat brightness;

+ (instancetype)sharedBrightnessView;

@end
