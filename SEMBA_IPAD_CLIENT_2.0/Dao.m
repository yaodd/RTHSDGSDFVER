//
//  Dao.m
//  testJson
//
//  Created by 王智锐 on 13-9-13.
//  Copyright (c) 2013年 王智锐. All rights reserved.
//

#import "Dao.h"
#import "SysbsModel.h"

@interface Dao (privatemethod)
-(id)getResultFromNetwork:(NSString*)url keyAndValue:(NSDictionary*)dict;
@end

@implementation Dao

@synthesize reachbility;

//此处为基本ip地址
//NSString *baseUrl = @"http://localhost/EMBAWEB/" ;

//NSString *baseUrl = @"http://222.200.177.14/EMBAWEBDEVELOP/";
//NSString *baseUrl = @"http://115.28.18.130/EMBAWEBDEVELOP/";
NSString *baseUrl = @"http://115.28.18.130/SEMBAWEBDEVELOP/api/";

NSString *Url = @"http://localhost/test.php";
NSString *checkInUrl = @"checkin.php";
NSString *checkInHistory = @"checkinhistory.php";
//登陆接口地址
NSString *loginUrl = @"login.php";
//注册接口地址（废弃）
NSString *registerUrl = @"register.php";
NSString *welcomeUrl = @"getWelcomePage.php";
//获取课程接口地址
NSString *courseUrl = @"getCourse.php";
//更改密码地址
NSString *changePasswdUrl = @"changePasswd.php";
//获取文件地址
NSString *filedirUrl = @"getCourseFile.php";
NSString *afileUrl = @"getCourseFile.php";
NSString *recommendUrl = @"getRecommand.php";
NSString *courseDateUrl = @"getCourseDate.php";
NSString *newestFile = @"getNewestFile.php";
//上传评教接口
NSString *upEvaluationUrl = @"upLoadEvaluation.php";
//获取评教列表接口
NSString * fetchEvaluationUrl = @"fetchEvaluationList.php";
NSString *requestNameUrl = @"requestForName.php";
//获取通知中心信息地址
NSString *getMessage = @"getMyMessage.php";
//选课接口地址
NSString *chooseCourse = @"choosesinglecourse.php";
//获取选课列表地址
NSString *fetchChooseCourseList = @"fetchchoosecourselist.php";
//意见反馈接口
NSString *feedbackUrl = @"upLoadFeedBack.php";

+(id)sharedDao{
    static Dao* sharedDaoer;
    @synchronized(self){
    if(sharedDaoer == nil){
        sharedDaoer = [[Dao alloc] init];
        [sharedDaoer initNetworkStateObserver];
        }
    }
    return sharedDaoer;
}

-(void)initNetworkStateObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //blockLabel.text = @"Block Says Reachable";
            self.reachbility = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reachbility = NO;
            //blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [reach startNotifier];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //有网
        //notificationLabel.text = @"Notification Says Reachable";
        reachbility = YES;
    }
    else
    {
        reachbility = NO;
        //断网
        //notificationLabel.text = @"Notification Says Unreachable";
    }
}


/**
 * @name request
 * @pam1 urlString：the url of the query's destination
 * @pam2 dict:to format the post array of the http .
 * @result return a NSDictionary contains the data what the protocol wo agree to.return nil 代表 联网失败。
 **/
