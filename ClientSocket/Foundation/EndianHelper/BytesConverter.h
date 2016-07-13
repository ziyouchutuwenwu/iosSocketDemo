//
//  BytesConverter.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BytesConverter : NSObject

+ (NSMutableData*) byteToData:(Byte)i;
+ (NSMutableData*) shortToData:(short)i;
+ (NSMutableData*) intToData:(int)i;

+ (Byte) dataToByte:(NSMutableData*)data;
+ (short) dataToShort:(NSMutableData*)data;
+ (int) dataToInt:(NSMutableData*)data;

@end