//
//	ReaderViewController.m
//	Reader v2.6.0
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

#import "ReaderConstants.h"
#import "ReaderViewController.h"
#import "ThumbsViewController.h"
#import "ReaderMainToolbar.h"
#import "ReaderMainPagebar.h"
#import "ReaderContentView.h"
#import "ReaderThumbCache.h"
#import "ReaderThumbQueue.h"
#import "NoteToolbar.h"
#import "CourseMarkViewController.h"
#import <MessageUI/MessageUI.h>
#import "NoteToolDrawerBar.h"

#define kActionSheetColor       100
#define kActionSheetTool        101

#define kPenWidthMin            1.0f
#define kPenWidthMax            30.0f
#define kPenWidthDefault        5.0f
#define kPenAlphaMin            0.100000001490116f
#define kPenAlphaMax            1.0f
#define kPenAlphaDefault        1.0f

#define kPenColor               [UIColor blackColor]
#define kMarkAlphaDefault       0.5f

#define SWATCH_VIEW_TAG     111111
#define PEN_VIEW_TAG        222222
#define MARKER_VIEW_TAG     333333
#define ERASER_VIEW_TAG     444444

#define PEN_WIDTH_SLIDER_TAG  111111


@interface ReaderViewController () <UIScrollViewDelegate
, UIGestureRecognizerDelegate
, MFMailComposeViewControllerDelegate,
									ReaderMainToolbarDelegate, ReaderMainPagebarDelegate, ReaderContentViewDelegate, ThumbsViewControllerDelegate,NoteToolbarDelegate>
@end

@implementation ReaderViewController
{
	//pdf文件
    ReaderDocument *document;
    //课件页的容器
	UIScrollView *theScrollView;
    //上面工具栏
	ReaderMainToolbar *mainToolbar;
    //下面工具栏
	ReaderMainPagebar *mainPagebar;
    //左边笔记的工具栏
    NoteToolbar *noteToolbar;
    
    NoteToolDrawerBar *noteToolDrawerBar;
    //当前在scrollview上的内容view
	NSMutableDictionary *contentViews;
    //跟打印有关的
	UIPrintInteractionController *printInteraction;
    
	NSInteger currentPage;
    //保存出现大小
	CGSize lastAppearSize;
    //上次隐藏的时间
	NSDate *lastHideTime;
    //是否可见
	BOOL isVisible;
    //笔记的image？
    UIImage *noteImage;
    //跟书签有关
    UIView *markEditView;
    //跟书签有关
    UITextField *markField;
    //出现的view的 tag
    int appearViewTag;
    //当前笔颜色
    UIColor *curPenColor;
    //宽度
    CGFloat curPenWidth;
    //透明度
    CGFloat curPenAlpha;
    BOOL isFirstVisit;
}

#pragma mark Constants

#define PAGING_VIEWS 3

#define STATUS_HEIGHT 20.0f

#define TOOLBAR_HEIGHT 64.0f//44.0f
#define PAGEBAR_HEIGHT 46.0f

#define NOTE_HEIGHT 100.0f

#define TAP_AREA_SIZE 48.0f

#pragma mark Properties

@synthesize delegate;
@synthesize drawingView;
@synthesize drawNewView;
@synthesize lineWidthSlider;
@synthesize lineAlphaSlider;
@synthesize notePath;
@synthesize eraserWidthView;
@synthesize markerWidthView;
@synthesize penWidthView;
@synthesize swatchView;
@synthesize noteButton;
#pragma mark Support methods

//根据页数来更新scrollView的大小
- (void)updateScrollViewContentSize
{
    //总页数
	NSInteger count = [document.pageCount integerValue];
    //限制整个scrollview大小等于其缓存页数的大小。
	if (count > PAGING_VIEWS) count = PAGING_VIEWS; // Limit

	CGFloat contentHeight = theScrollView.bounds.size.height;

	CGFloat contentWidth = (theScrollView.bounds.size.width * count);

	theScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

//更新整个scrollview的内容（直观视觉上更新呈现在屏幕上的内容）
- (void)updateScrollViewContentViews
{
	[self updateScrollViewContentSize]; // Update the content size

	NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSet]; // Page set
    
	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
		^(id key, id object, BOOL *stop)
		{
			ReaderContentView *contentView = object; [pageSet addIndex:contentView.tag];
		}
	];

	__block CGRect viewRect = CGRectZero; viewRect.size = theScrollView.bounds.size;

	__block CGPoint contentOffset = CGPointZero; NSInteger page = [document.pageNumber integerValue];

	[pageSet enumerateIndexesUsingBlock: // Enumerate page number set
		^(NSUInteger number, BOOL *stop)
		{
			NSNumber *key = [NSNumber numberWithInteger:number]; // # key

			ReaderContentView *contentView = [contentViews objectForKey:key];

			contentView.frame = viewRect; if (page == number) contentOffset = viewRect.origin;

			viewRect.origin.x += viewRect.size.width; // Next view frame position
            //迭代更新viewRect
            //并通过page 和 number的判断来决定最终的contentOffset
		}
	];

	if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == false)
	{
		theScrollView.contentOffset = contentOffset; // Update content offset
	}
}

//更新是否是书签页的标记
- (void)updateToolbarBookmarkIcon
{
	NSInteger page = [document.pageNumber integerValue];

	BOOL bookmarked = [document.bookmarks containsIndex:page];

	[mainToolbar setBookmarkState:bookmarked]; // Update
}

