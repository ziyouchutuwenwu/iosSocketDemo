//
//  SendDataQueue.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import "SendDataQueue.h"

static SendDataQueue* _instance = nil;

@implementation SendDataQueue

+ (SendDataQueue*) shareInstance
{
    @synchronized(self)  {
        
        if ( nil == _instance )
        {
            _instance = [[SendDataQueue alloc] init];
        }
    }
    
    return _instance;
}

- (id) init
{
    if ( self = [super init] )
    {
        _queue = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (int) getSize
{
    return (int)_queue.count;
}

- (NSMutableData*) getDataBytes
{
    return _queue.peekHead;
}

- (void) addDataBytes:(NSMutableData*)dataBytes
{
    @synchronized(self)
    {
        [_queue enqueue:dataBytes];
    }
}

- (void) removeDataBytes
{
    @synchronized(self)
    {
        if ( _queue.count > 0)
        {
            [_queue dequeue];
        }
    }
}

- (void) clear
{
    @synchronized(self)
    {
        if ( _queue.count > 0)
        {
            [_queue removeAllObjects];
        }
    }
}

@end