-(NSDictionary *)request:(NSString *)urlString dict:(NSDictionary *)dict{
//    NSLog(@"aaaaa");
    
    NSDictionary *response = [[NSDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //create a request for the http-query.
    //And we set the request type to ignorecache to confirm each time we invoke this function,we
    //acquire the latest data .
//     NSLog(@"bbbbb");
    if(!self.reachbility)return nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0f ];
    //format the post array
//     NSLog(@"ccccc");
    NSMutableData *postData = [[NSMutableData alloc] init];
    int l = [dict count];
    NSArray *arr = [dict allKeys];
        
    for (int i = 0 ; i < l ; ++i) {
        if(i > 0 ){
            NSString *temp = @"&";
            [postData appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
        }
        NSString *key = [arr objectAtIndex:i];
        NSString *param = [dict objectForKey:key];
        NSString *params = [[NSString alloc]initWithFormat:@"%@=%@",key,param];

        [postData appendData:[params dataUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@"%@",params);
    }
    //NSString *param = @"123=abc";
    //[postData appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
     //NSLog(@"ddddd");
    //set http method and body.
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
     // NSLog(@"eeeee");
    //start the connnection and block the thread.
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    // NSLog(@"fffff");
        //create the NSDictionary from the json result.
    if (error) {
        NSLog(@"Something wrong: %@",[error description]);
        return nil;
    }
//    NSLog(@"data %@",received);
//    if (received != NULL) {
        response = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
        //just for Log.
        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str1);

//    }
    
        //NSLog(@"dict %d",[response count]);
    return response;
}

-(NSData *)requestData:(NSString *)urlAsString dict:(NSDictionary *)dict
filename:(NSString*)filename{
    
//    NSLog(@"before %@",urlAsString);
    NSData *receive ;
    [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"after %@",urlAsString);

    NSURL    *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData   *data = nil;
    if(self.reachbility == NO) return nil;
    data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                    error:&error];
//    NSLog(@"Url%@",urlAsString);
    NSLog(@"nsdata%@",data);
    if(error != nil){
        NSLog(@"youerror");
    }
    /* 下载的数据 */
    if (data != nil){
        NSLog(@"下载成功");
        NSLog(@"nsdata%@",data);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        
//        NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename];
        if ([data writeToFile:filename atomically:YES]) {
            NSLog(@"保存成功.");
            CGPDFDocumentRef document;
            
            NSURL *nsurl = [[NSURL alloc]initFileURLWithPath:filename isDirectory:NO];
            
            CFURLRef url = (__bridge CFURLRef)nsurl;
            //    CFURLRef url = CFRetain((__bridge CFTypeRef)(nsurl));
            
            //打开pdf
            document = CGPDFDocumentCreateWithURL(url);
            //	CFRelease(url);
            
            int count = CGPDFDocumentGetNumberOfPages (document);
            NSLog(@"path%@",filename);
            //若其count为0则肯定是打开错误。
            if (count == 0) {
                NSFileManager* fileManager=[NSFileManager defaultManager];
                BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filename];
               //删除文件
                BOOL blDele= [fileManager removeItemAtPath:filename error:nil];
                if(blDele){
                    NSLog(@"delete");
                }else{
                    NSLog(@"nodelete");
                }
                
            }
            
        }
        else
        {
            NSLog(@"保存失败.");
        }
    } else {
        NSLog(@"%@",@"下载失败");
        NSLog(@"%@", error);
    }
    
    return data;
}


-(int)requestForCheckIn:(NSString*)uid{
    int ret = 0;
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",baseUrl,checkInUrl];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:uid forKey:@"uid"];
    
    NSDictionary *rs = [self request:url dict:dict];
    if(rs == nil){
        ret = 0;
        return ret;
    }
    NSNumber *number = [rs objectForKey:@"isSuccess"];
    ret = [number intValue];
    if([number integerValue] == 1){
        
    }else if([number integerValue] == 0){
        //network fail
        
    }else{
        
    }
    
    return ret;
}
-(int)requestForCheckInHistory:(NSString*)uid{
    int ret = 0;
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",baseUrl,checkInHistory];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:uid forKey:@"uid"];
    
    NSDictionary *rs = [self request:url dict:dict];
    NSNumber *number = [rs objectForKey:@"isSuccess"];
    ret = [number intValue];
    if(rs  == nil){
        ret = 0;
    }

    if([number integerValue] == 1){
        //成功放数据
        
    }else if([number integerValue] == 0){
        //network fail
        
    }else{
        
    }
    return ret;
}


