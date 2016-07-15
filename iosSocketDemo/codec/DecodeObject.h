//
//  DecodeObject.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecodeObject : NSObject

@property (nonatomic, assign) short          cmd;
@property (nonatomic, copy  ) NSString* dataInfo;

@end