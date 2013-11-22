//
//  DownloadModel.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-11-22.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "DownloadModel.h"
#import "Course.h"
#import "File.h"
#import "ASIHTTPRequest+category.h"

#define MAX_DOWNLOAD_NUM    5

static DownloadModel *sharedModel = nil;
NSString *PDFFolderName = @"PDF";
NSString *NOTEFolderName = @"NOTE";

@implementation DownloadModel
@synthesize queue;
@synthesize myCourse;

+(DownloadModel *)getDownloadModel{
    if (sharedModel == nil) {
        sharedModel = [[DownloadModel alloc]init];
    }
    return sharedModel;
}
//下载全部
- (void)downloadAll{
    if (!queue) {
        queue = [[ASINetworkQueue alloc]init];
        [queue reset];
        [queue setShowAccurateProgress:YES];
        [queue setShouldCancelAllRequestsOnFailure:NO];
        [queue setMaxConcurrentOperationCount:MAX_DOWNLOAD_NUM];
        [queue setDelegate:self];
    }
    for (Course *course in myCourse.courseArr) {
//        NSLog(@"download");
        NSString *courseFolderName = [NSString stringWithFormat:@"%d",course.cid];
        NSString *contents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *PDFPath = [contents stringByAppendingPathComponent:PDFFolderName];
        NSString *PDFCoursePath = [PDFPath stringByAppendingPathComponent:courseFolderName];
        [self createDir:PDFCoursePath];
        for (File *file in course.fileArr) {
            BOOL isContinue = NO;
            NSURL *url = [NSURL URLWithString:file.filePath];
            NSString *fileName = file.fileName;
            NSString *filePath = [PDFCoursePath stringByAppendingPathComponent:fileName];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath]) {
//                NSLog(@"return");
                isContinue = YES;
            }

            for (ASIHTTPRequest *tempRequest in queue.operations) {
                if ([tempRequest.originalURL isEqual:url]) {
                    isContinue = YES;
                    break;
                }
            }
            if (isContinue) {
                continue;
            }
            
            
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:filePath,@"filePath", nil];
            ASIHTTPRequest *request= [ASIHTTPRequest requestWithURL:url];
            [request setDelegate:self];
            [request setMyDict:dict];
            [request setDidFinishSelector:@selector(requestDone:)];     //下载完成处理
            [request setDidFailSelector:@selector(requestWentWrong:)];  //下载出错处
            [queue addOperation:request];
            
        }
        
    }
//    NSLog(@"queue count %d",[queue.operations count]);
    [queue go];
    
}
//下载单个
- (void)downloadByDict:(NSDictionary *)dict{
    NSURL *url = [dict objectForKey:@"url"];
    NSString *filePath = [dict objectForKey:@"filePath"];
    BOOL isExist = NO;
    for (ASIHTTPRequest *tempRequest in queue.operations) {
        if ([tempRequest.originalURL isEqual:url]) {
            [tempRequest setQueuePriority:NSOperationQueuePriorityVeryHigh];
            isExist = YES;
            break;
        }
    }
    if (!isExist) {
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:filePath,@"filePath", nil];
        ASIHTTPRequest *request= [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request setMyDict:dict];
        [request setDidFinishSelector:@selector(requestDone:)];     //下载完成处理
        [request setDidFailSelector:@selector(requestWentWrong:)];  //下载出错处
        [queue addOperation:request];
        [queue go];
    }
}
//create a director
- (void) createDir:(NSString *)dirPath
{
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

//下载完成
- (void) requestDone:(ASIHTTPRequest *)request{
//    NSLog(@"finish");
    NSDictionary *dict = request.myDict;
    NSString *filePath = [dict objectForKey:@"filePath"];
    [request.responseData writeToFile:filePath atomically:YES];
//    UIImage *image = [self getFirstPageFromPDF:filePath];
}
//下载出错处理
- (void) requestWentWrong:(ASIHTTPRequest *)request{
    NSLog(@"download error : %@",request.error );
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"出错啦！" message:@"网络连接出错，请检查网络！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
//    int index = request.tag;
//    UIButton *button = [self.buttonArray objectAtIndex:index];
    //    UIProgressView *progressView = (UIProgressView *)[button viewWithTag:PROGRESS_TAG];
}

@end