-(int)requestForLogin:(NSString*)cellnum password:(NSString*)passwd{

    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",baseUrl,loginUrl];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:cellnum forKey:@"cellnum"];
    [dict setObject:passwd forKey:@"passwd"];
    NSDictionary *rs = [self request:url dict:dict];
    
    NSNumber *NSnum = [rs objectForKey:@"isSuccess"];
    int ret = [NSnum intValue];
    if(rs  == nil){
        ret = 0;
    }
    if(ret == 1){
        SysbsModel *model = [SysbsModel getSysbsModel];
        User *user = [[User alloc]init];
        NSNumber *num = [rs objectForKey:@"uid"];
        int uid = [num intValue];
        user.uid = uid;
        //NSLog(@"uid%d",uid);
        NSString *name = [rs objectForKey:@"username"];
        NSNumber *class_num = [rs objectForKey:@"class_num"];
        user.class_num = [class_num integerValue];
        user.username = name;
        model.user = user;
        
    }
    //ret.isSuccess = [NSnum integerValue];
    return ret;
}
/*
-(WelcomePageResult *)requestForWelcomeImage{
    WelcomePageResult *rs = [[WelcomePageResult alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * timeString = [defaults objectForKey:@"welcomepage"];
    if(timeString == nil){
        timeString = @"0000-00-00 00:00:00";
//        NSLog(@"kongde");
    }else{
        
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,welcomeUrl];
    //NSLog(@"welcome%@",urlString);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:timeString forKey:@"time"];
    NSDictionary *ret = [self request:urlString dict:dict];
    
//    NSLog(@"%d",[ret count]);
    //int dictNum = [ret count];
    NSNumber *isSuccess = [ret objectForKey:@"isSuccess"];
//    NSLog(@"%@",isSuccess);
    int returnNum = [isSuccess intValue];
    if(returnNum > 0){
        NSArray *arr = [ret allKeys];
        int l = [arr count];
//        NSLog(@"num%d",l);
        for(int i = 0 ; i < l ;++i){
            NSObject *object = [ret objectForKey:[arr objectAtIndex:i]];
//            NSLog(@"object%@",object);
        }
        NSString *fileUrl = [ret objectForKey:@"url"];
        NSString *string = [ret objectForKey:@"time"];
        [defaults setObject:string forKey:@"welcomepage"];
        //NSLog(@"%@",tt);
        [defaults synchronize];
        NSString * temp = [defaults objectForKey:@"welcomepage"];
//        NSLog(@"%@",temp);
        //NSLog(@"abcdefg");
        //下载图片
      //  [self requestData:fileUrl dict:nil];
    }
    return rs;
}
*/


-(int)requestForMyCourse:(int)uid{
    int ret = 0;
    NSString * urlString  = [NSString stringWithFormat:@"%@%@",baseUrl,courseUrl];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSNumber *uidNum = [NSNumber numberWithInt:uid];
    [dict setObject:uidNum forKey:@"uid"];
    NSDictionary *rs = [self request:urlString dict:dict];
    if(rs == nil)return 0;//network fail;
    ret = [(NSNumber *)[rs objectForKey:@"isSuccess" ] intValue];
    if(ret == 1){
        
        NSMutableArray *allMyCourse = [[NSMutableArray alloc] init];
        NSArray *arr = [rs objectForKey:@"data"];
        NSLog(@"%@",arr);
        NSLog(@"mycourse");
        int l = [arr count];
        for (int i = 0; i < l; ++i) {
            
            NSDictionary *onedict = [arr objectAtIndex:i];
            Course *one = [[Course alloc]  init];
            one.cid = [(NSNumber*)[onedict objectForKey:@"courseid"] integerValue];
            one.courseName = [onedict objectForKey:@"coursename"];
            one.courseDescription = [onedict objectForKey:@"coursedescrition"];
            one.location = [onedict objectForKey:@"location"];
            //NSLog(@"FUCK%@",one.location);
            one.startTime = [onedict objectForKey:@"startdate"];
            one.endTime = [onedict objectForKey:@"enddate"];
            NSLog(@"teacher_len");

            NSMutableArray *teachArr = [[NSMutableArray alloc]init];
            int teacher_len = [(NSNumber*)[onedict objectForKey:@"teacher_len"] intValue];
            if (teacher_len > 0){
                NSLog(@"%d",teacher_len);
                NSMutableArray *teachDataArr = [onedict objectForKey:@"teacher"];
                for (int j = 0 ; j < teacher_len; ++j) {
                    NSDictionary *oneteacher = [teachDataArr objectAtIndex:j];
                    User *ateacher = [[User alloc]init];
                    ateacher.uid = [(NSNumber*) [oneteacher objectForKey:@"uid"]intValue];
                    ateacher.type = [(NSNumber*)[oneteacher objectForKey:@"type"]intValue];
                    ateacher.username = [oneteacher objectForKey:@"username"];
                    ateacher.headImgUrl = [oneteacher objectForKey:@"headimg"];
                    ateacher.selfSummary = [oneteacher objectForKey:@"selfsummary"];
                    [teachArr addObject:ateacher];
                }
                one.coverUrl = ((User*)[teachArr objectAtIndex:0]).headImgUrl;
                NSLog(@"coverurl %@",one.coverUrl);
            }else{
                one.coverUrl = @"";
            }
            
            one.teacher = teachArr;
            [allMyCourse addObject:one];
        }
        MyCourse *myCourse = [[MyCourse alloc] init];
        [myCourse setCourses:allMyCourse];
        SysbsModel *model = [SysbsModel getSysbsModel];
        [model setCourses:myCourse];
        //NSLog(@"daoallmycourse %d",[allMyCourse count]);
        //获取课程数据
    }else{
        
    }
    return ret;
    //return rs;
}


