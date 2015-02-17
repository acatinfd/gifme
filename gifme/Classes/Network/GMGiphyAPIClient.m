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
        _sharedManager.baseURL = [NSURL URLWithString:@"http://api.giphy.com/v1/gifs/"];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                          diskCapacity:20 * 1024 * 1024
                                                              diskPath:nil];
        [NSURLCache setSharedURLCache:cache];
    });
    return _sharedManager;
}

- (void)fetchTrendingGifs:(void (^)(NSArray *gifs, NSError* error))completionHandler {
    NSURL *url = [NSURL URLWithString:@"trending" relativeToURL:self.baseURL];
    [self fetchGifsWithURL:url completionHandler:completionHandler];
}

- (void)searchGif:(NSString *)searchTerm completionHandler:(void (^)(NSArray *gifs, NSError* error))completionHandler {
    NSString *urlSafeSearchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *searchEndpoint = [NSString stringWithFormat:@"search?q=%@", urlSafeSearchTerm];
    NSURL *url = [NSURL URLWithString:searchEndpoint relativeToURL:self.baseURL];
    
    [self fetchGifsWithURL:url completionHandler:completionHandler];
}

- (void)fetchGifsWithURL:(NSURL *)url completionHandler:(void (^)(id json, NSError* error))completionHandler {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:self.baseURL];
    
    NSString *apiKey = @"api_key=dc6zaTOxFJmzC";
    if (urlComponents.query) {
        urlComponents.query = [NSString stringWithFormat:@"%@&%@", urlComponents.query, apiKey];
    } else {
        urlComponents.query = apiKey;
    }
    
    NSURL *apiURL = urlComponents.URL;
    NSURLRequest *request = [NSURLRequest requestWithURL:apiURL];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil, error);
                });
            } else {
                NSError *jsonError = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonError];
                
                if (jsonError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(nil, jsonError);
                    });
                } else {
                    GMGifParser *parser = [[GMGifParser alloc] init];
                    NSArray *gifs = [parser parseGifsFromDictionary:json];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(gifs, nil);
                    });
                }
            }
        }
    }];
    
    [task resume];
}

@end
