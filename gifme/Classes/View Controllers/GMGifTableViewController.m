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

static NSString * const GMDefaultSearchTerm = @"kitten";
static NSString * const GMGifCellReuseID = @"GMGifCellReuseID";

@implementation GMGifTableViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
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
    [[GMGiphyAPIClient sharedClient] searchGif:searchTerm completionHandler:^(id json, NSError *error) {
        GMGifParser *parser = [[GMGifParser alloc] init];
        weakSelf.gifs = [parser parseGifsFromDictionary:json];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gifs.count < 10 ? self.gifs.count : 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GMGifTableViewCell *cell = (GMGifTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:GMGifCellReuseID forIndexPath:indexPath];
    
    GMGif *gif = self.gifs[indexPath.row];

    if (!gif.data && !gif.isLoading) {
        gif.isLoading =  YES;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
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
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (![searchBar.text isEqualToString:@""]) {
        [self searchForGif:searchBar.text];
    }
}

@end
