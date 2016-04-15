//
//  ShowPlayerViewController.m
//  Demo
//
//  Created by qfu on 4/16/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "ShowPlayerViewController.h"
#import "TQPlayer.h"

@interface ShowPlayerViewController ()

@end

@implementation ShowPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int y = 20;
    
    y += 50;
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, y, self.view.bounds.size.width - 20 - 20, 40);
        button.backgroundColor = [UIColor cyanColor];
        [button setTitle:@"play mp4" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playMp4Touch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    y += 50;
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, y, self.view.bounds.size.width - 20 - 20, 40);
        button.backgroundColor = [UIColor cyanColor];
        [button setTitle:@"play live" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playLiveTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)playMp4Touch:(id)sender{
    NSURL *URL = [NSURL URLWithString:@"http://www.quirksmode.org/html5/videos/big_buck_bunny.mp4"];
    [[TQPlayer sharedPlayer] playWithURL:URL];
}

- (void)playLiveTouch:(id)sender{
    
    NSString *liveURL = @"http://vevoplaylist-live.hls.adaptive.level3.net/vevo/ch1/appleman.m3u8";
    
    //NSString *urlString = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
    
    NSURL *URL = [NSURL URLWithString:liveURL];
    [[TQPlayer sharedPlayer] playWithURL:URL live:YES];
}

@end
