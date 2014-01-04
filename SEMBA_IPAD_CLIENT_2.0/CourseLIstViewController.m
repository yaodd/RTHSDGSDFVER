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

@interface CourseLIstViewController (){
    NSArray *dataArr;
    MRProgressOverlayView *overlayView;
}

@end

@implementation CourseLIstViewController

@synthesize tableView  = _tableView;

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
	// Do any additional setup after loading the view.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *contentIdentifier = [NSString stringWithFormat:@"Cell%d%d",[indexPath section],[indexPath row]]; //以indexPath来唯一确定cell,不使用完全重用机制
    SingleCourseCell *cell = [ tableView dequeueReusableCellWithIdentifier:contentIdentifier];
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

@end
