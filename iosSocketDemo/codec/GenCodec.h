//
//  GenCodec.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecodeObject.h"

@interface GenCodec : NSObject

+ (NSMutableData*) encode:(short)cmd data:(NSString*)dataInfo;
+ (DecodeObject*) decode:(NSMutableData*)fullData;

@end