//
//  DataObject.h
//  iosSocketDemo
//
//  Created by mmc on 16/7/14.
//  Copyright © 2016年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataObject : NSObject

@property (nonatomic, strong) NSMutableData* data;
@property (nonatomic, assign) int length;

@end