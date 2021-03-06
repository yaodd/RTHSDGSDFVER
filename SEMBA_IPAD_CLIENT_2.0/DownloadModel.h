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
#import "MRCircularProgressView.h"
@class DownloadModel;
@protocol DownloadModelDelegate <NSObject>

@optional

- (void) downloadFinished:(MRCircularProgressView *)progressView;
- (void) downloadWrong:(MRCircularProgressView *)progressView;

@end
@interface DownloadModel : NSObject

@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) MyCourse *myCourse;
@property (nonatomic, assign) id<DownloadModelDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *firstImageDict;
+(DownloadModel *)getDownloadModel;
- (void) createDir:(NSString *)dirPath;
- (UIImage *)getFirstPageFromPDF:(NSString *)aFilePath;
- (void)downloadAll;
- (void)cancelAll;
- (void)downloadByDict:(NSDictionary *)dict;
@end