//展示当前页
- (void)showDocumentPage:(NSInteger)page
{
	if (page != currentPage) // Only if different will this function effect or change sth
	{
        if (drawingView != nil) {//remove the drawing view from screen if it isn't nil
            [drawingView removeFromSuperview];
            drawingView = nil;
        }
        if (noteImage != nil) {//
            noteImage = nil;
        }
        if (drawNewView != nil) {//
            [drawNewView removeFromSuperview];
            drawNewView = nil;
        }
        
		NSInteger minValue;
        NSInteger maxValue;
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1;

		if ((page < minPage) || (page > maxPage)) return;//to judge will the page is out of the range.Prevent the client invoke the function by mistake

		if (maxPage <= PAGING_VIEWS) // Few pages
		{//跟缓存有关
			minValue = minPage;
			maxValue = maxPage;
		}
		else // Handle more pages
		{
			minValue = (page - 1);
			maxValue = (page + 1);
            //判断是否越界
			if (minValue < minPage)
				{minValue++; maxValue++;}
			else
				if (maxValue > maxPage)
					{minValue--; maxValue--;}
		}
        
		NSMutableIndexSet *newPageSet = [NSMutableIndexSet new];
        //拷贝一个contentview 给unusedview？
		NSMutableDictionary *unusedViews = [contentViews mutableCopy];
        
		CGRect viewRect = CGRectZero; viewRect.size = theScrollView.bounds.size;
        //对minvalue到maxvalue内view进行迭代
		for (NSInteger number = minValue; number <= maxValue; number++)
		{
			NSNumber *key = [NSNumber numberWithInteger:number]; // # key

			ReaderContentView *contentView = [contentViews objectForKey:key];
            //需要的时候才将document文件加载进内存。
			if (contentView == nil) // Create a brand new document content view
			{
				NSURL *fileURL = document.fileURL; NSString *phrase = document.password; // Document properties

				contentView = [[ReaderContentView alloc] initWithFrame:viewRect fileURL:fileURL page:number password:phrase];
                
                
                
				[theScrollView addSubview:contentView];
                
                [contentViews setObject:contentView forKey:key];

				contentView.message = self; [newPageSet addIndex:number];
                
                

			}
			else // Reposition the existing content view
			{
				contentView.frame = viewRect;
                //?
                [contentView zoomReset];
                //确保unusedview是没用到的。
				[unusedViews removeObjectForKey:key];
			}
            viewRect.origin.x += viewRect.size.width;
            //初始化以宽为边界
            // 创建一个 更小的 rectangle
            CGRect targetRect = CGRectInset(contentView.bounds, 4.0, 4.0);
            //计算两者的scale比
            float scale = targetRect.size.width / contentView.theContainerView.bounds.size.width;
            [contentView setZoomScale:scale];
//            [theScrollView setContentOffset:CGPointZero];
            [contentView setContentOffset:CGPointZero];
//            CGPoint point = CGPointZero;
//            point.y += 10.0;
//            [contentView setContentOffset:point];

			//完成迭代
		}

		[unusedViews enumerateKeysAndObjectsUsingBlock: // Remove unused views
			^(id key, id object, BOOL *stop)
			{
				[contentViews removeObjectForKey:key];

				ReaderContentView *contentView = object;
                
				[contentView removeFromSuperview];
			}
		];
        //
		unusedViews = nil; // Release unused views
        
		CGFloat viewWidthX1 = viewRect.size.width;
		CGFloat viewWidthX2 = (viewWidthX1 * 2.0f);//这个2.0应该是根据缓存页数来的？应该改成PAGING_VIEW - 1 比较好吧？

		CGPoint contentOffset = CGPointZero;
        //处理缓存页数的一些问题。
        //如果文件页数超过缓存页数
		if (maxPage >= PAGING_VIEWS)
		{
			if (page == maxPage)
				contentOffset.x = viewWidthX2; //当前页是最后一页时，
			else
				if (page != minPage)
					contentOffset.x = viewWidthX1;//当前页不是第一页时，contentoffset为中间那一页的contentoffse。估计也是改一下比较好//PAGEING_VIEWS / 2 * screensize.x
		}
		else
			if (page == (PAGING_VIEWS - 1))
				contentOffset.x = viewWidthX1;//如果总页数小于缓存页就设置offset为最后一页

		if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == false)
		{
			theScrollView.contentOffset = contentOffset; // Update content offset
		}

		if ([document.pageNumber integerValue] != page) // Only if different
		{
            //更改当前页
			document.pageNumber = [NSNumber numberWithInteger:page]; // Update page number
		}
        
		NSURL *fileURL = document.fileURL; NSString *phrase = document.password; NSString *guid = document.guid;

		if ([newPageSet containsIndex:page] == YES) // Preview visible page first
		{
			NSNumber *key = [NSNumber numberWithInteger:page]; // # key

			ReaderContentView *targetView = [contentViews objectForKey:key];
            //获取那一页的view 之前已经预读了缓存
			[targetView showPageThumb:fileURL page:page password:phrase guid:guid];
            //删除？
			[newPageSet removeIndex:page]; // Remove visible page from set
		}
        //上面和下面的代码写的怪怪的。应该是保护机制吧。感觉上面的那段可以删掉。。
		[newPageSet enumerateIndexesWithOptions:NSEnumerationReverse usingBlock: // Show previews
			^(NSUInteger number, BOOL *stop)
			{
				NSNumber *key = [NSNumber numberWithInteger:number]; // # key

				ReaderContentView *targetView = [contentViews objectForKey:key];

				[targetView showPageThumb:fileURL page:number password:phrase guid:guid];
			}
		];

		newPageSet = nil; // Release new page set

//		[mainPagebar updatePagebar]; // Update the pagebar display

		[self updateToolbarBookmarkIcon]; // Update bookmark
//        if (noteButton.selected) {
//            [self startDraw];
//        } else{
            currentPage = page; // Track current page number
            NSNumber *key = [NSNumber numberWithInteger:page]; // # key
            ReaderContentView *newContentView = [contentViews objectForKey:key];
            [self addDrawView:newContentView];
//        }
        if (noteButton.selected) {
            [self startDraw];
        }//是否开始笔记。
	}
}

- (void)addDrawView:(ReaderContentView *)readerContentView{
    //
    if (drawNewView != nil) {
        [drawNewView removeFromSuperview];
        drawNewView = nil;
    }
    if (drawingView != nil) {
        return;
    }
    

    //笔记的plist文件。
    NSString *fileName = [NSString stringWithFormat:@"%d%@",[document.pageNumber intValue], @".plist"];
    NSString *filePath=[[NSString alloc]initWithString:[self.notePath stringByAppendingPathComponent:fileName]];

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];//根据文件取内容。
    
    
    if (dict != nil) {//不为空就取里面的NSData
        NSData *imageData = [[NSData alloc]initWithData:[dict objectForKey:@"imageData"]];
        noteImage = [UIImage imageWithData:imageData scale:[[UIScreen mainScreen] scale]];
    }//空了怎么办==不return?
    
    CGRect rect = readerContentView.theContainerView.bounds;
//    CGRect rect2 = readerContentView.bounds;
    self.drawingView = [[ACEDrawingView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) :noteImage];
//    self.delegate = self;
    self.drawingView.delegate = self;
//    [drawingView setUserInteractionEnabled:NO];

    [readerContentView.theContainerView addSubview:drawingView];
    
//    [theScrollView addSubview:drawingView];
}

//开始画
- (void)startDraw{
    //开始画让scrollview不能滚动
    [theScrollView setScrollEnabled:NO];
    //让新画的东西能够画
    [drawNewView setUserInteractionEnabled:YES];
    int page = [document.pageNumber intValue];
    
    NSNumber *key = [NSNumber numberWithInteger:page]; // # key
    //当前这页的view。。奇怪的变量名。。
    ReaderContentView *newContentView = [contentViews objectForKey:key];
    newContentView.isNote = YES;
    //isnote奇怪的耦合==
    //    [newContentView setUserInteractionEnabled:NO];
    CGRect rect = newContentView.theContainerView.frame;
    CGRect rect2 = newContentView.bounds;
    

    CGSize beforeSize;
    if (drawingView != nil) {
        //获取原来的size
        beforeSize = drawingView.image.size;
        [drawingView removeFromSuperview];
        //开始画移除掉加载的drawingview？
        drawingView = nil;
    }
    else
        beforeSize = CGSizeZero;
    if (drawNewView != nil) {
        //目前不知道是干啥的。。
        drawNewView.drawTool = currentToolType;
        return;
    }
    
    
//    drawNewView = [[ACEDrawingView alloc]initWithFrame:CGRectMake(theScrollView.contentOffset.x + rect.origin.x + 4.0f, rect.origin.y + 4.0f, rect.size.width, rect.size.height) :noteImage];
    CGSize nowSize =rect.size;
    CGFloat scale = 1;
    if (beforeSize.width != CGSizeZero.width) {//预防等于0吧。
        scale = nowSize.width / beforeSize.width;
    }


    //对image进行缩放？
    UIImage *scaleImage = [self scaleImage:noteImage toScale:scale];
    //这个公式瞬间没有了可读性==。。妈蛋。
    drawNewView = [[ACEDrawingView alloc]initWithFrame:CGRectMake(theScrollView.contentOffset.x + rect.origin.x + 4.0f - rect2.origin.x - 4.0f, rect.origin.y + 4.0f - rect2.origin.y - 4.0f, rect.size.width, rect.size.height) :scaleImage];
    
    drawNewView.delegate = self;
    
//    drawNewView.lineWidth = self.lineWidthSlider.value;
    drawNewView.lineWidth = curPenWidth;
    drawNewView.lineColor = curPenColor;
    drawNewView.lineAlpha = curPenAlpha;

    drawNewView.drawTool = currentToolType;
    [theScrollView addSubview:drawNewView];
    
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    //draw image高效还是imageview高效呢？iOS初学者我不太了解
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
                                
}
- (void)stopDraw{
    
    int page = [document.pageNumber intValue];
    NSNumber *key = [NSNumber numberWithInteger:page]; // # key
    ReaderContentView *newContentView = [contentViews objectForKey:key];
    newContentView.isNote = NO;
    //注释不yes？
//    [newContentView setUserInteractionEnabled:YES];
    
    [theScrollView setScrollEnabled:YES];
    [drawingView setUserInteractionEnabled:NO];
    [drawNewView setUserInteractionEnabled:NO];
}

