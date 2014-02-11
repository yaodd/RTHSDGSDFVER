//
//  HeroSelectVIew.m
//  HeroSelectView
//
//  Created by 王智锐 on 12/19/13.
//  Copyright (c) 2013 王智锐. All rights reserved.
//

#import "HeroSelectVIew.h"
#import "EvaluateCell.h"

@implementation HeroSelectView

@synthesize tableView = _tableView;
@synthesize selectedLabel = _selectedLabel;
@synthesize arrow = _arrow;
@synthesize dataArray = _dataArray;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setBackgroundColor:[UIColor yellowColor]];
        _selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 196, 35)];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, 196, 105) style:UITableViewStylePlain];
        _selectedLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _selectedLabel.text = @"请选择评教项";
        UIImage *arrowImage = [UIImage imageNamed:@"xiala"];
        
        _arrow = [[UIImageView alloc ]init];
        _arrow.frame = CGRectMake(196, 0, 44, 35);
        [_arrow setImage:arrowImage];
        [_arrow setBackgroundColor:[UIColor colorWithWhite:215.0/255 alpha:1]];
        [_arrow setContentMode:UIViewContentModeCenter];
        _tableView.hidden = YES;
        _tableView.userInteractionEnabled = YES;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_arrow];
        [self addSubview:_selectedLabel];
        [self addSubview:_tableView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:_arrow.frame];
        [button addTarget:self action:@selector(dropDownTableView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        NSLog(@"button%f %f %f %f",button.frame.origin.x,button.frame.origin.y,button.frame.size.width,button.frame.size.height);
        
    }
    return self;
}

-(void)dropDownTableView:(id)sender{
    if(_tableView.hidden == YES){
        _tableView.hidden = NO;
        self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, self.frame.size.height *4);
        [_tableView reloadData];
    }
    else{
        _tableView.hidden = YES;
        self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, self.frame.size.height / 4);
    }
}

-(void)setData:(NSMutableArray *)array{
    NSLog(@"listsetdata");
    _dataArray = array;
    [_tableView reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifiler = [NSString stringWithFormat:@"%d",indexPath.row];
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler ] ;
    if(cell ==nil){
        cell = [[EvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiler];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 196, 1)];
        [view setBackgroundColor:[UIColor colorWithWhite:215.0/255 alpha:1.0]];
        [cell addSubview:view];
    }
    
    cell.label.text = (NSString* )[_dataArray objectAtIndex:indexPath.row];
    cell.label.font = [UIFont fontWithName:@"Heiti SC" size:15];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"choose%d",indexPath.row);
    _selectedLabel.text = (NSString *)[_dataArray objectAtIndex:indexPath.row];
    _tableView.hidden = YES;
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, self.frame.size.height / 4);
    if([_delegate respondsToSelector:@selector(selectSomeItem:)]){
        [_delegate selectSomeItem:indexPath.row];
    }
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
