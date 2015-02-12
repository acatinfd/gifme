//
//  GMGiphyAPIClient.m
//  gifme
//
//  Created by William Kalish on 2/12/15.
//  Copyright (c) 2015 William Kalish. All rights reserved.
//

#import "GMGiphyAPIClient.h"

@implementation GMGiphyAPIClient

+ (instancetype)sharedClient {
    static GMGiphyAPIClient *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GMGiphyAPIClient alloc] init];
    });
    return _sharedManager;
}

- (void)fetchTrendingGifs:(void (^)(id json, NSError* error))completionHandler {
    NSURL *url = [NSURL URLWithString:@"http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"];
    [self fetchGifsWithURL:url completionHandler:completionHandler];
}

- (void)searchGif:(NSString *)searchTerm completionHandler:(void (^)(id json, NSError* error))completionHandler {
    NSString *urlSafeSearchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q=%@&api_key=dc6zaTOxFJmzC", urlSafeSearchTerm];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self fetchGifsWithURL:url completionHandler:completionHandler];
}

- (void)fetchGifsWithURL:(NSURL *)url completionHandler:(void (^)(id json, NSError* error))completionHandler {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil, error);
                });
            } else {
                NSError *jsonError = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(json, jsonError);
                });
            }
        }
    }];
    
    [task resume];
}

@end
