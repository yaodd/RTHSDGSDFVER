//
//  SearchViewController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-11-18.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "SearchViewController.h"
#import "SysbsModel.h"
#import "MyCourse.h"
#import "Course.h"
#import "File.h"
#import "CourseItem.h"
#import "CoursewareItem.h"
#import "MRCircularProgressView.h"
#import "UIButton+associate.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+category.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"
#import "UITapGestureRecognizer+category.h"
#import "CoursewareViewController.h"
#import "DownloadModel.h"
#import "MRProgressOverlayView.h"
NSString *PDFFolderName2 = @"PDF";
NSString *NOTEFolderName2 = @"NOTE";
#define PROGRESS_TAG 111111
#define MAX_DOWNLOAD_NUM 3

#define VIEW_NUMBER_TOTAL   5
#define BUTTON_WIDTH   226
#define BUTTON_HEIGHT  180
#define BUTTON_GAP     24


NSString *COVERFolderName2 = @"COVER";


@interface SearchViewController ()
{
    DownloadModel *downloadModel;
    ASINetworkQueue *queue;
    NSMutableDictionary *firstImageDict;
    MRProgressOverlayView *overlayView;
    
    NSInteger *firstViewIndex;
    NSInteger *lastViewIndex;
}
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *buttonViewArray;

@end

@implementation SearchViewController
@synthesize searchBar;
@synthesize courseDisplayArray;
@synthesize courseOriginArray;
@synthesize courseSV;
@synthesize coursewareDisplayArray;
@synthesize coursewareOriginArray;
@synthesize coursewareSV;
@synthesize courseNumLabel;
@synthesize coursewareNumLabel;
@synthesize buttonArray;
@synthesize downloadQueue;
@synthesize progressArray;
@synthesize buttonDisplayArray;
@synthesize labelArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]];

    downloadModel = [DownloadModel getDownloadModel];
    queue = downloadModel.queue;
    downloadModel.delegate = self;
    firstImageDict = downloadModel.firstImageDict;
    overlayView = [[MRProgressOverlayView alloc]initWithFrame:CGRectMake(1024 / 2, 768 / 2, overlayView.frame.size.width, overlayView.frame.size.height)];
    overlayView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.navigationController.view addSubview:overlayView];
    [overlayView show:YES];
    NSLog(@"queue count %d",[queue.operations count]);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMainPage:)];
    [backItem setTintColor:[UIColor redColor]];
//    [backItem setImage:[UIImage imageNamed:@"pptsearch_cancle"]];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = backItem;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 1024 - 50 - 100, 44)];
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    self.searchBar.delegate = self;
//    [self.searchBar becomeFirstResponder];第一响应
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 1024 - 50 - 100, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:searchBar];
    self.navigationItem.titleView = searchBar;

    if (![self downloadQueue]) {
        [self setDownloadQueue:[[ASINetworkQueue alloc]init]];
    }
    [self.downloadQueue reset];
    [self.downloadQueue setMaxConcurrentOperationCount:MAX_DOWNLOAD_NUM];      //最大同时下载数
    [self.downloadQueue setShowAccurateProgress:YES];        //是否显示详细进度
    [self.downloadQueue setShouldCancelAllRequestsOnFailure:NO];
    [self.downloadQueue setDelegate:self];    
    CGFloat viewY = 32.0f;
    CGFloat leftX = 35.0f;
    UIFont *font = [UIFont systemFontOfSize:20.0f];
    UIColor *redColor = [UIColor colorWithRed:116.0/255 green:31.0/ 255 blue:91.0/255 alpha:1.0];
    coursewareNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftX, viewY, 300, 50)];
    [courseNumLabel setTextAlignment:NSTextAlignmentLeft];
    [courseNumLabel setFont:font];
    [coursewareNumLabel setTextColor:redColor];
    [coursewareNumLabel setText:@"共找到0个课件"];
    [self.view addSubview:coursewareNumLabel];
    
    viewY += (50 + 0);
    coursewareSV = [[UIScrollView alloc]initWithFrame:CGRectMake(leftX, viewY, 1024 - leftX, 280)];
    [coursewareSV setDelegate:self];
    [self.view addSubview:coursewareSV];
    
    viewY += (280);
    courseNumLabel = [[UILabel alloc]
                      initWithFrame:CGRectMake(leftX, viewY, 300, 50)];
    [courseNumLabel setText:@"共找到0个课程"];
    [courseNumLabel setTextColor:redColor];
    [self.view addSubview:courseNumLabel];
    
    viewY += (50 + 0);
    courseSV = [[UIScrollView alloc]initWithFrame:CGRectMake(leftX, viewY, 1024 - leftX, 280)];
    [self.view addSubview:courseSV];
