//
//  PackageHeader.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import "PackageHeader.h"
#import "BytesConverter.h"

@implementation PackageHeader

static const int HEADER_SIZE_2 = 2;
static const int HEADER_SIZE_4 = 4;

+ (int) size
{
    return HEADER_SIZE_4;
}

+ (NSMutableData*) setDataSizeBytes:(NSInteger)dataSize
{
    NSMutableData* dataSizeBytes = nil;
    
    if ( [self size] == HEADER_SIZE_2 )
    {
        dataSizeBytes = [BytesConverter shortToData:htons((short)dataSize)];
    }
    else if ( [self size] == HEADER_SIZE_4 )
    {
        dataSizeBytes = [BytesConverter intToData:htonl((int)dataSize)];
    }
    
    return dataSizeBytes;
}

+ (int) getHeaderDataLen:(NSMutableData*)buffer
{
    int headerDataLen = 0;
    
    if ( [self size] == HEADER_SIZE_2 )
    {
        headerDataLen = ntohs([BytesConverter dataToShort:buffer]);
    }
    else if ( [self size] == HEADER_SIZE_4 )
    {
        headerDataLen = ntohl([BytesConverter dataToInt:buffer]);
    }
    
    return headerDataLen;
}

@end