-(int)requestForChangePasswd:(NSString *)oldPasswd NewPassword:(NSString *)newPassword{
    int ret = 0;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,changePasswdUrl];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:oldPasswd forKey:@"passwd"];
    [dict setObject:newPassword forKey:@"newpasswd"];
    
    int uid = [SysbsModel getSysbsModel].user.uid;
    NSNumber *num = [NSNumber numberWithInt:uid];
    [dict setObject:num forKey:@"uid"];
    NSDictionary * rs = [self request:urlString dict:dict];
    NSNumber *nsNum = [rs objectForKey:@"isSuccess"];
    ret = [nsNum intValue];
    if(rs == nil)ret = 0;//network fail
    return ret;
}
/*
-(id)requestForAFile:(int)fid UserId:(int)uid{
    id ret;
    return ret;
}
*/
-(int)requestForFileList:(int)cid{
    int ret;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:cid] forKey:@"cid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,filedirUrl];
    NSDictionary * rs = [self request:urlString dict:dict];
    ret = [(NSNumber*) [rs objectForKey:@"isSuccess"] integerValue];
    if(rs == nil)return 0;//network fail;
    if(ret == 1){
        SysbsModel *model = [SysbsModel getSysbsModel];
        MyCourse *myCourse = model.myCourse;
        Course *nowCourse = [myCourse findCourse:cid];
        NSArray *arr = [rs objectForKey:@"data"];
        int l = [arr  count];
        for (int i = 0 ; i < l; ++i) {
            NSDictionary *onedict = [arr objectAtIndex:i];
            File *one = [[File alloc] init];
            one.fileName = [onedict objectForKey:@"filename"];
            one.filePath = [onedict objectForKey:@"filepath"];
            one.date = [onedict objectForKey:@"date"];
            //NSLog(@"filepath%@",one.filePath);
//            NSLog(@"now%d",now.cid);
            one.course = nowCourse;
            //这里可能还需要重构。
            [nowCourse.fileArr addObject:one];
//            NSLog(@"arrNum%d",[now.fileArr count]);
        }
    }else{
        
    }
    return ret;
}

-(int)requestForNotices:(int)uid{
    int ret = -1;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,getMessage];
    NSDictionary * rs = [self request:urlString dict:dict];
    ret = [(NSNumber*) [rs objectForKey:@"isSuccess"] integerValue];
    if (ret == 1){
        
        SysbsModel *model = [SysbsModel getSysbsModel];
        AllNoticeData *allNotice = model.myMessage;
        if(allNotice == Nil ){
            allNotice = [[AllNoticeData alloc]init];
        }
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *arr = [rs objectForKey:@"data"];
        int l = [arr  count];
        for (int i = 0 ; i < l; ++i) {
            NSDictionary *onedict = [arr objectAtIndex:i];
            NoticeData *one = [[NoticeData alloc]init];
            one.messageTitle = [onedict objectForKey:@"title"];
            one.messageContent = [onedict objectForKey:@"content"];
            one.date = [onedict objectForKey:@"date"];
            //            NSLog(@"now%d",now.cid);
            //这里可能还需要重构。
            [dataArray addObject:one];
        }
        [allNotice setMessages:dataArray];
        model.myMessage = allNotice;
    
    }else if( ret == 0 ){
    
    }else if( ret == -1){
    
    }
    return ret;
}