//保存笔记 convert the image to nsdata then write into a plist file
- (void)saveDraw{

    NSLog(@"save");
    UIImage *image = drawNewView.image;
    //高端的函数。。
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    
    
    NSString *fileName = [NSString stringWithFormat:@"%d%@",[document.pageNumber intValue], @".plist"];
    
    NSString *filePath=[[NSString alloc]initWithString:[self.notePath stringByAppendingPathComponent:fileName]];
//    NSLog(@"path %@",filePath);
    NSDictionary *noteDateDic = [[NSDictionary alloc]initWithObjectsAndKeys:imageData,@"imageData", nil];
    
    
    
    [noteDateDic writeToFile:filePath atomically:YES];
}

- (void)showDocument:(id)object
{
	[self updateScrollViewContentSize]; // Set content size

	[self showDocumentPage:[document.pageNumber integerValue]];

	document.lastOpen = [NSDate date]; // Update last opened date

	isVisible = YES; // iOS present modal bodge
}

#pragma mark UIViewController methods

- (id)initWithReaderDocument:(ReaderDocument *)object
{
	id reader = nil; // ReaderViewController object

	if ((object != nil) && ([object isKindOfClass:[ReaderDocument class]]))
	{
		if ((self = [super initWithNibName:nil bundle:nil])) // Designated initializer
		{
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

			[notificationCenter addObserver:self selector:@selector(applicationWill:) name:UIApplicationWillTerminateNotification object:nil];

			[notificationCenter addObserver:self selector:@selector(applicationWill:) name:UIApplicationWillResignActiveNotification object:nil];

			[object updateProperties]; document = object; // Retain the supplied ReaderDocument object for our use

			[ReaderThumbCache touchThumbCacheWithGUID:object.guid]; // Touch the document thumb cache directory
            //创建缓存。
			reader = self; // Return an initialized ReaderViewController object
		}
	}

	return reader;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    //笔记初始化
    curPenWidth = kPenWidthDefault;
    curPenAlpha = kPenAlphaDefault;
    curPenColor = kPenColor;
    //第一次visit还要标记出来？
    isFirstVisit = YES;
    
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:@"download_ppt.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
	assert(document != nil); // Must have a valid ReaderDocument
    
	self.view.backgroundColor = [UIColor grayColor]; // Neutral gray
    
	CGRect viewRect = self.view.bounds; // View controller's view bounds
    
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
	{
		if ([self prefersStatusBarHidden] == NO) // Visible status bar
		{//判断状态栏是否隐藏
			viewRect.origin.y += STATUS_HEIGHT;
		}
	}

	theScrollView = [[UIScrollView alloc] initWithFrame:viewRect]; // All

	theScrollView.scrollsToTop = NO;
	theScrollView.pagingEnabled = YES;
    //高端的delayscontenttouches
	theScrollView.delaysContentTouches = NO;
	theScrollView.showsVerticalScrollIndicator = NO;
	theScrollView.showsHorizontalScrollIndicator = NO;
	theScrollView.contentMode = UIViewContentModeRedraw;
    //不能旋转resize好像就没用了？
	theScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	theScrollView.backgroundColor = [UIColor clearColor];
	theScrollView.userInteractionEnabled = YES;
	theScrollView.autoresizesSubviews = NO;
	theScrollView.delegate = self;

	[self.view addSubview:theScrollView];

	CGRect toolbarRect = viewRect;
	toolbarRect.size.height = TOOLBAR_HEIGHT;
//    toolbarRect.origin.y += 20;
	mainToolbar = [[ReaderMainToolbar alloc] initWithFrame:toolbarRect document:document]; // At top
    //上工具栏
	mainToolbar.delegate = self;

	[self.view addSubview:mainToolbar];

	CGRect pagebarRect = viewRect;
	pagebarRect.size.height = PAGEBAR_HEIGHT;
	pagebarRect.origin.y = (viewRect.size.height - PAGEBAR_HEIGHT);

    
	mainPagebar = [[ReaderMainPagebar alloc] initWithFrame:pagebarRect document:document]; // At bottom
    //下工具栏
	mainPagebar.delegate = self;

	[self.view addSubview:mainPagebar];
    
    CGRect noteRect = viewRect;
    noteRect.size.height = NOTE_HEIGHT;
    noteRect.origin.y = (viewRect.size.height - NOTE_HEIGHT);
    //笔记rect，总觉得有点问题。。
//    noteToolbar = [[NoteToolbar alloc] initWithFrame:CGRectMake(0, 648, 1024, 100)];
//    noteToolbar.delegate = self;
//    [self.view addSubview:noteToolbar];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 768 / 2 - 40, 41, 80)];
    [imageView setImage:[UIImage imageNamed:@"entry"]];//这个图片的命名真的是想给人看懂的么。。左边的箭头图标。
    [self.view addSubview:imageView];
    //左边的工具栏
    
    noteToolDrawerBar = [[NoteToolDrawerBar alloc]initWithFrame:CGRectMake(0, 0, 174, 539) parentView:self.view];
    noteToolDrawerBar.delegate = self;
    [self.view addSubview:noteToolDrawerBar];
    
    UIImage *noteButtonImage = [UIImage imageNamed:@"edit_off"];
    noteButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 653, noteButtonImage.size.width, noteButtonImage.size.height)];
    //图片的坐标。。
    [noteButton setImage:noteButtonImage forState:UIControlStateNormal];
    [self.view addSubview:noteButton];
    
    [noteButton addTarget:self action:@selector(noteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //pangetsture？那个编辑图标移动的监听。
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragButtonGesture:)];
    [noteButton addGestureRecognizer:panGesture];
    
    //点击手势。。开始可能有冲突的地方咯。。。
	UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
	[self.view addGestureRecognizer:singleTapOne];
    //双击手势。。。妈蛋真多手势。。
	UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2; doubleTapOne.delegate = self;
	[self.view addGestureRecognizer:doubleTapOne];
    //两个手指双击？
	UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapTwo.numberOfTouchesRequired = 2; doubleTapTwo.numberOfTapsRequired = 2; doubleTapTwo.delegate = self;
	[self.view addGestureRecognizer:doubleTapTwo];

	[singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail
    
     //目测这样两个手指的双击就废掉了喔。。
	contentViews = [NSMutableDictionary new]; lastHideTime = [NSDate date];
    //slider？
    [self initSlider];
    //初始化书签
    [self initMarkEditView];
    //初始化工具栏
    [self initToolView];
    
}
//点击
//不知道iOS有没有togglebutton之类的这种东西呢
//可以根据它的state直接设置对应image吧。
- (void)noteButtonAction:(UIButton *)button{
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"edit_off"] forState:UIControlStateNormal];
        button.selected = NO;
        if (noteToolDrawerBar.isOpen == YES) {
            [noteToolDrawerBar openOrCloseToolBar];
        }//似乎没有用的样子。。
        //停止编辑的时候stopdraw然后自动保存
        [self stopDraw];
        [self saveDraw];
        int page = [document.pageNumber intValue];
        NSNumber *key = [NSNumber numberWithInteger:page]; // # key
        ReaderContentView *newContentView = [contentViews objectForKey:key];
        [self addDrawView:newContentView];
        //然后又加载到newcontentview上面去。。奇怪的操作。。
        if (mainPagebar.hidden == YES || mainToolbar.hidden == YES) {
            //为什么停止编辑的时候要展示工具栏。。这是在逗我？
            [mainToolbar showToolbar];
            [mainPagebar showPagebar];
        }
    } else{
        [button setImage:[UIImage imageNamed:@"edit_on"] forState:UIControlStateNormal];
        button.selected = YES;
        currentToolType = ACEDrawingToolTypePen;
        [self startDraw];

    }
}
//这个才是飞
- (void)dragButtonGesture:(UIPanGestureRecognizer *)recognizer{
    NSLog(@"pan手势");
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint resultPoint = CGPointMake(noteButton.center.x + translation.x, noteButton.center.y + translation.y);
    if (resultPoint.x >= 0 && resultPoint.x <= 1024 && resultPoint.y >= 0 && resultPoint.y <= 768) {
        noteButton.center = CGPointMake(noteButton.center.x + translation.x, noteButton.center.y + translation.y);

    }
    //设置reconizer
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}
//笔记的工具栏
//清空全部要改。
- (void)initToolView{
    int colorNum = 6;
    CGFloat buttonWidth = 60.0f;
    CGFloat buttonHeight = 60.0f;
    CGFloat viewY = 100.0f + 40.0f;
    CGFloat viewX = 160.0f;
    //奇怪的变量名
    //colorNum * buttonWidth + 4 * 10  + 40
    swatchView = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, colorNum * buttonWidth + 4 * 10  + 40, buttonHeight)];
    [swatchView setBackgroundColor:[UIColor grayColor]];
    NSArray *colorArray = [[NSArray alloc]initWithObjects:[UIColor blackColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor whiteColor], nil];
    for (int i = 0; i < colorNum; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20 + (buttonWidth + 10) * i,0, buttonWidth, buttonHeight)];
        [button setTag:i + 1];
        [button setBackgroundColor:[colorArray objectAtIndex:i]];
        [button addTarget:self action:@selector(choColorAction:) forControlEvents:UIControlEventTouchUpInside];
        [swatchView addSubview:button];
    }
    swatchView.hidden = YES;
    [self.view addSubview:swatchView];
    
    CGFloat outButtonHeight = 73.0f;
    
    viewY += (outButtonHeight + 10);
    penWidthView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, 214, 57)];
    UIColor *penBg = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ppt_toolbox_pencil_adjust_bg"]];
    [penWidthView setBackgroundColor:penBg];
    UISlider *penWidthSlider = [[UISlider alloc]initWithFrame:CGRectMake(15, 12, 185, 29)];
