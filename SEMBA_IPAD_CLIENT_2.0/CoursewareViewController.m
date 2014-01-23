//
//	ReaderDemoController.m
//	Reader v2.7.0
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2013 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CoursewareViewController.h"
#import "ReaderViewController.h"
#import "UIButton+associate.h"
#import "ASIHTTPRequest.h"
#import "CoursewareItem.h"
#import "ASIHTTPRequest+category.h"
#import "MRCircularProgressView.h"
#import "File.h"
#import "Course.h"
#import "MyCourse.h"
#import "SysbsModel.h"
#import "DownloadModel.h"
#import "ASINetworkQueue.h"
#define ITEM_NUM_IN_ROW     4
#define MAX_DOWNLOAD_NUM    3
#define PROGRESS_TAG 111111

NSString *PDFFolderName3 = @"PDF";
NSString *NOTEFolderName3 = @"NOTE";


@interface CoursewareViewController () <ReaderViewControllerDelegate>
{
    DownloadModel *downloadModel;
    ASINetworkQueue *queue;
    NSMutableDictionary *firstImageDict;
}
@end

@implementation CoursewareViewController
@synthesize courseTableView;
@synthesize PDFPathArray;
@synthesize PDFUrlArray;
@synthesize progressArray;
@synthesize downloadQueue;
@synthesize buttonArray;
@synthesize courseFolderName;
@synthesize searchBar;
@synthesize displayArray;
@synthesize originalArray;
@synthesize displayButtonArray;
@synthesize displayProgArray;
@synthesize buttonNumber;
#pragma mark Constants

#define DEMO_VIEW_CONTROLLER_PUSH FALSE

#pragma mark UIViewController methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]];

    
    downloadModel = [DownloadModel getDownloadModel];
    queue = downloadModel.queue;
    downloadModel.delegate = self;
    firstImageDict = downloadModel.firstImageDict;
    
    if (![self downloadQueue]) {
        [self setDownloadQueue:[[ASINetworkQueue alloc]init]];
    }
    [self.downloadQueue setMaxConcurrentOperationCount:MAX_DOWNLOAD_NUM];      //最大同时下载数
    [self.downloadQueue setShowAccurateProgress:YES];        //是否显示详细进度
    [self.downloadQueue setRequestDidFailSelector:@selector(queueFailed)];
    [self.downloadQueue setRequestDidFinishSelector:@selector(queueFinished)];
    [self.downloadQueue setRequestDidStartSelector:@selector(queueStarted)];
    
    self.courseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width - 64)];
    self.courseTableView.delegate = self;
    self.courseTableView.dataSource = self;
    [self.courseTableView setBackgroundColor:[UIColor clearColor]];
    [self.courseTableView setSeparatorColor:[UIColor clearColor]];
    [self.courseTableView setSectionIndexColor:[UIColor clearColor]];
    [self.courseTableView setAllowsSelection:NO];
    
    
    [self.view addSubview:self.courseTableView];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(initDatas) object:nil];
    [thread start];
    
//	self.view.backgroundColor = [UIColor clearColor]; // Transparent

	self.title = @"课程";
    
    
    UIBarButtonItem *downloadAllButton = [[UIBarButtonItem alloc]initWithTitle:@"下载全部" style:UIBarButtonItemStyleBordered target:self action:@selector(downloadAllAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:downloadAllButton, nil];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(800 - 150, 0, 150, 44)];
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self.searchBar setPlaceholder:@""];
    self.searchBar.delegate = self;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 800, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:searchBar];
    
    int cid = [courseFolderName intValue];
    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
    MyCourse *myCourse = sysbsModel.myCourse;
    Course *course = [myCourse findCourse:cid];
    NSString *title = course.courseName;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(400 - 200, 0, 400, 44)];
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:19]];
    [searchView addSubview:titleLabel];
    self.navigationItem.titleView = searchView;
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

- (void) initDatas{
    self.PDFUrlArray = [[NSMutableArray alloc]init];
    self.PDFPathArray = [[NSMutableArray alloc]init];
    self.progressArray = [[NSMutableArray alloc]init];
    self.buttonArray = [[NSMutableArray alloc]init];
    self.displayButtonArray = [[NSMutableArray alloc]init];
    
    self.originalArray = [[NSMutableArray alloc]init];
    self.displayArray = [[NSMutableArray alloc]init];
    NSString *contents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *PDFPath = [contents stringByAppendingPathComponent:PDFFolderName3];
    NSString *PDFCoursePath = [PDFPath stringByAppendingPathComponent:courseFolderName];
    
    int cid = [courseFolderName intValue];
    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
    MyCourse *myCourse = sysbsModel.myCourse;
    Course *course = [myCourse findCourse:cid];
    
    [downloadModel createDir:PDFCoursePath];
    for (int i = 0 ; i < [course.fileArr count]; i ++) {
        File *file = [course.fileArr objectAtIndex:i];
        NSString *url = file.filePath;
        NSString *fileName = file.fileName;
        NSString *filePath = [PDFCoursePath stringByAppendingPathComponent:fileName];
        [self.PDFUrlArray addObject:url];
        [self.PDFPathArray addObject:filePath];
    }
    for (int i = 0 ; i < [self.PDFUrlArray count]; i ++) {
        CoursewareItem *item = [[CoursewareItem alloc]init];
        [item setPDFURL:[self.PDFUrlArray objectAtIndex:i]];
        [item setPDFPath:[self.PDFPathArray objectAtIndex:i]];
        [item setPDFName:[[self.PDFPathArray objectAtIndex:i] lastPathComponent]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:item.PDFPath]) {
            UIImage *fImage = [firstImageDict objectForKey:item.PDFPath];
            if (fImage == nil) {
                fImage = [downloadModel getFirstPageFromPDF:item.PDFPath];
                [firstImageDict setObject:fImage forKey:item.PDFPath];
            }
            [item setPDFFirstImage:fImage];
        }
        else{
            [item setPDFFirstImage:nil];
        }
        [originalArray addObject:item];
        [displayArray addObject:item];
        [self performSelectorOnMainThread:@selector(displayTableView) withObject:nil waitUntilDone:NO];
    }
}

