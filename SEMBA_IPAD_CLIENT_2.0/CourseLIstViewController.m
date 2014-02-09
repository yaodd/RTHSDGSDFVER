//
//  CourseLIstViewController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/31/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import "CourseLIstViewController.h"
#import "SingleCourseCell.h"
#import "Dao.h"
#import "SysbsModel.h"
#import "CourseDetailViewController.h"
#import "MRProgressOverlayView.h"
#import "WebImgResourceContainer.h"

@interface CourseLIstViewController (){
    NSArray *dataArr;
    MRProgressOverlayView *overlayView;
    NSArray *imageArray;
    NSMutableDictionary *imageDict;
}

@end

@implementation CourseLIstViewController
@synthesize alreadyChooseTextView = _alreadyChooseTextView;
@synthesize tableView  = _tableView;
@synthesize alreadyChoose = _alreadyChoose;
@synthesize requestImageQuque = _requestImageQuque;
@synthesize originalIndexArray = _originalIndexArray;
@synthesize originalOperationDic = _originalOperationDic;

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
    NSOperationQueue *tempQueue = [[NSOperationQueue alloc]init];
    _requestImageQuque = tempQueue;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    self.originalIndexArray = array;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    self.originalOperationDic = dict;
    
    imageDict = [[NSMutableDictionary alloc]init];
    
    
    self.title = @"选课";
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont systemFontOfSize:19]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setText:@"选课"];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
	// Do any additional setup after loading the view.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    imageArray = [NSArray arrayWithObjects:@"lixinchun",@"lutaihong",@"maoyunshi", nil];
    dataArr = [[NSArray alloc]init];
    
    [self fetchAndLoadData];
    /*
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(fetchAndLoadData) object:nil];
    [thread start];*/
}



-(void)fetchAndLoadData{
    
    overlayView = [[MRProgressOverlayView alloc] init];
    overlayView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view addSubview:overlayView];
    [overlayView show:YES];

    Dao *dao = [Dao sharedDao];
    SysbsModel *model = [SysbsModel getSysbsModel];
    
    int rs = [dao requestForChooseCourseList:model.user.class_num userid:model.user.uid];
    NSLog(@"class_num %d uid %d",model.user.class_num,model.user.uid);
    if(rs == 1){
        
        [self updateContent];
       // [self displayProductImage];
        
    }else if(rs == -2){//弹窗 选课
        
    }else if(rs == 0){//弹窗网络差。
        
    }else{
        
    }
    [overlayView dismiss:YES];
}

