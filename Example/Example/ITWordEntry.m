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

-(NSData *)data
{
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendData:[self.word dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[NSData dataWithBytes:&_offset length:sizeof(UInt32)]];
    [data appendData:[NSData dataWithBytes:&_length length:sizeof(UInt32)]];
    return data;
}

@end
