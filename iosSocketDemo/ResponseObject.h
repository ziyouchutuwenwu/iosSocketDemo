//
//  ResponseObject.h
//  iosSocketDemo
//
//  Created by mmc on 16/7/14.
//  Copyright © 2016年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseObject : NSObject

@property (nonatomic, assign ) short cmd;
@property (nonatomic, assign ) NSString* response;

@end