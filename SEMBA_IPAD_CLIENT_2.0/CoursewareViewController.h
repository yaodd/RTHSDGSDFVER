//
//	ReaderDemoController.h
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



#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "MRCircularProgressView.h"
#import "DownloadModel.h"

@interface CoursewareViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate,UISearchBarDelegate,MRProgressDelegate,DownloadModelDelegate>

@property (nonatomic, retain) UITableView *courseTableView;
@property (nonatomic, retain) NSMutableArray *PDFUrlArray;
@property (nonatomic, retain) NSMutableArray *PDFPathArray;
@property (nonatomic, retain) NSMutableArray *progressArray;
@property (strong , nonatomic) ASINetworkQueue *downloadQueue;
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSString *courseFolderName;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *originalArray;
@property (nonatomic, retain) NSMutableArray *displayArray;
@property (nonatomic, retain) NSMutableArray *displayButtonArray;
@property (nonatomic, retain) NSMutableArray *displayProgArray;
@property (nonatomic) int buttonNumber;
@end
