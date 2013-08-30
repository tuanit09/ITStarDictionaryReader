//
//  ITWordEntry.m
//  Example
//
//  Created by Nguyen Anh Tuan on 26/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITWordEntry.h"

@implementation ITWordEntry

- (id)initWithWord:(NSString *)word offset:(NSUInteger)offset length:(NSUInteger)length
{
    if (self = [super init]) {
        _word = word;
        _offset = offset;
        _length = length;
    }
    return self;
}

@end
