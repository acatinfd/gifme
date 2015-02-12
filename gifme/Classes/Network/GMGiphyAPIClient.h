//
//  GMGiphyAPIClient.h
//  gifme
//
//  Created by William Kalish on 2/12/15.
//  Copyright (c) 2015 William Kalish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMGiphyAPIClient : NSObject

+ (instancetype)sharedClient;

- (void)fetchTrendingGifs:(void (^)(id json, NSError* error))completionHandler;
- (void)searchGif:(NSString *)searchTerm completionHandler:(void (^)(id json, NSError* error))completionHandler;

@end
