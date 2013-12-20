//
//  AllNoticeData.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/23/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import "AllNoticeData.h"

@interface AllNoticeData (){
    NSMutableArray *dataArray;
}

@end

@implementation AllNoticeData


-(int)getMessageNum{
    return [dataArray count];
}

-(NSArray*)getMessages{
    return dataArray;
}

-(void)setMessages:(NSMutableArray *)msgArray{
    dataArray = msgArray;
}

@end