-(int)requestForUpEvaluation:(int)uid eid:(int)eid one:(int)one two:(int)two
                       three:(int)three four:(int)four five:(int)five six:(int)six
                       seven:(int)seven eight:(int)eight nine:(int)nine ten:(int)ten
                 suggestText:(NSString*)text;
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,upEvaluationUrl];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    [dict setObject:[NSNumber numberWithInt:eid] forKey:@"eid"];
    [dict setObject:[NSNumber numberWithInt:one] forKey:@"one"];
    [dict setObject:[NSNumber numberWithInt:two] forKey:@"two"];
    [dict setObject:[NSNumber numberWithInt:three] forKey:@"three"];
    [dict setObject:[NSNumber numberWithInt:four] forKey:@"four"];
    [dict setObject:[NSNumber numberWithInt:five] forKey:@"five"];
    [dict setObject:[NSNumber numberWithInt:six] forKey:@"six"];
    [dict setObject:[NSNumber numberWithInt:seven] forKey:@"seven"];
    [dict setObject:[NSNumber numberWithInt:eight] forKey:@"eight"];
    [dict setObject:[NSNumber numberWithInt:nine] forKey:@"nine"];
    [dict setObject:[NSNumber numberWithInt:ten] forKey:@"ten"];
    [dict setObject:text forKey:@"comment"];
    
    NSDictionary *rs = [self request:urlString dict:dict];
    
    int isSuccess = [(NSNumber *) [rs objectForKey:@"isSuccess"] integerValue];
    if(isSuccess > 0){
        
    }else{
        
    }
    
    return isSuccess;
}

-(int)requestForEvaluationList:(int)uid{
   
    int ret = -1;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,
                           fetchEvaluationUrl ];
    NSDictionary *rs = [self request:urlString dict:dict ];
    ret = [ (NSNumber *)[rs objectForKey:@"isSuccess"] integerValue];
    if ( ret == 1 ){
        
        SysbsModel *model = [SysbsModel getSysbsModel];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        NSArray *dataArr = [rs objectForKey:@"data"];
        int l = [dataArr count];
        for(int i = 0 ; i < l ; ++ i ){
            EvaluationDataModel *singledata = [[EvaluationDataModel alloc]init];
            NSDictionary *onedict = [dataArr objectAtIndex:i];
            singledata.teacherName = (NSString*)[onedict objectForKey:@"username"];
            singledata.courseName = (NSString*)[onedict objectForKey:@"coursename"];
            singledata.tid = [ (NSNumber *)[onedict objectForKey:@"tid"] integerValue];
            singledata.cid = [ (NSNumber *) [onedict objectForKey:@"cid"] integerValue];
            singledata.eid = [ (NSNumber *)[onedict objectForKey:@"id"] integerValue];
            
            [arr addObject:singledata];
        }
        model.EvaluationList = arr;
        
    
    }else if( ret == 0 ){
    
    }else if( ret == -1){
    
    }
    return ret;
}

-(int)requestForChooseCourse:(int)cid userid:(int)uid{
    int ret = -1;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    [dict setObject:[NSNumber numberWithInt:cid] forKey:@"courseid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,
                           chooseCourse ];
    NSDictionary *rs = [self request:urlString dict:dict ];
    ret = [ (NSNumber *)[rs objectForKey:@"isSuccess"] integerValue];
    
    return ret;
}