-(void)updateContent{
    SysbsModel *model = [SysbsModel getSysbsModel];
    ChooseCourseListResult *result = model.chooseCourseListResult;
    NSArray *arr = result.arr;
    //int l = [arr count];
    dataArr = [NSArray arrayWithArray:arr];
    [_tableView reloadData];
    
    int len = [dataArr count];
    int now_index = 0;
    NSString *showtext = @"";
    for (int i = 0 ; i < len ; ++i){
        SingleChooseCourseDataObject *singeDataObj = [dataArr objectAtIndex:i];
        if(singeDataObj.haveselected == YES){
            NSString *dateshow;
            if( [singeDataObj.startdate length]>=10 && [singeDataObj.enddate length] >=10 ){
                NSString *datestarttext = [singeDataObj.startdate substringWithRange:NSMakeRange(5, 5)];
                NSString *dateendtext = [singeDataObj.enddate substringWithRange:NSMakeRange(5, 5)];
                dateshow = [NSString stringWithFormat:@"%@到%@",datestarttext,dateendtext];
            }else{
                dateshow = @"";
            }
            showtext = [showtext stringByAppendingString:[NSString stringWithFormat:@"\n%d %@ %@",(now_index+1),singeDataObj.courseTitle , dateshow] ];
            now_index++;
        }
    }
    CGRect rect = _alreadyChooseTextView.frame;
    rect.size.height = [self heightForTextView:_alreadyChooseTextView WithText:showtext];
    _alreadyChooseTextView.text = showtext;
    _alreadyChooseTextView.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *contentIdentifier = [NSString stringWithFormat:@"Cell%d%d",[indexPath section],[indexPath row]]; //以indexPath来唯一确定cell,不使用完全重用机制
    SingleCourseCell *cell = [ tableView dequeueReusableCellWithIdentifier:contentIdentifier];
    NSLog(@"contentident %@",contentIdentifier);
    if(cell == nil){
        cell = [[SingleCourseCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentIdentifier];
    }
    //加载内容.
    int row = indexPath.row;
    SingleChooseCourseDataObject *singeDataObj = [dataArr objectAtIndex:row];
    cell.titleLabel.text = singeDataObj.courseTitle;
    cell.peopleNumLabel.text = [NSString stringWithFormat:@"已选%d人/限选%d人",singeDataObj.nowChooseNum,singeDataObj.maxChooseNum];
    NSString *startdate = [singeDataObj.startdate substringWithRange:NSMakeRange(5, 5)];
    NSString *enddate = [singeDataObj.enddate substringWithRange:NSMakeRange(5, 5)];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@到%@",startdate,enddate];
    
    /*
    NSString *teacher = (NSString*)[singeDataObj.teacherArr objectAtIndex:0];
    int teachernum = [singeDataObj.teacherArr count];
    for (int i = 1 ; i < teachernum ; ++i) {
        teacher = [teacher stringByAppendingString:teacher];
    }
    cell.nameLabel.text = teacher;
     */
    
    cell.contentTextView.text = singeDataObj.contentShortView;
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    cell.imageView.tag = row + 1;
    cell.imageView.image = [UIImage imageNamed:@"fengmian"];

    //cell.imageView.image = [UIImage imageNamed:@"abc"];
    [imageDict setObject:cell.imageView forKey:[NSString stringWithFormat:@"%d",row]];
    if (row == [dataArr count] - 1){
        [self displayProductImage];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseDetailViewController *controller = [[CourseDetailViewController alloc]initWithNibName:Nil bundle:nil courseid:indexPath.row];
    [self.navigationController pushViewController:controller animated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

-(float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}

-(void)displayProductImage{
    //设置根ip地址
    
    NSURL *url = [NSURL URLWithString:@"http://115.28.18.130/SEMBADEVELOP/img/head/"];
    int imageCount = [dataArr count];//[courseArray count];
    for (int i = 0 ; i < imageCount ; ++i) {
        SingleChooseCourseDataObject *singeDataObj = [dataArr objectAtIndex:i];
        //Course* course = [courseArray objectAtIndex:i];
        if (
            [singeDataObj.coverUrl isEqualToString:@""] == NO){
            //获取网络图片。
            NSLog(@"choose from internet");
            NSURL *url = [NSURL URLWithString:singeDataObj.coverUrl];
            NSLog(@"fukcing url%@",singeDataObj.coverUrl);
            //NSURL *url ;//= [NSURL URLWithString:course.coverUrl];
            //NSLog(@"%@",course.coverUrl);
            [self displayImageByIndex:i ByImageURL:url];
        }else{
            //上默认图片
            continue;
            NSLog(@"默认图片");
        }
    }
}

-(void)displayImageByIndex:(NSInteger)index ByImageURL:(NSURL*)url{
    NSString *indexForString =[NSString stringWithFormat:@"%d",index];
    if([self.originalIndexArray containsObject:indexForString]){
        return;
    }
    NSLog(@"fucking index%d",index);
    NSString *contentIdentifier = [NSString stringWithFormat:@"Cell%d%d",0,index]; //以indexPath来唯一确定cell,不使用完全重用机制
    SingleCourseCell *cell = [ _tableView
                              dequeueReusableCellWithIdentifier:contentIdentifier];
    NSLog(@"choose content%@",contentIdentifier);
    NSLog(@"something%@",cell.titleLabel.text);
    UIImageView *imageView = [imageDict objectForKey:[NSString stringWithFormat:@"%d",index]];//cell.imageView;//= courseItem.courseImg;
    NSLog(@"imageview tag %d",imageView.tag);
    //[courseItem addSubview:imageView];
    //courseItem.courseImg;
    //imageView.tag = index;
    WebImgResourceContainer *imageOperation = [[WebImgResourceContainer alloc]init];
    
    imageOperation.resourceURL = url;
    imageOperation.hostObject = self;
    
    imageOperation.resourceDidReceive = @selector(imageDidReceive:);
    imageOperation.imageView = imageView;
    
    [_requestImageQuque addOperation:imageOperation];
    [self.originalOperationDic setObject:imageOperation forKey:indexForString];
}

-(void)imageDidReceive:(UIImageView*)imageView{
    if(imageView== nil || imageView.image ==nil){
        //
        return ;
    }
    NSLog(@"create new image");
    //imageView.frame = CGRectMake(0, 0, 300, 300);
    //[self.view addSubview:imageView];
    
}


@end
