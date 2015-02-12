//
//  GMGifTableViewCell.m
//  gifme
//
//  Created by William Kalish on 2/12/15.
//  Copyright (c) 2015 William Kalish. All rights reserved.
//

#import "GMGifTableViewCell.h"

@implementation GMGifTableViewCell

- (void)prepareForReuse {
    self.gifImageView.image = nil;
}

@end
