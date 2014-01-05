//
//  NoticeController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-31.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "NoticeController.h"
#import "NoticeTableCell.h"
#import "DataItem.h"
#import "Dao.h"
#import "SysbsModel.h"
#import "MRProgressOverlayView.h"

#define kTitleKey @"title"
#define kContentKey @"content"
#define kDateKey @"date"

@interface NoticeController (){
    MRProgressOverlayView *overlayView;
}

@end

@implementation NoticeController
{
    int dataCount;
}

@synthesize searchBar;
@synthesize noticeTableView;
@synthesize dataArray;
@synthesize originDataArray;
@synthesize naviBarView;

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
    originDataArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    
    UIImageView *navBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 905, 60)];

    //center title in the navigation bar
    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(350, 31, 118, 39)];
    title.image = [UIImage imageNamed:@"news center"];
    [navBar addSubview:title];
    [self.view addSubview:navBar];
    
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 905, 4)];
    topLine.image = [UIImage imageNamed:@"line_head"];
    [self.view addSubview:topLine];
    
    noticeTableView = [[NoticeTableView alloc] initWithFrame:CGRectMake(39,
                                                                        100,
                                                                        726, self.view.frame.size.width - 100)];
    [noticeTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:noticeTableView];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(33, 69, 725, 60)];
    searchBar.backgroundColor = [UIColor clearColor];
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [searchBar setPlaceholder:@""];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    //[self setData];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(setData) object:nil];
    //[self performSelector:@selector(setData) withObject:nil afterDelay:0  ];
    [thread start];
}

//Set the data of server to tableView

- (void)setData;
{
    Dao *dao = [Dao sharedDao];
    SysbsModel *model = [SysbsModel getSysbsModel];
    
    overlayView = [[MRProgressOverlayView alloc]init];
    overlayView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view addSubview:overlayView];
    [overlayView show:YES];
    
    
    int ret = [dao requestForNotices:model.user.uid];
    
    if(ret == 1){
        self.originDataArray = nil;
        self.originDataArray = [[NSMutableArray alloc]init];
        SysbsModel *model = [SysbsModel getSysbsModel];
        AllNoticeData *noticedatas  = model.myMessage;
        NSArray *msgArr = [noticedatas getMessages];
        int msgLen = [noticedatas getMessageNum];
        for(int i = 0 ; i < msgLen ; ++i){
            
            DataItem *item = [[DataItem alloc] init];
            NoticeData *singleData = [msgArr objectAtIndex:i];
            item.title = singleData.messageTitle;
            item.content = singleData.messageContent;
            item.date = singleData.date;
            item.isSelected = @"NO";
            [self.originDataArray addObject:item];
        }
        NSLog(@"MSGLEN%d",msgLen);
        /*
        DataItem *item = [[DataItem alloc] init];
        item.title = @"本地数据";
        item.content = @"本地数据";
        item.date = @"2012-10-23 12:00:00";
        item.isSelected = @"NO";
        [self.originDataArray addObject:item];
         */
        [self.noticeTableView setTableViewData:originDataArray];
        [self.noticeTableView reloadData];
    }else if(ret == 0){
    
    }else {
    
    }
    [self endLoading];
    NSLog(@"endLoadingpre");
    /*
    NSMutableArray *title = [[NSMutableArray alloc] initWithObjects:@"通知1", @"通知2", @"通知3", @"通知4", @"通知5", @"通知1", @"通知2", @"通知3", @"通知4", @"通知5", nil];
    
    NSMutableArray *date = [[NSMutableArray alloc] initWithObjects:@"aaaaaa", @"aaaaaaaa", @"aaaaaaa", @"aaaaaaaa", @"asaaaaaa", @"aaaaaa", @"aaaaaaaa", @"aaaaaaa", @"aaaaaaaa", @"asaaaaaa", nil];
    
    
    NSString *content1 = @"审视我国的周边形势，周边环境发生了很大变化，我国同周边国家的关系发生了很大变化，我国同周边国家的经贸联系更加紧密、互动空前密切。这客观上要求我们的周边外交战略和工作必须与时俱进、更加主动。";
    NSString *content2 = @"近平指出，新中国成立后，以毛泽东同志为核心的党的第一代中央领导集体，以邓小平同志为核心的党的第二代中央领导集体，以江泽民同志为核心的党的第三代中央领导集体，以胡锦涛同志为总书记的党中央，都高度重视周边外交，提出了一系列重要战略思想和方针政策，开创和发展了我国总体有利的周边环境，为我们继续做好周边外交工作打下了坚实基础。党的十八大以来，党中央在保持外交大政方针延续性和稳定性的基础上，积极运筹外交全局，突出周边在我国发展大局和外交全局中的重要作用，开展了一系列重大外交活动。";
    NSString *content3 = @"使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。";
    NSString *content4 = @"习近平强调，我国周边外交的基本方针，就是坚持与邻为善、以邻为伴，坚持睦邻、安邻、富邻，突出体现亲、诚、惠、容的理念。发展同周边国家睦邻友好关系是我国周边外交的一贯方针。要坚持睦邻友好，守望相助；讲平等、重感情；常见面，多走动；多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。";
    NSString *content5 = @"多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。多做得人心、暖人心的事，使周边国家对我们更友善、更亲近、更认同、更支持，增强亲和力、感召力、影响力。要诚心诚意对待周边国家，争取更多朋友和伙伴。要本着互惠互利的原则同周边国家开展合作，编织更加紧密的共同利益网络，把双方利益融合提升到更高水平，让周边国家得益于我国发展，使我国也从周边国家共同发展中获得裨益和助力。要倡导包容的思想，强调亚太之大容得下大家共同发展，以更加开放的胸襟和更加积极的态度促进地区合作。这些理念，首先我们自己要身体力行，使之成为地区国家遵循和秉持的共同理念和行为准则。准则。";
    
    NSMutableArray *content = [[NSMutableArray alloc] initWithObjects:content1, content2, content3, content4, content5, content1, content2, content3, content4, content5, nil];
    
    NSMutableArray *selected = [[NSMutableArray alloc] initWithObjects:@"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", @"NO", nil];
    
    for(int i = 0; i < title.count; ++i)
    {
        DataItem *item = [[DataItem alloc] init];
        item.title = [title objectAtIndex:i];
        item.content = [content objectAtIndex:i];
        item.date = [date objectAtIndex:i];
        item.isSelected = [selected objectAtIndex:i];
        [self.originDataArray addObject:item];
    }
    */
}

-(void)endLoading{
    NSLog(@"endloading");
    [overlayView dismiss:YES];
}

#pragma Mark - SearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"search bar should begin editing");
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    dataCount = 5;
    NSLog(@"SearchBar text did change");
    if(searchText != nil && searchText.length > 0){
        self.dataArray = [NSMutableArray array];
        for(int i = 0; i < originDataArray.count; ++i){
            DataItem *item = [originDataArray objectAtIndex:i];
            
            if([item.title rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0
               ||[item.content rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0){
                
                [self.dataArray addObject:item];
            }
        }
        [self.noticeTableView setTableViewData:self.dataArray];
        [self.noticeTableView reloadData];
    }else {
        [self.noticeTableView setTableViewData:self.originDataArray];
        [self.noticeTableView reloadData];
    }
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    [self.searchBar resignFirstResponder];
    NSLog(@"SearchButton clicked");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:self.searchBar textDidChange:nil];
    [self.searchBar resignFirstResponder];
    NSLog(@"Search canceled");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
