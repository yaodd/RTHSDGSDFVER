//
//  AllNoticeData.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/23/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeData.h"

@interface AllNoticeData : NSObject


-(int)getMessageNum;
-(NSArray *)getMessages;
-(void)setMessages:(NSMutableArray*)msgArray;

@end
