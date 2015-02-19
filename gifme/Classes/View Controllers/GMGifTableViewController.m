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
#import "GMGifTableViewCell.h"

@implementation GMGifTableViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Accessors

#pragma mark - Private methods

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //@TODO: Return GIF count.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //@TODO: Display a GIF cell.
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //@TODO: Share selected GIF.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //@TODO: Dismiss Keyboard.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //@TODO: Dismiss Keyboard.

    //@TODO: Search GIFs
}

@end
