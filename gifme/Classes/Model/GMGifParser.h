//
//  GMGifParser.h
//  gifme
//
//  Created by William Kalish on 2/12/15.
//  Copyright (c) 2015 William Kalish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMGifParser : NSObject

- (NSArray *)parseGifsFromDictionary:(NSDictionary *)dict;

@end