//    [self setScrollViewDatas];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(initSrollViewDatas) object:nil];
    [thread start];
//    [self initSrollViewDatas];
    
	// Do any additional setup after loading the view.
}
- (void) queueFailed{
    NSLog(@"failed");
}
- (void) queueFinished{
    NSLog(@"finished");
}
- (void) queueStarted{
    NSLog(@"started");
}

- (void) backToMainPage:(UIBarButtonItem *)backItem{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}
- (void)dealloc{
    for (ASIHTTPRequest *request in queue.operations) {
//        NSLog(@"cancel");
//        [request clearDelegatesAndCancel];
        request.downloadProgressDelegate = nil;
    }
    for (MRCircularProgressView *progress in progressArray) {
        [progress removeLink];
    }

}

- (void) initSrollViewDatas{
    buttonArray = [[NSMutableArray alloc]init];
    courseOriginArray = [[NSMutableArray alloc]init];
    courseDisplayArray = [[NSMutableArray alloc]init];
    coursewareDisplayArray = [[NSMutableArray alloc]init];
    coursewareOriginArray = [[NSMutableArray alloc]init];
    progressArray = [[NSMutableArray alloc]init];
    buttonDisplayArray = [[NSMutableArray alloc]init];
    
    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
    MyCourse *myCourse = sysbsModel.myCourse;
    courseOriginArray = myCourse.courseArr;
    courseDisplayArray = myCourse.courseArr;
//    [self performSelectorOnMainThread:@selector(setScrollViewDatas) withObject:nil waitUntilDone:YES];
    
    for (int i = 0; i < [courseOriginArray count]; i ++) {
        @autoreleasepool {
            
            Course *course = [courseOriginArray objectAtIndex:i];
            NSString *courseFolderName = [NSString stringWithFormat:@"%d",course.cid];
            NSString *contents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *PDFPath = [contents stringByAppendingPathComponent:PDFFolderName2];
            NSString *PDFCoursePath = [PDFPath stringByAppendingPathComponent:courseFolderName];
            [downloadModel createDir:PDFCoursePath];
            
            for (int k = 0; k < [course.fileArr count]; k ++) {
                @autoreleasepool {
                    
                    File *file = [course.fileArr objectAtIndex:k];
                    CoursewareItem *item = [[CoursewareItem alloc]init];
                    item.cid = courseFolderName;
                    item.PDFName = file.fileName;
                    item.PDFURL = file.filePath;
                    item.PDFPath = [PDFCoursePath stringByAppendingPathComponent:item.PDFName];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:item.PDFPath]) {
                        
                        UIImage *fImage = [firstImageDict objectForKey:item.PDFPath];
                        //                if (fImage == nil) {
                        //                    fImage = [downloadModel getFirstPageFromPDF:item.PDFPath];
                        //                    [firstImageDict setObject:fImage forKey:item.PDFPath];
                        //                }
                        
                        [item setPDFFirstImage:fImage];
                    }
                    else
                        [item setPDFFirstImage:nil];
                    [coursewareOriginArray addObject:item];
                    [coursewareDisplayArray addObject:item];
                }
            }
        }
    }

    [self performSelectorOnMainThread:@selector(setScrollViewDatas) withObject:nil waitUntilDone:YES];
    
    for (int i = 0 ; i < [coursewareOriginArray count]; i ++) {
        @autoreleasepool {
            
            CoursewareItem *item = [coursewareOriginArray objectAtIndex:i];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:item.PDFPath]) {
                if (item.PDFFirstImage == nil) {
                    UIImage *fImage = [firstImageDict objectForKey:item.PDFPath];
                    if (fImage == nil) {
                        fImage = [downloadModel getFirstPageFromPDF:item.PDFPath];
                        if (fImage != nil) {
                            [firstImageDict setObject:fImage forKey:item.PDFPath];
                        }
                    }
                    [item setPDFFirstImage:fImage];
                    
                    UIButton *button = (UIButton *)[coursewareSV viewWithTag:i + 1];
                    if ([button isKindOfClass:[UIButton class]]) {
                        [self performSelectorOnMainThread:@selector(updateButtonImage:) withObject:button waitUntilDone:YES];
                        //                [button setImage:item.PDFFirstImage forState:UIControlStateNormal];
                        
                    }
                }
            }
        }
        
    }
 
    //    [self performSelectorOnMainThread:@selector(setScrollViewDatas) withObject:nil waitUntilDone:YES];
    
}