-(int)requestForChooseCourseList:(int)class_num userid:(int)uid{
    int ret = -1 ;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSNumber numberWithInt:class_num] forKey:@"class_num"];
    [dict setObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,
                           fetchChooseCourseList ];
    NSDictionary *rs = [self request:urlString dict:dict ];
    ret = [ (NSNumber *)[rs objectForKey:@"isSuccess"] integerValue];
    if(ret == 1){
        SysbsModel *model = [SysbsModel getSysbsModel];
        ChooseCourseListResult *chooseResult = [[ChooseCourseListResult alloc]init];
        NSMutableArray *resultArr = [[NSMutableArray alloc]init];
        NSArray *data = [rs objectForKey:@"data"];
        int len = [data count];
        NSLog(@"choose len%d",len);
        for (int i = 0 ; i < len; ++i) {
            SingleChooseCourseDataObject *dataobj = [[SingleChooseCourseDataObject alloc]init];
            NSDictionary *single_data = [data objectAtIndex:i];
            NSDictionary *course_data = [single_data objectForKey:@"course"];
            int now_num = [(NSNumber*) [single_data objectForKey:@"now_num"] integerValue];
            int max_num = [(NSNumber*) [single_data objectForKey:@"max_num"] integerValue];
            dataobj.nowChooseNum = now_num;
            dataobj.maxChooseNum = max_num;
            
            NSString *coursename = [course_data objectForKey:@"coursename"];
            dataobj.courseTitle = coursename;
            dataobj.contentShortView = [course_data objectForKey:@"coursedescription"];
            dataobj.cid = [(NSNumber *) [course_data objectForKey:@"courseid"]integerValue];
            dataobj.startdate = [course_data objectForKey:@"startdate"];
            dataobj.enddate = [course_data objectForKey:@"enddate"];
            
            int temp = [(NSNumber*)[single_data objectForKey:@"have_selected"] integerValue];
            if(temp == 1){
                dataobj.haveselected = YES;
            }else{
                dataobj.haveselected = NO;
            }
            
            NSMutableArray *tArr = [[NSMutableArray alloc]init];
            int tLen = [(NSNumber *)[single_data objectForKey:@"teacher_len"] intValue];
            NSLog(@"tLen%d",tLen);
            if(tLen>0){
                NSArray *tdArr = [single_data objectForKey:@"teacher"];
            //int tLen = [tdArr count];
                for (int i = 0 ; i < tLen; ++i) {
                    NSDictionary *singleTeacher = [tdArr objectAtIndex:i];
                    NSString *name = [singleTeacher objectForKey:@"username"];
                    [tArr addObject:name];
                    if(i == 0){
                        dataobj.coverUrl = [singleTeacher objectForKey:@"headimg"];
                    }
                }
                dataobj.teacherArr = tArr;
            }else{
                dataobj.teacherArr = [[NSMutableArray alloc]init];
            }
            [resultArr addObject:dataobj];
        }
        chooseResult.arr = resultArr;
        model.chooseCourseListResult = chooseResult;
    }
    
    return ret;
}

-(int)requestForFeedBack:(int)uid feedback:(NSString *)text{
    int ret = 0;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    [dict setObject:text forKey:@"feedback"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,
                           feedbackUrl];
    NSDictionary *rs = [self request:urlString dict:dict ];
    ret = [ (NSNumber *)[rs objectForKey:@"isSuccess"] integerValue];
    
    return ret;
}

