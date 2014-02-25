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
@synthesize firstImageDict;

+(DownloadModel *)getDownloadModel{
    if (sharedModel == nil) {
        sharedModel = [[DownloadModel alloc]init];
        
    }
    return sharedModel;
}
- (id)init{
    self = [super init];
    if (self) {
        if (!queue) {
            self.queue = [[ASINetworkQueue alloc]init];
            [self.queue reset];
            [self.queue setShowAccurateProgress:YES];
            [self.queue setShouldCancelAllRequestsOnFailure:NO];
            [self.queue setMaxConcurrentOperationCount:MAX_DOWNLOAD_NUM];
            [self.queue setDelegate:self];
        }
        self.firstImageDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}
//下载全部
- (void)downloadAll{
    
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

//取消全部
- (void)cancelAll{
    [queue cancelAllOperations];
}
//下载单个
- (void)downloadByDict:(NSDictionary *)dict{
    NSURL *url = [dict objectForKey:@"url"];
    NSString *filePath = [dict objectForKey:@"filePath"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        //                NSLog(@"return");
//        isContinue = YES;
        return;
    }
    BOOL isExist = NO;
    for (ASIHTTPRequest *tempRequest in queue.operations) {
        if ([tempRequest.url isEqual:url]) {
            [tempRequest setQueuePriority:NSOperationQueuePriorityVeryHigh];
            isExist = YES;
            NSLog(@"yes");
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
        [request setQueuePriority:NSOperationQueuePriorityVeryHigh];
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
    NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:request,@"request",filePath,@"filePath", nil];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImageSelector:) object:myDict];
    [thread start];
    
    
}

- (void)loadImageSelector:(NSDictionary *)dict{
    NSString *filePath = [dict objectForKey:@"filePath"];
    ASIHTTPRequest *request = [dict objectForKey:@"request"];
    UIImage *image = [self getFirstPageFromPDF:filePath];
    NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:filePath,@"filePath",image,@"image",request,@"request", nil];
    [self performSelectorOnMainThread:@selector(sendToDelegate:) withObject:myDict waitUntilDone:YES];
}
- (void)sendToDelegate:(NSDictionary *)dict{
    NSString *filePath = [dict objectForKey:@"filePath"];
    UIImage *image = [dict objectForKey:@"image"];
    ASIHTTPRequest *request = [dict objectForKey:@"request"];
    [firstImageDict setObject:image forKey:filePath];
    if (request.downloadProgressDelegate != nil) {
        [self.delegate downloadFinished:(MRCircularProgressView *)request.downloadProgressDelegate];
    }
}

- (UIImage *)getFirstPageFromPDF:(NSString *)aFilePath{
    //	CFStringRef path;
    //	CFURLRef url;
	CGPDFDocumentRef document;
    
    NSURL *nsurl = [[NSURL alloc]initFileURLWithPath:aFilePath isDirectory:NO];
    
    CFURLRef url = (__bridge CFURLRef)nsurl;
    //    CFURLRef url = CFRetain((__bridge CFTypeRef)(nsurl));
    
    
	document = CGPDFDocumentCreateWithURL(url);
    //	CFRelease(url);
    
	int count = CGPDFDocumentGetNumberOfPages (document);
    if (count == 0) {
        CGPDFDocumentRelease(document);
		return nil;
    }
    
    //	return document;
    
    CGPDFPageRef page = CGPDFDocumentGetPage(document, 1);
    
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    pageRect.origin = CGPointZero;
    if (pageRect.size.width < pageRect.size.height) {
        CGFloat len = pageRect.size.width;
        pageRect.size.width = pageRect.size.height;
        pageRect.size.height = len;
    }
    
    NSLog(@"pdf size %f %f",pageRect.size.width,pageRect.size.height);
    //开启图片绘制 上下文
    UIGraphicsBeginImageContext(pageRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置白色背景
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,pageRect);
    
    CGContextSaveGState(context);
    
    //进行翻转
    CGContextTranslateCTM(context, 0.0, pageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, pageRect, 0, true));
    
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGPDFDocumentRelease(document);
    
    //CGPDFDocumentRelease(document);
    //UIImage *image = [self getUIImageFromPDFPage:0 pdfPage:page];
    //    CGPDFPageRelease(page);
    //CGPDFDocumentRelease(document);
    return image;
    //return image;
    //    CGPDFDocumentRelease(document), document = NULL;
}

//下载出错处理
- (void) requestWentWrong:(ASIHTTPRequest *)request{
    NSLog(@"download error : %@",request.error );
    NSLog(@"url %@",request.url);
    if (request.downloadProgressDelegate != nil) {
        [request.downloadProgressDelegate setHidden:YES];
        
        request.downloadProgressDelegate = nil;
    }
}

@end