//    [penWidthSlider setTintColor:[UIColor redColor]];
    [penWidthSlider setMaximumTrackImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_bar_active"] forState:UIControlStateNormal];
    [penWidthSlider setMinimumTrackImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_bar_inactive"] forState:UIControlStateNormal];
//    [penWidthSlider setThumbImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_handle"] forState:UIControlStateNormal];
    
    [penWidthSlider setMinimumValue:kPenWidthMin];
    [penWidthSlider setMaximumValue:kPenWidthMax];
    [penWidthSlider addTarget:self action:@selector(widthChange:) forControlEvents:UIControlEventValueChanged];
    [penWidthSlider setValue:kPenWidthDefault];
    penWidthSlider.backgroundColor = [UIColor clearColor];
    [penWidthSlider setTag:PEN_WIDTH_SLIDER_TAG];
    [penWidthView addSubview:penWidthSlider];
    penWidthView.hidden = YES;
    [self.view addSubview:penWidthView];
    
    viewY += (outButtonHeight + 10);
    markerWidthView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, 214, 57)];
    UIColor *markerBg = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ppt_toolbox_pencil_adjust_bg"]];
    [markerWidthView setBackgroundColor:markerBg];
    UISlider *markerWidthSlider = [[UISlider alloc]initWithFrame:CGRectMake(15, 12, 185, 29)];
    [markerWidthSlider setMaximumTrackImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_bar_active"] forState:UIControlStateNormal];
    [markerWidthSlider setMinimumTrackImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_bar_inactive"] forState:UIControlStateNormal];
//    [markerWidthSlider setThumbImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_handle"] forState:UIControlStateNormal];
    [markerWidthSlider setMinimumValue:kPenWidthMin];
    [markerWidthSlider setMaximumValue:kPenWidthMax];
    [markerWidthSlider addTarget:self action:@selector(widthChange:) forControlEvents:UIControlEventValueChanged];
    [markerWidthSlider setValue:kPenWidthMax / 2];
    [markerWidthSlider setBackgroundColor:[UIColor clearColor]];
    [markerWidthSlider setTag:PEN_WIDTH_SLIDER_TAG];
    [markerWidthView addSubview:markerWidthSlider];
    markerWidthView.hidden = YES;
    [self.view addSubview:markerWidthView];
    
    viewY += (outButtonHeight + 10 + 5);
    eraserWidthView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, 310, 58)];
    UIColor *eraserBg = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_bg"]];
    [eraserWidthView setBackgroundColor:eraserBg];
    UISlider *eraserWidthSlider = [[UISlider alloc]initWithFrame:CGRectMake(15, 12, 185, 29)];
    [eraserWidthSlider setMaximumTrackImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_bar_active"] forState:UIControlStateNormal];
    [eraserWidthSlider setMinimumTrackImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_bar_inactive"] forState:UIControlStateNormal];
//    [eraserWidthSlider setThumbImage:[UIImage imageNamed:@"ppt_toolbox_eraser_adjust_handle"] forState:UIControlStateNormal];
    [eraserWidthSlider setMinimumValue:kPenWidthMin];
    [eraserWidthSlider setMaximumValue:kPenWidthMax];
    [eraserWidthSlider addTarget:self action:@selector(widthChange:) forControlEvents:UIControlEventValueChanged];
    [eraserWidthSlider setValue:kPenWidthDefault];
    [eraserWidthSlider setBackgroundColor:[UIColor clearColor]];
    [eraserWidthSlider setTag:PEN_WIDTH_SLIDER_TAG];
    eraserWidthView.hidden = YES;
    [eraserWidthView addSubview:eraserWidthSlider];
    
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(210, 12, 81, 34)];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"ppt_toolbox_eraser_delete_all"] forState:UIControlStateNormal];
    [clearButton setTitle:@"清空全部" forState:UIControlStateNormal];
//    [clearButton setTintColor:[UI Color redColor]];
    [clearButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [eraserWidthView addSubview:clearButton];
    [self.view addSubview:eraserWidthView];
    
}

//左边工具栏消失吧。。为啥不用uianimation的block。。
- (void)swatchDisappear:(UIView *)view{
    CGRect rect = view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    rect.size.width = 0;
    view.frame = rect;
    [UIView commitAnimations];
}

//基本同上
- (void)swatchAppear:(UIView *)view{
    CGRect rect = view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    rect.size.width = 6 * 60 + 4 * 10 + 40;
    view.frame = rect;
    [UIView commitAnimations];
}

//于是这里又用了block。。。目测是原来的？
- (void)viewDisappear:(UIView *)view{
    if (view.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             view.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             view.hidden = YES;
         }
         ];
	}
}

//
- (void)viewAppear:(UIView *)view{
    if (view.hidden == YES)
	{
//        NSLog(@"show");
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             view.hidden = NO;
             view.alpha = 1.0f;
         }
                         completion:NULL
         ];
	}

}
//清除画过的东西。包括以前画过的。
- (void)clearAction:(id)button{
    [self.drawNewView clear];
}
//奇怪的函数命名。。选取颜色
- (void)choColorAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    UIColor *color = button.backgroundColor;
//    UIButton *originalButton = [noteToolDrawerBar.buttonArray objectAtIndex:0];
//    [originalButton setBackgroundColor:color];
    self.drawNewView.lineColor = color;
    curPenColor = color;
    [self viewDisappear:swatchView];
}

