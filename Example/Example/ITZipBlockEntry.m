//
//  ITZipBlockEntry.m
//  ITStarDicConverter
//
//  Created by Nguyen Anh Tuan on 10/09/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITZipBlockEntry.h"

@implementation ITZipBlockEntry

-(id)init
{
    if (self = [super init]) {
        _zipOffset = 0;
        _dataOffset = 0;
        _zipSize = 0;
        _dataSize = 0;
    }
    return self;
}

-(id)initWithBytes:(Byte *)bytes
{
    if (self = [super init]) {
        _zipOffset = *((uint32_t *)bytes);
        _dataOffset = *((uint32_t *)bytes + 1);
        _zipSize = *((uint32_t *)bytes + 2);
        _dataSize = *((uint32_t *)bytes + 3);
    }
    return self;
}

+(NSUInteger)size
{
    return sizeof(uint32_t) * 4;
}

@end
