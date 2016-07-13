//
//  PackageHeader.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageHeader : NSObject

+ (int) size;

+ (NSMutableData*) setDataSizeBytes:(NSInteger)dataSize;
+ (int) getHeaderDataLen:(NSMutableData*)buffer;

@end