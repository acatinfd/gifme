//
//  ViewController.m
//  gifme
//
//  Created by William Kalish on 2/12/15.
//  Copyright (c) 2015 William Kalish. All rights reserved.
//

#import "GMViewController.h"
#import "GMGiphyAPIClient.h"

@interface GMViewController ()

@end

@implementation GMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GMGiphyAPIClient sharedClient] fetchTrendingGifs:^(id json, NSError *error) {
        NSLog(@"Trending JSON: %@", json);
    }];
    
    [[GMGiphyAPIClient sharedClient] searchGif:@"cat dog" completionHandler:^(id json, NSError *error) {
        NSLog(@"Search JSON: %@", json);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