- (void)updateButtonImage:(UIButton *)button{
//    [button removeFromSuperview];
    NSInteger index = button.tag - 1;
    CoursewareItem *item = [coursewareOriginArray objectAtIndex:index];
    UIImage *PDFFristImage = item.PDFFirstImage;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:item.PDFPath]) {
        
        [button setImage:PDFFristImage forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [button addTarget:self action:@selector(openCourseware:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        
        [button setImage:nil forState:UIControlStateNormal];
        [button addTarget:self action:@selector(courseItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void) setScrollViewDatas{
    for (UIView *subView in courseSV.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in coursewareSV.subviews) {
        [subView removeFromSuperview];
    }
    [coursewareNumLabel setText:[NSString stringWithFormat:@"共找到%d个课件",[coursewareDisplayArray count]]];
    [courseNumLabel setText:[NSString stringWithFormat:@"共找到%d个课程",[courseDisplayArray count]]];
    [coursewareSV setContentSize:CGSizeMake([coursewareDisplayArray count] * 250, 280)];
    buttonArray = [NSMutableArray array];
    
    for (int i = 0; i < [coursewareDisplayArray count]; i ++) {
        @autoreleasepool {
        
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(250 * i + 24, 20, 226, 180)];
            [button setTag:i + 1];
            [self.buttonArray addObject:button];
            
            //            UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(13, 140, 200, 10)];
            MRCircularProgressView *progressView = [[MRCircularProgressView alloc]initWithFrame:CGRectMake(63, 40, 100, 100)];
            [progressView setHidden:YES];
            [progressView setTag:PROGRESS_TAG];
            //            [progressView setProgressViewStyle:UIProgressViewStyleBar];
            [button addSubview:progressView];
            [self.progressArray addObject:progressView];
            
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(250 * i + 24, 280 - 20 - 50, 226, 50)];
            [label setHidden:YES];
            [label setLineBreakMode:NSLineBreakByCharWrapping];
            [label setNumberOfLines:0];
            //[label setText:name];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
            //        [label setTag:(i + 1) * 10000 + 10];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index", nil];
            [button setMyDict:dict];
            CoursewareItem *item = [self.coursewareDisplayArray objectAtIndex:i];
            NSString *PDFName = item.PDFName;
            UIImage *PDFFirstImage = item.PDFFirstImage;
            //        NSString *PDFPath = item.PDFPath;
            NSURL *PDFURL = [NSURL URLWithString:item.PDFURL];
            for (ASIHTTPRequest *request in queue.operations) {
                
                if ([request.url isEqual:PDFURL]) {
                    NSLog(@"request in");
                    [request setDownloadProgressDelegate:progressView];
                    
                    NSDictionary *requestDict = request.myDict;
                    NSString *filePath = [requestDict objectForKey:@"filePath"];
                    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index",filePath,@"filePath",item,@"item", nil];
                    [request setMyDict:dict];
                    [progressView setMyDict:dict];
                    [progressView setHidden:NO];
                }
            }
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:item.PDFPath]) {
                
                [button setImage:PDFFirstImage forState:UIControlStateNormal];
                [button setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
                [button addTarget:self action:@selector(openCourseware:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                
                [button setImage:nil forState:UIControlStateNormal];
                [button addTarget:self action:@selector(courseItemAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            UIImage *image = [UIImage imageNamed:@"pptsearch_ppt"];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
            
            
            [label setHidden:NO];
            [label setText:PDFName];
            
            
            
            [coursewareSV addSubview:button];
            [coursewareSV addSubview:label];
            [courseSV setContentOffset:CGPointZero];
            [coursewareSV setContentOffset:CGPointZero];
        }
    }
    
    int courseNumber = [courseDisplayArray count];
    [self.courseSV setContentSize:CGSizeMake(courseNumber * 250,280)];
    //从文件夹里面获取保存的封面图片
    NSString *contents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *coverFolder = [contents stringByAppendingPathComponent:COVERFolderName2];
    DownloadModel *downloadModel = [DownloadModel getDownloadModel];
    [downloadModel createDir:coverFolder];
    
    for (int i = 0;  i < courseNumber; i ++) {
        @autoreleasepool {
            NSString *coverPath = [coverFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i + 1]];
            NSData *data = [NSData dataWithContentsOfFile:coverPath];
            UIImage *image = [UIImage imageWithData:data];
            
            Course *course = [courseDisplayArray objectAtIndex:i];
            
            NSString *teacherName;
            if ([course.teacher count] > 0) {
                teacherName = ((User *)[course.teacher objectAtIndex:0]).username;
            } else{
                teacherName = @"";
            }
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:course.courseName,@"courseName",teacherName,@"teachName",course.startTime,@"date",image,@"courseImage", nil];
            CourseItem *courseItem = [[CourseItem alloc]initWithFrame:CGRectMake(20 + i * 250,20, 235, 235) dictionary:dict];
            UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToCourseware:)];
            NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:course.cid],@"tag", nil];
            [singleTapGesture setMyDict:myDict];
            
            [courseItem addGestureRecognizer:singleTapGesture];
            [self.courseSV addSubview:courseItem];

        }
    }

    [overlayView dismiss:YES];
}

- (void)openCourseware:(id)sender
{
    ////
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    UIButton *button = (UIButton *)sender;
    NSDictionary *dict = button.myDict;
    int index = [(NSNumber *)[dict objectForKey:@"index"] integerValue];
    CoursewareItem *item = [self.coursewareDisplayArray objectAtIndex:index];
    NSString *filePath = item.PDFPath;
    
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
        
        NSString *contents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *courseFolderName = item.cid;
        NSString *NOTEPath = [contents stringByAppendingPathComponent:NOTEFolderName2];
        NSString *NOTECoursePath = [NOTEPath stringByAppendingPathComponent:courseFolderName];
        NSString *NOTEPDFPath = [NOTECoursePath stringByAppendingPathComponent:[filePath lastPathComponent]];
        [downloadModel createDir:NOTEPDFPath];
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.notePath = NOTEPDFPath;
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
        //#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
        //		[self.navigationController pushViewController:readerViewController animated:YES];
        
        //#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        readerViewController.modalPresentationStyle = UIModalPresentationCustom;
        readerViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        
		[self presentViewController:readerViewController animated:YES completion:nil];
        
        //#endif // DEMO_VIEW_CONTROLLER_PUSH
	}
    
    
}