- (void)displayTableView{
    [self.courseTableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)

	[self.navigationController setNavigationBarHidden:NO animated:animated];

#endif // DEMO_VIEW_CONTROLLER_PUSH
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)

	[self.navigationController setNavigationBarHidden:YES animated:animated];

#endif // DEMO_VIEW_CONTROLLER_PUSH
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
//    [self.downloadQueue cancelAllOperations];
    
    NSLog(@"disappear");
//     */
}
- (void)viewDidUnload
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	[super viewDidUnload];
    NSLog(@"unload");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) // See README
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	else
		return YES;
}

/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//if (fromInterfaceOrientation == self.interfaceOrientation) return;
}
*/

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	[super didReceiveMemoryWarning];
}

#pragma mark UIGestureRecognizer methods

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)

	NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];

	NSString *filePath = [pdfs lastObject]; assert(filePath != nil); // Path to last PDF file

	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];

	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];

		readerViewController.delegate = self; // Set the ReaderViewController delegate to self

#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)

		[self.navigationController pushViewController:readerViewController animated:YES];

#else // present in a modal view controller

		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;

		[self presentViewController:readerViewController animated:YES completion:NULL];

#endif // DEMO_VIEW_CONTROLLER_PUSH
	}
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    for (ASIHTTPRequest *request in self.downloadQueue.operations) {
        [request clearDelegatesAndCancel];
        NSLog(@"cancel");
    }

	[self.navigationController popViewControllerAnimated:YES];

#else // dismiss the modal view controller

	[self dismissViewControllerAnimated:YES completion:NULL];

