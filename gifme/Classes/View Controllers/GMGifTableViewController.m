//
//  GMGifTableViewController.m
//  gifme
//
//  Created by William Kalish on 2/12/15.
//  Copyright (c) 2015 William Kalish. All rights reserved.
//

#import "GMGifTableViewController.h"

#import "AnimatedGIFImageSerialization.h"

#import "GMGiphyAPIClient.h"
#import "GMGifParser.h"

#import "GMGifTableViewCell.h"

static NSString * const GMGifCellReuseID = @"GMGifCellReuseID";

@implementation GMGifTableViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    __weak __typeof(self) weakSelf = self;
    [[GMGiphyAPIClient sharedClient] searchGif:@"cat dog" completionHandler:^(id json, NSError *error) {
        GMGifParser *parser = [[GMGifParser alloc] init];
        weakSelf.gifs = [parser parseGifsFromDictionary:json];
    }];
}

#pragma mark - Accessors

- (void)setGifs:(NSArray *)gifs {
    if (_gifs != gifs) {
        _gifs = gifs;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GMGifTableViewCell *cell = (GMGifTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GMGifCellReuseID forIndexPath:indexPath];
    
    GMGif *gif = self.gifs[indexPath.row];

    if (!gif.data && !gif.isLoading) {
        gif.isLoading =  YES;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            gif.data = [NSData dataWithContentsOfURL:gif.url];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                cell.gifImageView.image = [UIImage imageWithData:gif.data];
                gif.isLoading = NO;
            });
        });
    }
    else {
        cell.gifImageView.image = [UIImage imageWithData:gif.data];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GMGif *gif = self.gifs[indexPath.row];
    
    [[UIPasteboard generalPasteboard] setString:gif.url.absoluteString];
}

@end
