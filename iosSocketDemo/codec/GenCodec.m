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

+ (NSMutableData*) encode:(short)cmd data:(NSString*)dataInfo
{
    NSMutableData* data = [NSMutableData dataWithData:[dataInfo dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableData* dataBytes = [NSMutableData dataWithCapacity:0];
    [dataBytes appendData:[BytesConverter shortToData:htons(cmd)]];
    [dataBytes appendData:data];
    
    return dataBytes;
}

+ (DecodeObject*) decode:(NSMutableData*)fullData
{
    DecodeObject* object = [[DecodeObject alloc] init];
    
    NSMutableData* dataBytes = [NSMutableData dataWithBytes:([fullData bytes] + 2) length:fullData.length -2];
    NSString* response = [[NSString alloc] initWithData:dataBytes encoding:NSUTF8StringEncoding];
    
    object.cmd = ntohs([BytesConverter dataToShort:fullData]);
    object.dataInfo = response;
    
    return object;
}

@end