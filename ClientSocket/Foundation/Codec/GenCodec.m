//
//  GenCodec.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import "GenCodec.h"
#import "BytesConverter.h"

@implementation GenCodec

+ (NSMutableData*) encode:(short)cmd data:(NSMutableData*)data
{
    NSMutableData* dataBytes = [NSMutableData dataWithCapacity:0];
    [dataBytes appendData:[BytesConverter shortToData:htons(cmd)]];
    [dataBytes appendData:data];
    
    return dataBytes;
}

+ (DecodeObject*) decode:(NSMutableData*)fullData fullDataLen:(int)fullDataLen
{
    DecodeObject* object = [[DecodeObject alloc] init];
    
    object.cmd = ntohs([BytesConverter dataToShort:fullData]);
    object.dataBytes = [NSMutableData dataWithBytes:([fullData bytes] + 2) length:fullDataLen -2];
    
    return object;
}

@end