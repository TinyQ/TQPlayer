//
//  ViewController.m
//  Demo
//
//  Created by qfu on 4/15/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "ViewController.h"
#import "TQPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 100, 100, 100);
    [self.view addSubview:button];
}

- (void)buttonTouch:(id)sender{
    
    //NSString *liveURL = @"http://vevoplaylist-live.hls.adaptive.level3.net/vevo/ch1/appleman.m3u8";
    
    NSString *urlString = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
    
    //NSString *urlString = @"http://www.quirksmode.org/html5/videos/big_buck_bunny.mp4";
    //NSString *urlString = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    [[TQPlayer sharedPlayer] playWithURL:URL live:NO];
}

@end
