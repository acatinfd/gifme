//
//  GMGifParser.m
//  gifme
//
//  Created by William Kalish on 2/12/15.
//  Copyright (c) 2015 William Kalish. All rights reserved.
//

#import "GMGifParser.h"

@implementation GMGifParser

- (NSArray *)parseGifsFromDictionary:(NSDictionary *)dict {
    NSArray *gifDicts = dict[@"data"];
    
    NSMutableArray *gifs = [[NSMutableArray alloc] init];

    // Why not use for-in loop?
    for (int i = 0; i < gifDicts.count; i++) {
        NSDictionary *gifDict = gifDicts[i];
        
        GMGif *gif = [[GMGif alloc] init];
        
        NSString *urlString = [gifDict valueForKeyPath:@"images.fixed_width.url"];
        gif.url = [NSURL URLWithString:urlString];
        
        [gifs addObject:gif];
    }
    
    return gifs;
}

@end
