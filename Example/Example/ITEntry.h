//
//  ITEntry.h
//  Example
//
//  Created by Nguyen Anh Tuan on 26/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITEntry : NSObject

@property (strong, nonatomic)       NSString        *word;      // word
@property (assign, nonatomic)       long            offset;     // offset in data file
@property (assign, nonatomic)       long            length;     // length to retrieve in data file

@end
