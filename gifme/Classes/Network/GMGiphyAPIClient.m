//
//  GMGiphyAPIClient.m
//  gifme
//
//  Created by William Kalish on 2/12/15.
//  Copyright (c) 2015 William Kalish. All rights reserved.
//

#import "GMGiphyAPIClient.h"
#import "GMGifParser.h"

@interface GMGiphyAPIClient ()
@property (nonatomic, strong) NSURL *baseURL;
@end

@implementation GMGiphyAPIClient

+ (instancetype)sharedClient {
    static GMGiphyAPIClient *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GMGiphyAPIClient alloc] init];
        //@TODO: Base URL.
    });
    return _sharedManager;
}

- (void)searchGif:(NSString *)searchTerm completionHandler:(void (^)(NSArray *gifs, NSError *error))completionHandler {
    //@TODO: Implement search API call.
}

- (void)fetchTrendingGifs:(void (^)(NSArray *gifs, NSError *error))completionHandler {
    //@TODO: BONUS Implement Trending API call.
}

- (void)fetchGifsWithURL:(NSURL *)url completionHandler:(void (^)(NSArray *gifs, NSError *error))completionHandler {
    //@TODO: Common API implementation.
}

@end
