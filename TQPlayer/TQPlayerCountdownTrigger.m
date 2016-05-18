//
//  TQCountdownTrigger.m
//  TQPlayer
//
//  Created by qfu on 4/13/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "TQPlayerCountdownTrigger.h"

@interface TQPlayerCountdownTrigger()

@property (nonatomic) unsigned long int tickTimes;
@property (nonatomic) TQTimeUnit tickUnit;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic) unsigned long int handles;
@property (nonatomic) BOOL ispaused;

@property (nonatomic,weak) id target;
@property (nonatomic) SEL selector;

@end

@implementation TQPlayerCountdownTrigger

- (instancetype)initWithTarget:(id)aTarget
                      selector:(SEL)aSelector
                     tickTimes:(unsigned long int)aTickTimes
                      tickUnit:(TQTimeUnit)aTickUnit
                       repeats:(BOOL)yesOrNo;{
    self = [super init];
    if (self) {
        self.target = aTarget;
        self.selector = aSelector;
        self.tickTimes = aTickTimes;
        self.tickUnit  = aTickUnit;
        [self reset];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.tickUnit
                                                      target:self
                                                    selector:@selector(tick:)
                                                    userInfo:nil
                                                     repeats:yesOrNo];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
    }
}

#pragma mark - public

- (void)pause{
    self.ispaused = YES;
}

- (void)resume{
    self.ispaused = NO;
}

- (void)reset{
    self.handles = self.tickTimes;
}

- (void)invalidate{
    if (self.timer) {
        [self.timer invalidate];
    }
}

#pragma mark - tick

- (void)tick:(id)sender{
    if (self.ispaused) {
        return;
    }
    
    if (self.handles != 0) {
        self.handles --;
    }
    else
    {
        [self reset];
        
        if (self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
        }
    }
}

@end