#endif // DEMO_VIEW_CONTROLLER_PUSH
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int num;
//    NSLog(@"display count %d",self.displayArray.count);
    if (self.displayArray.count % ITEM_NUM_IN_ROW == 0) {
        num = self.displayArray.count / ITEM_NUM_IN_ROW;
    }
    else
    {
        num = self.displayArray.count / ITEM_NUM_IN_ROW + 1;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",[indexPath section],[indexPath row]]; //以indexPath来唯一确定cell,不使用完全重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    int row = indexPath.row;
//    NSLog(@"row--------------------------- %d",row);
    int count = ITEM_NUM_IN_ROW;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        for (int i = 0; i < ITEM_NUM_IN_ROW; i ++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(250 * i + 24, 20, 226, 168)];
            [button setTag:i + 1];
            [button setHidden:YES];
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
            [label setTag:i * 10 + 10];
            
            [cell.contentView addSubview:button];
            [cell.contentView addSubview:label];
            
        }
        NSLog(@"button count %d",[self.buttonArray count]);
        buttonNumber = [self.buttonArray count];
        displayButtonArray = buttonArray;
        displayProgArray = progressArray;
    } else{
        for (int i = 0 ; i < count; i ++) {
            UIButton *button = (UIButton *)[cell viewWithTag:i + 1];
            MRCircularProgressView *progressView = (MRCircularProgressView *)[button viewWithTag:PROGRESS_TAG];
            [progressView setHidden:YES];
//            [progressView setProgress:0];
        }
    }
    for (int i = 0 ; i < count; i ++) {
        UIButton *button = (UIButton *)[cell viewWithTag:i + 1];
        
        UILabel *label = (UILabel *)[cell viewWithTag:i * 10 + 10];
        int index = row * ITEM_NUM_IN_ROW + i;
        if (index >= self.displayArray.count) {
//            NSLog(@"index %d",index);
            [button setHidden:YES];
            [label setHidden:YES];
            continue;
        }
        
        [button setHidden:NO];
//        UIProgressView *progressView = (UIProgressView *)[button viewWithTag:PROGRESS_TAG];
        MRCircularProgressView *progressView = (MRCircularProgressView *)[button viewWithTag:PROGRESS_TAG];
        [progressView setHidden:YES];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index", nil];
        [button setMyDict:dict];
        CoursewareItem *item = [self.displayArray objectAtIndex:index];
        NSString *PDFName = item.PDFName;
        UIImage *PDFFirstImage = item.PDFFirstImage;
//        NSString *PDFPath = item.PDFPath;
        NSURL *PDFURL = [NSURL URLWithString:item.PDFURL];
        
        for (ASIHTTPRequest *request in queue.operations) {
            if ([request.url isEqual:PDFURL]) {
                [request setDownloadProgressDelegate:progressView];
                
                NSDictionary *requestDict = request.myDict;
                NSString *filePath = [requestDict objectForKey:@"filePath"];
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",filePath,@"filePath",item,@"item", nil];
                [request setMyDict:dict];
                [progressView setMyDict:dict];
                progressView.delegate = self;
                [progressView setHidden:NO];
            }
        }
        if (PDFFirstImage != nil) {
            
//            NSLog(@"PDFFirstImage %d",index);
            [button setImage:PDFFirstImage forState:UIControlStateNormal];
//            [button setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
            
            
//            [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            
            

            [button addTarget:self action:@selector(openCourseware:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            
//            [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            
            [button setImage:nil forState:UIControlStateNormal];
            [button addTarget:self action:@selector(courseItemAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIImage *image = [UIImage imageNamed:@"pptsearch_ppt"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
//        [button setImage:image forState:UIControlStateNormal];
        
        
        [label setHidden:NO];
        [label setText:PDFName];
    }
    return cell;
}
//点击单个课件下载
- (void) courseItemAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSDictionary *dict = button.myDict;
    
    int index = [(NSNumber *)[dict objectForKey:@"index"] integerValue];
    [self downloadPDF:index];
}
//下载单个课件
- (void) downloadPDF:(int)index
{
    CoursewareItem *item = [displayArray objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:item.PDFURL];
    NSString *filePath = item.PDFPath;
    NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",filePath,@"filePath",item,@"item",[NSNumber numberWithInt:index],@"index", nil];
    
    
    UIButton *button = (UIButton *)[buttonArray objectAtIndex:index % buttonNumber];
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
            //                request.tag = index;
            [progress setMyDict:myDict];
            [progress setHidden:NO];
            progress.delegate = self;
            [request setDownloadProgressDelegate:progress];
        }
    }
}
//下载所有课件
- (void)downloadAllAction:(id)sender
{
    int count = 0;
    for (int i = 0; i < [displayArray count]; i ++) {
        [self downloadPDF:i];
        CoursewareItem *item = [displayArray objectAtIndex:i];
        NSString *filePath = item.PDFPath;
        if (filePath) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if([fileManager fileExistsAtPath:filePath])
            {
                count++;
            }
        }
    }
    if (count == [displayArray count]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"本课程课件已全部下载！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"课件正在下载中！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openCourseware:(id)sender
{
 ////
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    UIButton *button = (UIButton *)sender;
    NSDictionary *dict = button.myDict;
    int index = [(NSNumber *)[dict objectForKey:@"index"] integerValue];
    CoursewareItem *item = [self.displayArray objectAtIndex:index];
    NSString *filePath = item.PDFPath;

    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
        
        NSString *contents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *NOTEPath = [contents stringByAppendingPathComponent:NOTEFolderName3];
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

#pragma serchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
//    NSLog(@"%@",searchText);
//    NSLog(@"%i",[displayArray count]);
    if (searchText!=nil && searchText.length>0) {
        self.displayArray= [NSMutableArray array];
        self.displayButtonArray = [NSMutableArray array];
        for (int i = 0 ; i < [originalArray count];i ++) {
            CoursewareItem *item = [originalArray objectAtIndex:i];
            UIButton *button = [buttonArray objectAtIndex:i % buttonNumber];
            if ([self isMatch:searchText :item.PDFName]) {
                [self.displayArray addObject:item];
                [self.displayButtonArray addObject:button];
//                NSLog(@"%d",[displayArray count]);
            }
        }
        [self.courseTableView reloadData];
    }
    else
    {
        self.displayArray = [NSMutableArray arrayWithArray:originalArray];
        self.displayButtonArray = [NSMutableArray arrayWithArray:buttonArray];
        [self.courseTableView reloadData];
    }
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    [self.searchBar resignFirstResponder];
    NSLog(@"click");
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
    //    if (progress.progress == 100) {
    
    CoursewareItem *item = [myDict objectForKey:@"item"];
    
    UIButton *button = [self.buttonArray objectAtIndex:index % buttonNumber];
    UIImage *image = [firstImageDict objectForKey:filePath];
    item.PDFFirstImage = image;
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(openCourseware:) forControlEvents:UIControlEventTouchUpInside];
    [progressView setHidden:YES];
}
#pragma MRProgressDelegate mark
- (void)progressFinished:(MRCircularProgressView *)progress{
    return;
}
- (void)progressValueChange:(MRCircularProgressView *)progress{

}
- (void)dealloc{
    for (ASIHTTPRequest *request in queue.operations) {
//        [request clearDelegatesAndCancel];
        request.downloadProgressDelegate = nil;
    }
    for (MRCircularProgressView *progress in progressArray) {
        [progress removeLink];
    }
    downloadModel.delegate = nil;
}



@end