//初始化书签编辑框
- (void)initMarkEditView{
    UIImage *image = [UIImage imageNamed:@"ppt_popup_bg"];
    markEditView = [[UIView alloc]initWithFrame:CGRectMake((1024 - image.size.width) / 2,(768 - image.size.height) / 2, image.size.width, image.size.height)];
    UIColor *background = [UIColor colorWithPatternImage:image];
    [markEditView setBackgroundColor:background];
    [markEditView setAlpha:0.0f];
    [self.view addSubview:markEditView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(143, 45, 160, 40)];
    [label setText:@"添加成功"];
    [label setTextColor:[UIColor colorWithRed:216.0 / 255 green:65.0 / 255 blue:87.0 / 255 alpha:1.0]];
    [label setFont:[UIFont systemFontOfSize:36]];
    [markEditView addSubview:label];
    
    markField = [[UITextField alloc]initWithFrame:CGRectMake(36, 120, image.size.width - 36 * 2, 47)];
    [markField setBackground:[UIImage imageNamed:@"ppt_popup_editbookmarkname"]];
    [markField setPlaceholder:@"为该书签页命名"];
    markField.delegate = self;
    [markEditView addSubview:markField];

    int button_height = 60;
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sureButton setFrame:CGRectMake(0, markEditView.frame.size.height - button_height, image.size.width / 2, button_height)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTintColor:[UIColor colorWithRed:69.0 / 255 green:69.0 / 255 blue:69.0 / 255 alpha:1.0]];
    [sureButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [markEditView addSubview:sureButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setFrame:CGRectMake(image.size.width / 2, markEditView.frame.size.height - button_height, image.size.width / 2, button_height)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTintColor:[UIColor colorWithRed:69.0 / 255 green:69.0 / 255 blue:69.0 / 255 alpha:1.0]];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [markEditView addSubview:cancelButton];
    
    
}
//书签编辑确定按钮
-(void)sureAction:(id)sender
{
    [self showMarkEditView:markEditView];
    NSString *text = markField.text;
    int page = [document.pageNumber intValue];
    if (text == nil || [text isEqualToString:@""]) {
        text = [NSString stringWithFormat:@"Page %d",page];
    }
    [document.markTexts setObject:text forKey:[NSString stringWithFormat:@"%d",page]];
}

//书签编辑取消按钮
-(void)cancelAction:(id)sender
{
    [self showMarkEditView:markEditView];
    int page = [document.pageNumber intValue];
    NSString *text = [NSString stringWithFormat:@"Page %d",page];
    [document.markTexts setObject:text forKey:[NSString stringWithFormat:@"%d",page]];

}

//初始化滑动条 。。笔触宽度==妈蛋想半天。。
-(void)initSlider{
    //Init Fader slider UI, set listener method and Transform it to vertical
    
    //宽度滑动条
    self.lineWidthSlider = [[UISlider alloc]initWithFrame:CGRectMake(100, 500, 150, 29)];
    [self.lineWidthSlider setMinimumValue:kPenWidthMin];
    [self.lineWidthSlider setMaximumValue:kPenWidthMax];
    [self.lineWidthSlider addTarget:self action:@selector(widthChange:) forControlEvents:UIControlEventValueChanged];
    
    self.lineWidthSlider.backgroundColor = [UIColor clearColor];
    
    /*
    UIImage *stetchTrack = [[UIImage imageNamed:@"faderTrack.png"]
                            stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    [lineWidthSlider setThumbImage: [UIImage imageNamed:@"faderKey.png"] forState:UIControlStateNormal];
    [lineWidthSlider setMinimumTrackImage:stetchTrack forState:UIControlStateNormal];
    [lineWidthSlider setMaximumTrackImage:stetchTrack forState:UIControlStateNormal];
     */
    //居然用到了矩阵变换？为啥要旋转呢？应该是因为横竖屏吧。
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    self.lineWidthSlider.transform = trans;
    self.lineWidthSlider.value = kPenWidthDefault;
    self.lineWidthSlider.hidden = YES;
    [self.view addSubview:self.lineWidthSlider];
    
    //透明度滑动条
    self.lineAlphaSlider = [[UISlider alloc]initWithFrame:CGRectMake(1024 - 100, 500, 150, 20)];
    [self.lineAlphaSlider setMinimumValue:kPenAlphaMin];
    [self.lineAlphaSlider setMaximumValue:kPenAlphaMax];
    [self.lineAlphaSlider addTarget:self action:@selector(alphaChange:) forControlEvents:UIControlEventValueChanged];
    self.lineAlphaSlider.backgroundColor = [UIColor clearColor];
    
    trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    self.lineAlphaSlider.transform = trans;
    self.lineAlphaSlider.value = kPenAlphaDefault;
    self.lineAlphaSlider.hidden = YES;
    [self.view addSubview:self.lineAlphaSlider];
    
}

//
- (void)widthChange:(UISlider *)sender{
    self.drawNewView.lineWidth = sender.value;
    curPenWidth = sender.value;

}
//
- (void)alphaChange:(UISlider *)sender{
    self.drawNewView.lineAlpha = sender.value;
}



#pragma Notebar delegate
//这个函数是废了么？
- (void)tappedInNoteToolbar:(NoteToolbar *)toolbar choiceColor:(UIButton *)button{
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a color"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", nil];
    
    [actionSheet setTag:kActionSheetColor];
    [actionSheet showInView:self.view];
     */
}

//
- (void)tappedInNoteToolbar:(NoteToolbar *)toolbar choiceWidth:(UIButton *)button{
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    [self.navigationController.navigationBar setHidden:NO];
}
//这些回调函数的名字真的能简单读懂么。。
- (void)tappedInNoteToolbar:(NoteToolbar *)toolbar choicePen:(UIButton *)button{
    //于是无端端就保存了。。好吧我不懂。。
    [self stopDraw];
    [self saveDraw];
    int page = [document.pageNumber intValue];
    NSNumber *key = [NSNumber numberWithInteger:page]; // # key
    ReaderContentView *newContentView = [contentViews objectForKey:key];
    [self addDrawView:newContentView];
}
//选择刷子。。为毛总要取反值？
- (void)tappedInNoteToolbar:(NoteToolbar *)toolbar choiceBrush:(UIButton *)button{
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
}

- (void)tappedInNoteToolbar:(NoteToolbar *)toolbar choiceErase:(UIButton *)button{
    //高端。。。居然引入了一个新的Eraser
    currentToolType = ACEDrawingToolTypeEraser;
    [self startDraw];
    //擦完了又startDraw。stopdraw 和save 在哪里呢？
}
//特别想知道undolateststep在界面上的哪里有？
- (void)tappedInNoteToolbar:(NoteToolbar *)toolbar undoAction:(UIButton *)button{
    [self.drawNewView undoLatestStep];
}
//同上。。
- (void)tappedInNoteToolbar:(NoteToolbar *)toolbar redoAction:(UIButton *)button{
    [self.drawNewView redoLatestStep];
}
//清除全部
- (void)tappedInNoteToolbar:(NoteToolbar *)toolbar clearAction:(UIButton *)button{
    [self.drawNewView clear];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    //上次有打开过
	if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
	{
		if (CGSizeEqualToSize(lastAppearSize, self.view.bounds.size) == false)
		{
            //更新？lastAppearsize作用似乎不大？
			[self updateScrollViewContentViews]; // Update content views
		}

		lastAppearSize = CGSizeZero; // Reset view size tracking
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero)) // First time
	{
		[self performSelector:@selector(showDocument:) withObject:nil afterDelay:0.02];
	}
//我猜是常亮屏幕吧？
#if (READER_DISABLE_IDLE == TRUE) // Option

	[UIApplication sharedApplication].idleTimerDisabled = YES;

#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	lastAppearSize = self.view.bounds.size; // Track view size

#if (READER_DISABLE_IDLE == TRUE) // Option

	[UIApplication sharedApplication].idleTimerDisabled = NO;

