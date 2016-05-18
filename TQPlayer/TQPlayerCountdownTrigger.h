//
//  TQCountdownTrigger.h
//  TQPlayer
//
//  Created by qfu on 4/13/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TQTimeUnit) {
    TQTimeSecond = 1,
    TQTimeMinute = TQTimeSecond * 60,
    TQTimeHours = TQTimeMinute * 60,
};

@interface TQPlayerCountdownTrigger : NSObject


- (instancetype)initWithTarget:(id)aTarget
                      selector:(SEL)aSelector
                     tickTimes:(unsigned long int)aTickTimes
                      tickUnit:(TQTimeUnit)aTickUnit
                       repeats:(BOOL)yesOrNo;

- (void)pause;
- (void)resume;
- (void)reset;
- (void)invalidate;

@end