/*
-(RecommendBookResult*)requestForRecommend:(int)cid{
    //id ret;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,recommendUrl];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:cid] forKey:@"cid"];
    NSDictionary *rs = [self request:urlString dict:dict];
    int isSuccess = [(NSNumber*)[rs objectForKey:@"isSuccess"] integerValue];
    RecommendBookResult * ret = [[RecommendBookResult alloc]init];
    if(isSuccess > 0){
        NSLog(@"heheh");
        NSArray * arr = [rs objectForKey:@"data"];
        ret.isSuccess = 1;
        int l = [arr count];
        MyCourse *myCourse = [MyCourse sharedMyCourse];
        NSMutableArray *arrr = [myCourse courseArr];
        int size = [arrr count];
        Course* now = nil;
        for(int i = 0; i < l ;++i){
            Course *temp = [arrr objectAtIndex:i];
            if(temp.cid == cid){
                now = temp;
                break;
            }
        }
        for (int i = 0 ; i < l; ++i) {
            NSDictionary *onedict = [arr objectAtIndex:i];
            RecommendBook *one = [[RecommendBook alloc] init];
            one.bookName = [onedict objectForKey:@"bookname"];
            one.author = [onedict objectForKey:@"author"];
            one.description = [onedict objectForKey:@"description"];
            one.publisher = [onedict objectForKey:@"publisher"];
            [ret.arr addObject:one];
            [now.recommendBook addObject:one];
            //[ret.arr addObject:[arr objectAtIndex:i]];
        }
    }else{
        ret.isSuccess = 0;
    }
    
    return ret;
}

-(BOOL)requestForCourseDate:(int)cid{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",
                           baseUrl,courseDateUrl];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:cid] forKey:@"cid"];
    NSDictionary * rs = [self request:urlString dict:dict];
    int isSuccess = [(NSNumber*)[rs objectForKey:@"isSuccess" ] integerValue];
    if(isSuccess > 0 ){
        
        NSArray  *arr = [rs objectForKey:@"data"];
        int l = [arr count];
        MyCourse *myCourse = [MyCourse sharedMyCourse];
        NSMutableArray* courseArr = myCourse.courseArr;
        int size = [courseArr count];
        Course* now = nil;
        for(int i = 0 ; i < size ; ++i){
            Course *temp = [courseArr objectAtIndex:i];
            if(cid == temp.cid){
                now = temp;
                break;
            }
        }
        for(int i = 0 ; i < l ; ++i){
            NSDictionary *onedict = [arr objectAtIndex:i];
            NSString *onetime = [onedict objectForKey:@"date"];
            [now.timeArr addObject:onetime];
        }
        return true;
    }
    return false;
}


-(NSMutableArray*) requestForNewestFile:(int)uid{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl
                           ,newestFile];
    MyCourse *myCourse = [MyCourse sharedMyCourse];
    NSMutableArray *courseArr = myCourse.courseArr;
    //int l = [courseArr count];
    //for(int i = 0 ; i < l ; ++i){
      //  Course *oneCourse = [courseArr objectAtIndex:i];
    //}
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    NSDictionary *rs = [self request:urlString dict:dict];
    int isSuccess = [(NSNumber *)[rs objectForKey:@"isSuccess"] integerValue];
    if(isSuccess > 0){
        NSArray *arr = [rs objectForKey:@"data"];
        NSMutableArray *ret = [[NSMutableArray alloc ] init];
        
        int l = [arr count];
        for (int i = 0 ; i < l ; ++i) {
            NSDictionary *onedict  = [arr objectAtIndex:i];
            File *file = [[File alloc] init];
            file.fileName = [onedict objectForKey:@"filename"];
            file.filePath = [onedict objectForKey:@"filepath"];
            file.date = [onedict objectForKey:@"date"];
            file.cid = [(NSNumber *)[onedict objectForKey:@"cid"] intValue];;
            int cid = [(NSNumber *)[onedict objectForKey:@"cid"] integerValue];
            int size = [courseArr count];
            for(int j = 0 ; j < size ; ++j){
                Course *onecourse = [courseArr objectAtIndex:j];
                if(onecourse.cid == cid){
                    file.course = onecourse;
                    break;
                }
            }
            [ret addObject:file];
        }
        return ret;
    }else{
        return nil;
    }
    //NSMutableArray *filelist = [[NSMutableArray alloc] init];
    //return true;
}




-(NSString*)requestForName:(int)uid{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,requestNameUrl];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:uid] forKey:@"uid"];
    NSDictionary *ret = [self request:urlString dict:dict];
    int isSuccess = [(NSNumber*)[ret objectForKey:@"isSuccess"] integerValue];
    if(isSuccess > 0 ){
        NSDictionary  *retDict = [ret objectForKey:@"data"];
        NSString *name = [retDict objectForKey:@"username"];
        return name;
    }
}


/*
//abandoned
-(id)getResultFromNetwork:(NSString *)urlString keyAndValue:(NSDictionary*)dict{
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request =[[NSMutableURLRequest alloc]
                                   initWithURL:url
                                   cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10 ];
    [request setHTTPMethod:@"POST"];
    NSError *error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:data];
    NSURLConnection* conn = [[NSURLConnection alloc]
                             initWithRequest:request delegate:self];
    NSData *ret;
    [conn start];
    
    return ret;
}
*/



/*
 异步方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    //NSLog(@"%@",[res allHeaderFields]);
    self.receiveData = [NSMutableData data];
    
    
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receiveStr);
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    //NSLog(@"%@",[error localizedDescription]);
}

*/

@end