#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
//iOS7appear和disappear函数好像废了yeah。
- (void)viewDidUnload
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	mainToolbar = nil; mainPagebar = nil;

	theScrollView = nil; contentViews = nil; lastHideTime = nil;

	lastAppearSize = CGSizeZero; currentPage = 0;

	[super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{   //高端
	if (isVisible == NO) return; // iOS present modal bodge

	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		if (printInteraction != nil) [printInteraction dismissAnimated:NO];//跟print有啥关系
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	if (isVisible == NO) return; // iOS present modal bodge

	[self updateScrollViewContentViews]; // Update content views

	lastAppearSize = CGSizeZero; // Reset view size tracking
}

/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//if (isVisible == NO) return; // iOS present modal bodge

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


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UIScrollViewDelegate methods


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [mainPagebar updatePagebar];
    if (markEditView.alpha == 1) {
        [self showMarkEditView:markEditView];
    }//?

	__block NSInteger page = 0;
    

	CGFloat contentOffsetX = scrollView.contentOffset.x;

	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
		^(id key, id object, BOOL *stop)
		{
			ReaderContentView *contentView = object;

			if (contentView.frame.origin.x == contentOffsetX)
			{
				page = contentView.tag; *stop = YES;
			}
		}
	];
    //获取当前页数，并展示。（page 相同等保护机制在showDocumentPage函数内）
	if (page != 0) [self showDocumentPage:page]; // Show the page
}

//
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self showDocumentPage:theScrollView.tag]; // Show page
    //调用了两次啊总感觉==
	theScrollView.tag = 0; // Clear page number tag
    [mainPagebar updatePagebar];
    if (markEditView.alpha == 1) { //妈蛋又是这句。。
        [self showMarkEditView:markEditView];
    }
}

#pragma mark UIGestureRecognizerDelegate methods

//是否继续回调下去。。。有可能这里么？
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
    //if ([touch.view isKindOfClass:[UIScrollView class]]) {
        
        return YES;
    //}
    NSLog(@"no huidiao");
	return NO;
}

#pragma mark UIGestureRecognizer action methods

- (void)decrementPageNumber
{
    
	if (theScrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [document.pageNumber integerValue];
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1; // Minimum

		if ((maxPage > minPage) && (page != minPage))
		{
            //看到下面被注释掉的这两货。。
//            [self saveDraw];
//            [self stopDraw];
            if (noteToolDrawerBar.center.x == noteToolDrawerBar.openPoint.x) {//奇怪的判断语句。。
                [noteToolDrawerBar openOrCloseToolBar];
            }
			CGPoint contentOffset = theScrollView.contentOffset;

			contentOffset.x -= theScrollView.bounds.size.width; // -= 1

			[theScrollView setContentOffset:contentOffset animated:YES];

			theScrollView.tag = (page - 1); // Decrement page number
		}//
	}
    
}

- (void)incrementPageNumber
{
    
	if (theScrollView.tag == 0) // Scroll view did end
	{
		NSInteger page = [document.pageNumber integerValue];
		NSInteger maxPage = [document.pageCount integerValue];
		NSInteger minPage = 1; // Minimum

		if ((maxPage > minPage) && (page != maxPage))
		{
            if (noteToolDrawerBar.center.x == noteToolDrawerBar.openPoint.x) {
                [noteToolDrawerBar openOrCloseToolBar];
            }
            
//            [self saveDraw];
//            [self stopDraw];
			CGPoint contentOffset = theScrollView.contentOffset;

			contentOffset.x += theScrollView.bounds.size.width; // += 1

			[theScrollView setContentOffset:contentOffset animated:YES];

			theScrollView.tag = (page + 1); // Increment page number
		}
	}
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"%s",__FUNCTION__);
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
        if (markEditView.alpha == 1) {
            [self showMarkEditView:markEditView];
            //不懂。。
        }
		CGRect viewRect = recognizer.view.bounds; // View bounds

		CGPoint point = [recognizer locationInView:recognizer.view];

		CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area

		if (CGRectContainsPoint(areaRect, point)) // Single tap is inside the area
		{
            NSInteger page = [document.pageNumber integerValue]; // Current page #

			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key

			ReaderContentView *targetView = [contentViews objectForKey:key];

			id target = [targetView processSingleTap:recognizer]; // Target
            //这居然还有url？妈蛋这是在逗我？这太强大了吧。。==。。
			if (target != nil) // Handle the returned target object
			{
				if ([target isKindOfClass:[NSURL class]]) // Open a URL
				{
					NSURL *url = (NSURL *)target; // Cast to a NSURL object

					if (url.scheme == nil) // Handle a missing URL scheme
					{
						NSString *www = url.absoluteString; // Get URL string

						if ([www hasPrefix:@"www"] == YES) // Check for 'www' prefix
						{
							NSString *http = [NSString stringWithFormat:@"http://%@", www];

							url = [NSURL URLWithString:http]; // Proper http-based URL
						}
					}

					if ([[UIApplication sharedApplication] openURL:url] == NO)
					{
						#ifdef DEBUG
							NSLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
						#endif
					}
				}
				else // Not a URL, so check for other possible object type
				{
					if ([target isKindOfClass:[NSNumber class]]) // Goto page
					{
						NSInteger value = [target integerValue]; // Number

						[self showDocumentPage:value]; // Show the page
                        
					}
				}
			}
			else // Nothing active tapped in the target content view
			{
				if ([lastHideTime timeIntervalSinceNow] < -0.75) // Delay since hide
				{
					if ((mainToolbar.hidden == YES) || (mainPagebar.hidden == YES)
                        /*|| (noteToolDrawerBar.hidden == YES)*/)
					{
                        NSLog(@"冲突");
                        //不是这里。
						[mainToolbar showToolbar];
                        [mainPagebar showPagebar]; // Show
//                        [noteToolDrawerBar showNoteToolDrawerBar];
//                        [self viewAppear:penWidthView];
//                        [self viewAppear:swatchView];
//                        [self viewAppear:eraserWidthView];
//                        [self viewAppear:markerWidthView];
					}
                    
				}
			}

			return;
		}
        //宏定义得略恶心。。
		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
       
		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			[self incrementPageNumber]; return;
		}

		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;

		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{

			[self decrementPageNumber]; return;
		}
        
	}
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"%s",__FUNCTION__);
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds

		CGPoint point = [recognizer locationInView:recognizer.view];

		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);

		if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
		{
			NSInteger page = [document.pageNumber integerValue]; // Current page #

			NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key

			ReaderContentView *targetView = [contentViews objectForKey:key];
            //妈蛋这个手势真是玩死人。。
			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom ++
				{
					[targetView zoomIncrement]; break;
				}

				case 2: // Two finger double tap: zoom --
				{
					[targetView zoomDecrement]; break;
				}
			}

			return;
		}

		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);

		if (CGRectContainsPoint(nextPageRect, point)) // page++ area
		{
			[self incrementPageNumber]; return;
		}

		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;

		if (CGRectContainsPoint(prevPageRect, point)) // page-- area
		{
			[self decrementPageNumber]; return;
		}
	}
}

#pragma mark ReaderContentViewDelegate methods

//妈蛋终于开始touchbegan的函数了。。好吧我是真看不懂==
- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
{
    NSLog(@"content touch begin");
	if ((mainToolbar.hidden == NO) || (mainPagebar.hidden == NO)
        /*|| (noteToolDrawerBar.hidden == NO)*/)
	{
		if (touches.count == 1) // Single touches only
		{
			UITouch *touch = [touches anyObject]; // Touch info

			CGPoint point = [touch locationInView:self.view]; // Touch location

			CGRect areaRect = CGRectInset(self.view.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);

			if (CGRectContainsPoint(areaRect, point) == false) return;
		}

		[mainToolbar hideToolbar];
        [mainPagebar hidePagebar]; // Hide
//        [noteToolDrawerBar hideNoteToolDrawerBar];
        [self viewDisappear:markerWidthView];
        [self viewDisappear:eraserWidthView];
        [self viewDisappear:swatchView];
        [self viewDisappear:penWidthView];

		lastHideTime = [NSDate date];
	}
    if (markEditView.alpha == 1) {
        [self showMarkEditView:markEditView];
    }
}


