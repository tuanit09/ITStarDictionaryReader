//
//  NSString+ZipFileName.m
//  ITStarDicConverter
//
//  Created by Nguyen Anh Tuan on 11/09/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "NSString+ZipFileName.h"


@implementation NSString (ZipFileName)

-(NSString *)infoFileName
{
    return [self stringByReplacingOccurrencesOfString:kZipFileExtension withString:kZipInfoFileExtension];
}
-(NSString *)indexFileName
{
    return [self stringByReplacingOccurrencesOfString:kZipFileExtension withString:kZipIndexFileExtension];
}
-(NSString *)dataFileName
{
    return [self stringByReplacingOccurrencesOfString:kZipFileExtension withString:kZipDataBlockFileExtension];
}
-(NSString *)blockEntryFileName
{
    return [self stringByReplacingOccurrencesOfString:kZipFileExtension withString:kZipBlockEntryFileExtension];
}
-(NSString *)synFileName
{
    return [self stringByReplacingOccurrencesOfString:kZipFileExtension withString:kZipSynFileExtension];
}

@end