//跳转到课件页面
- (void)jumpToCourseware:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    NSDictionary *myDict = gesture.myDict;
    int index = [(NSNumber *)[myDict objectForKey:@"tag"] integerValue];
    
    CoursewareViewController *coursewareViewController = [[CoursewareViewController alloc]init];
    coursewareViewController.courseFolderName = [NSString stringWithFormat:@"%d",index];
    [self.navigationController pushViewController:coursewareViewController animated:YES];
}

//点击单个课件下载
- (void) courseItemAction:(id)sender
{
    NSLog(@"action");
    UIButton *button = (UIButton *)sender;
    NSDictionary *dict = button.myDict;
    
    int index = [(NSNumber *)[dict objectForKey:@"index"] integerValue];
    [self downloadPDF:index];
}
//下载单个课件
- (void) downloadPDF:(int)index
{
    NSLog(@"download");
    CoursewareItem *item = [coursewareDisplayArray objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:item.PDFURL];
    NSString *filePath = item.PDFPath;
    NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",filePath,@"filePath",item,@"item",[NSNumber numberWithInt:index],@"index", nil];
    
    
    UIButton *button = (UIButton *)[buttonArray objectAtIndex:index];
    MRCircularProgressView *progress = (MRCircularProgressView *)[button viewWithTag:PROGRESS_TAG];
    for (ASIHTTPRequest *request in queue.operations) {
        if ([request isExecuting]) {
            [request setQueuePriority:NSOperationQueuePriorityVeryLow];
            break;
        }
    }
    [downloadModel downloadByDict:myDict];
    for (ASIHTTPRequest *request in queue.operations/*self.downloadQueue.operations*/) {
        if ([request.url isEqual:url]) {
            [progress setMyDict:myDict];
            [progress setHidden:NO];
            [request setDownloadProgressDelegate:progress];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)

	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

#pragma serchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)_searchBar {
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    [self.searchBar resignFirstResponder];
    NSString *searchText = _searchBar.text;
    NSLog(@"click");
    if (searchText!=nil && searchText.length>0) {
        self.coursewareDisplayArray= [NSMutableArray array];
        self.buttonDisplayArray = [NSMutableArray array];
        for (int i = 0 ; i < [coursewareOriginArray count];i ++) {
            CoursewareItem *item = [coursewareOriginArray objectAtIndex:i];
//            UIButton *button = [buttonArray objectAtIndex:i];
            if ([self isMatch:searchText :item.PDFName]) {
                [self.coursewareDisplayArray addObject:item];
//                [self.buttonDisplayArray addObject:button];
                //                NSLog(@"%d",[displayArray count]);
            }
        }
        
        self.courseDisplayArray = [NSMutableArray array];
        for (int i = 0; i < [courseOriginArray count]; i ++) {
            Course *course = [courseOriginArray objectAtIndex:i];
            if ([self isMatch:searchText :course.courseName]) {
                [self.courseDisplayArray addObject:course];
            }
        }
        
//        [self.courseTableView reloadData];
        [self setScrollViewDatas];
    }
    else
    {
        self.coursewareDisplayArray = [NSMutableArray arrayWithArray:coursewareOriginArray];
        self.buttonDisplayArray = [NSMutableArray arrayWithArray:buttonArray];
//        [self.courseTableView reloadData];
        [self setScrollViewDatas];
    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:self.searchBar textDidChange:nil];
    [self.searchBar resignFirstResponder];
    //    NSLog(@"cancel");
}

- (BOOL)isMatch:(NSString *)searchText :(NSString *)originalText{
    BOOL result = YES;
    int start = 0;
    for (int i = 0; i < searchText.length; i ++) {
        unichar c = [searchText characterAtIndex:i];
        for (int k = start; k < originalText.length; k ++) {
            if (c == [originalText characterAtIndex:k]) {
                start = k + 1;
                break;
            }
            if (k == originalText.length - 1) {
                result = NO;
            }
        }
    }
    
    return result;
}

#pragma DownloadModelDelegate mark
- (void)downloadFinished:(MRCircularProgressView *)progressView{
    NSLog(@"downloadFinished");
    NSDictionary *myDict = progressView.myDict;
    int index = [(NSNumber *)[myDict objectForKey:@"index"] intValue];
    NSString *filePath = [myDict objectForKey:@"filePath"];    
    CoursewareItem *item = [myDict objectForKey:@"item"];
    if ([self.buttonArray count] > index) {
        UIButton *button = [self.buttonArray objectAtIndex:index];
        UIImage *image = [firstImageDict objectForKey:filePath];
        item.PDFFirstImage = image;
        [button setImage:image forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(openCourseware:) forControlEvents:UIControlEventTouchUpInside];
        [progressView setHidden:YES];
    }
    
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"%f",scrollView.contentOffset.x);
}

@end