#pragma mark ReaderMainToolbarDelegate methods

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button
{
#if (READER_STANDALONE == FALSE) // Option

	[document saveReaderDocument]; // Save any ReaderDocument object changes

	[[ReaderThumbQueue sharedInstance] cancelOperationsWithGUID:document.guid];

	[[ReaderThumbCache sharedInstance] removeAllObjects]; // Empty the thumb cache

	if (printInteraction != nil) [printInteraction dismissAnimated:NO]; // Dismiss

	if ([delegate respondsToSelector:@selector(dismissReaderViewController:)] == YES)
	{
		[delegate dismissReaderViewController:self]; // Dismiss the ReaderViewController
        
	}
	else // We have a "Delegate must respond to -dismissReaderViewController: error"
	{
		NSAssert(NO, @"Delegate must respond to -dismissReaderViewController:");
	}

#endif // end of READER_STANDALONE Option
}
//跳转到书签页。。
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar thumbsButton:(UIButton *)button
{
    
    CourseMarkViewController *courseMarkViewController = [[CourseMarkViewController alloc]initWithReaderDocument:document];
    courseMarkViewController.delegate = self;
    
    [self presentViewController:courseMarkViewController animated:YES completion:nil];
}
//打印的函数吧。可以忽略的。
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar printButton:(UIButton *)button
{
#if (READER_ENABLE_PRINT == TRUE) // Option

	Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");

	if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
	{
		NSURL *fileURL = document.fileURL; // Document file URL

		printInteraction = [printInteractionController sharedPrintController];

		if ([printInteractionController canPrintURL:fileURL] == YES) // Check first
		{
			UIPrintInfo *printInfo = [NSClassFromString(@"UIPrintInfo") printInfo];

			printInfo.duplex = UIPrintInfoDuplexLongEdge;
			printInfo.outputType = UIPrintInfoOutputGeneral;
			printInfo.jobName = document.fileName;

			printInteraction.printInfo = printInfo;
			printInteraction.printingItem = fileURL;
			printInteraction.showsPageRange = YES;

			if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
			{
				[printInteraction presentFromRect:button.bounds inView:button animated:YES completionHandler:
					^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
					{
						#ifdef DEBUG
							if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
						#endif
					}
				];
			}
			else // Presume UIUserInterfaceIdiomPhone
			{
				[printInteraction presentAnimated:YES completionHandler:
					^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
					{
						#ifdef DEBUG
							if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
						#endif
					}
				];
			}
		}
	}

#endif // end of READER_ENABLE_PRINT Option
}
//发email。。也可以忽略。
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar emailButton:(UIButton *)button
{
#if (READER_ENABLE_MAIL == TRUE) // Option

	if ([MFMailComposeViewController canSendMail] == NO) return;

	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	unsigned long long fileSize = [document.fileSize unsignedLongLongValue];

	if (fileSize < (unsigned long long)15728640) // Check attachment size limit (15MB)
	{
		NSURL *fileURL = document.fileURL; NSString *fileName = document.fileName; // Document

		NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];

		if (attachment != nil) // Ensure that we have valid document file attachment data
		{
			MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];

			[mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];

			[mailComposer setSubject:fileName]; // Use the document file name for the subject

			mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
			mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;

			mailComposer.mailComposeDelegate = self; // Set the delegate

			[self presentViewController:mailComposer animated:YES completion:NULL];
		}
	}

#endif // end of READER_ENABLE_MAIL Option
}
//设置笔记
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar markButton:(UIButton *)button
{
    
    
	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	NSInteger page = [document.pageNumber integerValue];

	if ([document.bookmarks containsIndex:page]) // Remove bookmark
	{
		[mainToolbar setBookmarkState:NO];
        [document.bookmarks removeIndex:page];
        
	}
	else // Add the bookmarked page index to the bookmarks set
	{
        [self showMarkEditView:markEditView];
		[mainToolbar setBookmarkState:YES];
        [document.bookmarks addIndex:page];
        NSString *text = [NSString stringWithFormat:@"Page %d",page];
        [document.markTexts setObject:text forKey:[NSString stringWithFormat:@"%d",page]];
	}
    
}
//奇怪的设计。。
- (void)showMarkEditView:(UIView *)view
{
    if (view.alpha == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGRect rect = view.frame;
        rect.origin.y -= 20;
        view.frame = rect;
        view.alpha = 1.0;
        [UIView commitAnimations];
        [markField setText:nil];
    }
    else if (view.alpha == 1){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect rect = view.frame;
        rect.origin.y += 20;
        view.frame = rect;
        view.alpha = 0.0;
        [UIView commitAnimations];
        
        
    }
}


#pragma mark MFMailComposeViewControllerDelegate methods
//发邮件可以不管
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	#ifdef DEBUG
		if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
	#endif

	[self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss
}
//似乎都没调用
#pragma mark ThumbsViewControllerDelegate methods

- (void)dismissThumbsViewController:(ThumbsViewController *)viewController
{
	[self updateToolbarBookmarkIcon]; // Update bookmark icon

	[self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss
}
//似乎都没调用

- (void)thumbsViewController:(ThumbsViewController *)viewController gotoPage:(NSInteger)page
{
    [self showDocumentPage:page]; // Show the page
}

#pragma mark ReaderMainPagebarDelegate methods
//下面的跳转
- (void)pagebar:(ReaderMainPagebar *)pagebar gotoPage:(NSInteger)page
{
    if (noteToolDrawerBar.center.x == noteToolDrawerBar.openPoint.x) {
        [noteToolDrawerBar openOrCloseToolBar];
    }
	[self showDocumentPage:page]; // Show the page
}
- (void)pagebar:(ReaderMainPagebar *)pagebar leftAction:(UIButton *)button{
    [self decrementPageNumber];
}
- (void)pagebar:(ReaderMainPagebar *)pagebar rightAction:(UIButton *)button{
    [self incrementPageNumber];
}

#pragma mark UIApplication notification methods
//保存改动文档。。由于我们根本没改动==所以。。。
- (void)applicationWill:(NSNotification *)notification
{
	[document saveReaderDocument]; // Save any ReaderDocument object changes

	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		if (printInteraction != nil) [printInteraction dismissAnimated:NO];
	}
}

