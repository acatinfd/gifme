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
#import "GMGif.h"

#import "GMGifTableViewCell.h"

static NSString * const GMDefaultSearchTerm = @"cats";
static NSString * const GMGifCellReuseID = @"GMGifCellReuseID";

@implementation GMGifTableViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self searchForGif:GMDefaultSearchTerm];
}

#pragma mark - Accessors

- (void)setGifs:(NSArray *)gifs {
    if (_gifs != gifs) {
        _gifs = gifs;
        [self.tableView reloadData];
    }
}

#pragma mark - Private methods

- (void)searchForGif:(NSString *)searchTerm {
    __weak __typeof(self) weakSelf = self;
    [[GMGiphyAPIClient sharedClient] searchGif:searchTerm completionHandler:^(NSArray *gifs, NSError *error) {
        weakSelf.gifs = gifs;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gifs.count < 10 ? self.gifs.count : 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GMGifTableViewCell *cell = (GMGifTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:GMGifCellReuseID forIndexPath:indexPath];
    
    GMGif *gif = self.gifs[indexPath.row];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        NSData *gifData = [NSData dataWithContentsOfURL:gif.url];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            cell.gifImageView.image = [UIImage imageWithData:gifData];
        });
    });
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GMGif *gif = self.gifs[indexPath.row];

    [[UIPasteboard generalPasteboard] setString:gif.url.absoluteString];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];

    if (![searchBar.text isEqualToString:@""]) {
        [self searchForGif:searchBar.text];
    }
}

@end
