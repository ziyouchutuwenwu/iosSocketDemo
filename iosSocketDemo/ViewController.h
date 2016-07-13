//
//  ViewController.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

@interface ViewController : UIViewController<ISocketStatus,ISocketResponse>
{
    AsyncSocket*    _socket;
}

- (IBAction) connectButtonTapped:(id)sender;
- (IBAction) sendButtonTapped:(id)sender;

@end