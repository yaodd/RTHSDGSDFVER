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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setBackgroundColor:[UIColor yellowColor]];
        _selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 196, 35)];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, 196, 105) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        UIImage *arrowImage = [UIImage imageNamed:@"xiala"];
        _arrow = [[UIImageView alloc ]initWithImage:arrowImage];
        _arrow.frame = CGRectMake(196, 0, 44, 35);
        _tableView.hidden = YES;
        _tableView.userInteractionEnabled = YES;
        
        [self addSubview:_arrow];
        [self addSubview:_selectedLabel];
        [self addSubview:_tableView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:_arrow.frame];
        [button addTarget:self action:@selector(dropDownTableView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}

-(void)dropDownTableView:(id)sender{
    if(_tableView.hidden == YES){
        _tableView.hidden = NO;
        [_tableView reloadData];
    }
    else{
        _tableView.hidden = YES;
    }
}

-(void)setData:(NSMutableArray *)array{
    _dataArray = array;
    [_tableView reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifiler = [NSString stringWithFormat:@"%d",indexPath.row];
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler ] ;
    if(cell ==nil){
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
    return 35;
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
