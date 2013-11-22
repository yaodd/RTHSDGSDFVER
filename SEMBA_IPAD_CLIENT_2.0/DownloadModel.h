//
//  DownloadModel.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-11-22.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MyCourse.h"
@class DownloadModel;

@interface DownloadModel : NSObject

@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) MyCourse *myCourse;
+(DownloadModel *)getDownloadModel;

- (void)downloadAll;
- (void)downloadByDict:(NSDictionary *)dict;
@end