/*
#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {
            
            currentToolType = ACEDrawingToolTypePen;
            [self startDraw];
//            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawNewView.lineColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    self.drawNewView.lineColor = [UIColor redColor];
                    break;
                    
                case 2:
                    self.drawNewView.lineColor = [UIColor greenColor];
                    break;
                    
                case 3:
                    self.drawNewView.lineColor = [UIColor blueColor];
                    break;
            }
            
        } else {
            
//            self.toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.drawTool = ACEDrawingToolTypePen;
                    break;
                    
                case 1:
                    self.drawingView.drawTool = ACEDrawingToolTypeLine;
                    break;
                    
                case 2:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
                    break;
                    
                case 3:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleFill;
                    break;
                    
                case 4:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
                    break;
                    
                case 5:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseFill;
                    break;
                    
                case 6:
                    self.drawingView.drawTool = ACEDrawingToolTypeEraser;
                    break;
            }
            
            // if eraser, disable color and alpha selection
//            self.colorButton.enabled = self.alphaButton.enabled = buttonIndex != 6;
        }
    }
}
*/
#pragma CourseMarkView delegate
//抄得刚才的代码。。可以考虑删掉原来的吧。
- (void) courseMarkViewController:(CourseMarkViewController *)viewController gotoPage:(NSInteger)page
{
    [self showDocumentPage:page];
}
-(void) dismissMarkViewControoler:(CourseMarkViewController *)viewController
{
    [self updateToolbarBookmarkIcon]; // Update bookmark icon
    
	[self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss
}

#pragma NoteToolDrawerBar delegate
//怎么又来了== 应该按到其中一个按钮。。
- (void)tappedInNoteToolDrawerBar:(NoteToolDrawerBar *)toolDrawerBar toolAction:(UIButton *)button{
    NSLog(@"drawerbutton");
//    swatchView.hidden = YES;
//    penWidthView.hidden = YES;
//    eraserWidthView.hidden = YES;
//    markerWidthView.hidden = YES;
    [self viewDisappear:swatchView];
    [self viewDisappear:penWidthView];
    [self viewDisappear:eraserWidthView];
    [self viewDisappear:markerWidthView];
    
    
    if (button.selected) {
        currentToolType = ACEDrawingToolTypePen;
        [self startDraw];
        if (noteButton.selected == NO) {
            [self noteButtonAction:noteButton];
        }
        
    } else{
//        [self stopDraw];
//        [self saveDraw];
//        int page = [document.pageNumber intValue];
//        NSNumber *key = [NSNumber numberWithInteger:page]; // # key
//        ReaderContentView *newContentView = [contentViews objectForKey:key];
//        [self addDrawView:newContentView];
//        if (noteButton.selected == YES) {
//            [self noteButtonAction:noteButton];
//        }
    }
    switch (button.tag) {
        case 1:         //选择颜色
//            if (button.selected) {
//                swatchView.hidden = NO;
//                [self swatchAppear:swatchView];
                [self viewAppear:swatchView];
//            } else{
//                swatchView.hidden = YES;
//                [self swatchDisappear:swatchView];
//                [self viewDisappear:swatchView];
//            }
            
            break;
        case 2:         //选择钢笔
            if (button.selected) {
                currentToolType = ACEDrawingToolTypePen;
                drawNewView.drawTool = ACEDrawingToolTypePen;
                drawNewView.lineAlpha = 1.0f;
                curPenAlpha = 1.0f;
                UISlider *penWidthSlider = (UISlider *)[penWidthView viewWithTag:PEN_WIDTH_SLIDER_TAG];
                drawNewView.lineWidth = penWidthSlider.value;
                curPenWidth = penWidthSlider.value;
                [self viewAppear:penWidthView];
            } else{
                [self viewDisappear:penWidthView];
            }
            break;
        case 3:         //选择荧光笔
            if (button.selected) {
                currentToolType = ACEDrawingToolTypePen;
                drawNewView.drawTool = ACEDrawingToolTypePen;
                drawNewView.lineAlpha = kMarkAlphaDefault;
                curPenAlpha = kMarkAlphaDefault;
                UISlider *markWidthSlider = (UISlider *)[markerWidthView viewWithTag:PEN_WIDTH_SLIDER_TAG];
                drawNewView.lineWidth = markWidthSlider.value;
                curPenWidth = markWidthSlider.value;
                [self viewAppear:markerWidthView];
            } else{
                [self viewDisappear:markerWidthView];
            }
            break;
        case 4:         //选择橡皮
            if (button.selected) {
                if (currentToolType == ACEDrawingToolTypePen) {
                    UISlider *eraserWidthSlider = (UISlider *)[eraserWidthView viewWithTag:PEN_WIDTH_SLIDER_TAG];
                    if (drawNewView.lineAlpha == 1.0f) {
                        UISlider *penWidthSlider = (UISlider *)[penWidthView viewWithTag:PEN_WIDTH_SLIDER_TAG];
                        if (penWidthSlider.value >= kPenWidthMax / 2) {
                            [eraserWidthSlider setValue:penWidthSlider.value];
                        }else{
                            [eraserWidthSlider setValue:kPenWidthMax / 2];
                        }
                    } else if (drawNewView.lineAlpha == kMarkAlphaDefault){
                        UISlider *markWidthSlider = (UISlider *)[markerWidthView viewWithTag:PEN_WIDTH_SLIDER_TAG];
                        [eraserWidthSlider setValue:markWidthSlider.value];
                        if (markWidthSlider.value >= kPenWidthMax / 2) {
                            drawingView.lineWidth = markWidthSlider.value;
                            [eraserWidthSlider setValue:markWidthSlider.value];
                        } else{
                            drawingView.lineWidth = kPenWidthMax / 2;
                            [eraserWidthSlider setValue:kPenWidthMax / 2];
                        }
                    }
                }
                                currentToolType = ACEDrawingToolTypeEraser;
                drawNewView.drawTool = ACEDrawingToolTypeEraser;
//                eraserWidthView.hidden = NO;
                [self viewAppear:eraserWidthView];
            } else{
//                eraserWidthView.hidden = YES;
                [self viewDisappear:eraserWidthView];
            }
            break;
        case 5:         //选择相机
            
            break;
        case 6:         //选择录音
            
            break;
        default:
            break;
    }
}
//打开drawer 。。。没被调用啊妈蛋==
- (void)drawerOpen:(NoteToolDrawerBar *)toolDrawerBar{
    currentToolType = ACEDrawingToolTypePen;
    [self startDraw];
    NSLog(@"%s", __FUNCTION__);

}
//关闭drawer。。。没被调用啊妈蛋==
-(void)drawerClose:(NoteToolDrawerBar *)toolDrawerBar{
    [self viewDisappear:markerWidthView];
    [self viewDisappear:penWidthView];
    [self viewDisappear:swatchView];
    [self viewDisappear:eraserWidthView];
    [noteToolDrawerBar closeAllButton];
    [self stopDraw];
    [self saveDraw];
    int page = [document.pageNumber intValue];
    NSNumber *key = [NSNumber numberWithInteger:page]; // # key
    ReaderContentView *newContentView = [contentViews objectForKey:key];
    [self addDrawView:newContentView];
    NSLog(@"%s", __FUNCTION__);
}
#pragma ACEDrawView delegate
//没被调用。。
- (void)intoDrawState:(ACEDrawingView *)view{
//    [noteToolDrawerBar hideNoteToolDrawerBar];
   
    [mainPagebar hidePagebar];
    [mainToolbar hideToolbar];
    
    NSLog(@"妈蛋");
    /*
    if (!swatchView.hidden) {
        appearViewTag = SWATCH_VIEW_TAG;
    }
    if (!penWidthView.hidden) {
        appearViewTag = PEN_VIEW_TAG;
    }
    if (!markerWidthView.hidden) {
        appearViewTag = MARKER_VIEW_TAG;
    }
    if (!eraserWidthView.hidden) {
        appearViewTag = ERASER_VIEW_TAG;
    }
                               */
//    [self viewDisappear:markerWidthView];
//    [self viewDisappear:penWidthView];
//    [self viewDisappear:swatchView];
//    [self viewDisappear:eraserWidthView];
}

- (void)cancelDrawState:(ACEDrawingView *)view{
    NSLog(@"cancelDraw");
    /*
    [noteToolDrawerBar showNoteToolDrawerBar];
    [mainToolbar showToolbar];
    [mainPagebar showPagebar];
    if (appearViewTag == SWATCH_VIEW_TAG) {
        [self viewAppear:swatchView];
    }
    if (appearViewTag == PEN_VIEW_TAG) {
        [self viewAppear:penWidthView];
    }
    if (appearViewTag == MARKER_VIEW_TAG) {
        [self viewAppear:markerWidthView];
    }
    if (appearViewTag ==ERASER_VIEW_TAG) {
        [self viewAppear:eraserWidthView];
    }*/
}
#pragma Mark UITextFieldDelegate
// 下面两个方法是为了防止TextView让键盘挡住的方法
/*
 开始编辑UITextView的方法
 */
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect curFrame = markEditView.frame;
    [UIView animateWithDuration:0.3f animations:^{
        markEditView.frame = CGRectMake(curFrame.origin.x, curFrame.origin.y - 200, curFrame.size.width, curFrame.size.height);
    }];
}

/**
 结束编辑UITextView的方法，让原来的界面还原高度
 */
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    
    CGRect curFrame = markEditView.frame;
    [UIView beginAnimations:@"drogDownKeyBoard" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    markEditView.frame = CGRectMake(curFrame.origin.x, curFrame.origin.y + 200, curFrame.size.width, curFrame.size.height);
    [UIView commitAnimations];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    NSLog(@"CANPASS手势给别人么？");
    NSNumber *key = [NSNumber numberWithInteger:currentPage]; // # key
    //当前这页的view。。奇怪的变量名。。
    ReaderContentView *newContentView = [contentViews objectForKey:key];
    //newContentView.isNote = YES;
    if(newContentView.isNote == YES)
        return YES;
    else
        return NO;
}




@end
