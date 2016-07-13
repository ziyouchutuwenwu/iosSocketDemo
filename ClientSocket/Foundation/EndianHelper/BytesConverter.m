//
//  BytesConverter.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import "BytesConverter.h"

@implementation BytesConverter

+ (NSMutableData*) byteToData:(Byte)i
{
    NSMutableData* data = [NSMutableData dataWithBytes: &i length: sizeof(Byte)];
    return data;
}

+ (NSMutableData*) shortToData:(short)i
{
    NSMutableData* data = [NSMutableData dataWithBytes: &i length: sizeof(short)];
    return data;
}

+ (NSMutableData*) intToData:(int)i
{
    NSMutableData* data = [NSMutableData dataWithBytes: &i length: sizeof(int)];
    return data;
}

+ (Byte) dataToByte:(NSMutableData*)data
{
    Byte value;
    [data getBytes: &value length: sizeof(Byte)];
    
    return value;
}

+ (short) dataToShort:(NSMutableData*)data
{
    short value;
    [data getBytes: &value length: sizeof(short)];
    
    return value;
}

+ (int) dataToInt:(NSMutableData*)data
{
    int value;
    [data getBytes: &value length: sizeof(int)];
    
    return value;
}

@end