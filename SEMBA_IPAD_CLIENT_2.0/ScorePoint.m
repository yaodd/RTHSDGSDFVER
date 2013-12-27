//
//  ScorePoint.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/19/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import "ScorePoint.h"
#import "EvaluateCell.h"

@implementation ScorePoint

@synthesize tableView = _tableView;
@synthesize selectedLabel = _selectedLabel;
@synthesize dataArray = _dataArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, 32, 96) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        

        _tableView.hidden = YES;
        _tableView.userInteractionEnabled = YES;
        _selectedLabel.text = @"10";
        _tableView.scrollEnabled =YES;
        
        [self addSubview:_selectedLabel];
        [self addSubview:_tableView];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [self addSubview:button];
        [button addTarget:self action:@selector(dropDownTable:) forControlEvents:UIControlEventTouchUpInside];
        self.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 3.0;
    }
    return self;
}

-(void)dropDownTable:(id)sender{
    if(_tableView.hidden == YES){
        _tableView.hidden = NO;
        self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, self.frame.size.height *4);
        [_tableView reloadData];
    }
    else{
        _tableView.hidden = YES;

        self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, self.frame.size.height / 4);

        [_tableView reloadData];
    }

}

-(void)setData:(NSMutableArray *)array{
    NSLog(@"setdata");
    _dataArray = array;
    [_tableView reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifiler = [NSString stringWithFormat:@"%d",indexPath.row];
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler ] ;
    if(cell == nil){
        cell = [[EvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiler];
    }
    cell.label.text = (NSString* )[_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"choose%d",indexPath.row);
    _selectedLabel.text = (NSString *)[_dataArray objectAtIndex:indexPath.row];
    _tableView.hidden = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
