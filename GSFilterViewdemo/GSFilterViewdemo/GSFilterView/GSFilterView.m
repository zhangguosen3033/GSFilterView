//
//  GSFilterView.m
//  GSFilterViewdemo
//
//  Created by ygkj on 16/12/2.
//  Copyright © 2016年 ygkj. All rights reserved.

#import "GSFilterView.h"
#import "GSFilterCell.h"
#import "Masonry.h"
#import "DKFilterModel.h"
@interface GSFilterView()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *pickTableView;
@property (nonatomic,strong) UIPickerView *picker;
@property (nonatomic,strong) NSArray *pickerChoices;
@property (nonatomic,strong) DKFilterModel *selectingModel;
@property (nonatomic,assign) CGFloat defaultPickerViewHeight;

@end

@implementation GSFilterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.defaultPickerViewHeight = 100;

        self.filterModels = @[];
        self.pickerChoices = @[];
     
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, SCREEN_HEIGHT) style:UITableViewStyleGrouped];//不用自定义style，需要设置背景
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        _tableView.tableFooterView = [UIView new];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        self.backgroundColor =[UIColor whiteColor];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(showPickerView:)
                                        name:GS_NOTIFICATION_PICKITEM object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(filterButtonClicked:)
                                         name:GS_NOTIFICATION_BUTTON_CLICKED object:nil];
    }
    
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)layoutSubviews{
    
    [_tableView reloadData];
    
}


- (void)showPickerView:(NSNotification*)notification{
    NSInteger index = [notification.object integerValue];
    DKFilterModel *data = (DKFilterModel *)[self.filterModels objectAtIndex:index];
    self.selectingModel = data;
    self.pickerChoices = data.choices;
    [self hidePickerView:NO];
    
}

- (void)filterButtonClicked:(NSNotification*)notification{
    if (self.delegate && [self.delegate respondsToSelector:
                          @selector(didClickAtModel:)]) {
        return [self.delegate didClickAtModel:notification.object];
    }
}


//MARK: UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _pickTableView) {
        return self.pickerChoices.count;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _pickTableView) {
        return 1;
    }else{
        return self.filterModels.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _pickTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popfilterdatacell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"popfilterdatacell"];
        }
        
        cell.textLabel.text = self.pickerChoices[indexPath.row];
        return cell;
    }else{
        DKFilterModel *model = self.filterModels[indexPath.section];
        CGFloat width  = CGRectGetWidth(self.frame);
        if (!model.cachedView || CGRectGetWidth(model.cachedView.frame) != width) {
            model.cachedView = [model getCustomeViewofWidth:width];
        }
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"filterdatacell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:model.cachedView];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _pickTableView) {
        return 50;
    }else{
        DKFilterModel *model = self.filterModels[indexPath.section];
        CGFloat width  = CGRectGetWidth(self.frame);
        if (!model.cachedView) {
            model.cachedView = [model getCustomeViewofWidth:width];
        }
        
        GSFilterCell *selectView = (GSFilterCell *)model.cachedView;
        if (selectView.maxViewWidth != width) {
            model.cachedView = [model getCustomeViewofWidth:width];
            selectView = (GSFilterCell *)model.cachedView;
        }
        
        return [selectView getEstimatedHeight];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _pickTableView) {
        return 0;
    }else{
        if (self.delegate && [self.delegate respondsToSelector:
                              @selector(getCustomSectionHeaderHeight)]) {
            return [self.delegate getCustomSectionHeaderHeight];
        }else{
            
            return 30;
  
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView == _pickTableView) {
        return 0;
    }else{
        if (self.delegate && [self.delegate respondsToSelector:
                              @selector(getCustomSectionHeaderHeight)]) {
            return [self.delegate getCustomSectionHeaderHeight];
        }else{
            
            return 20;
 
        }
        
    }
 
}

//界面优化 在组的尾试图增加虚线
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
      CGFloat width = CGRectGetWidth(self.frame);
     UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width , 20)];
    foot.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(10, 10, width-20, 1)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    
    [foot addSubview:lineView];
    
    //虚线绘制
//    //layer
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    
//    [shapeLayer setFillColor:[[UIColor lightGrayColor] CGColor]];
//
//    //设置虚线的颜色 - 颜色请必须设置
//    [shapeLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
//    
//    //设置虚线的高度
//    [shapeLayer setLineWidth:1.0f];
//    
//    //设置类型
//    [shapeLayer setLineJoin:kCALineJoinRound];
//    
//    /*
//     2.f=每条虚线的长度
//     2.f=每两条线的之间的间距
//     */
//    [shapeLayer setLineDashPattern:
//     [NSArray arrayWithObjects:[NSNumber numberWithInt:2.f],
//      [NSNumber numberWithInt:2.f],nil]];
//    
//    // Setup the path
//    CGMutablePathRef path1 = CGPathCreateMutable();
//    
//    /*
//     代表初始坐标的x，y
//     y:要和下面的y一样。
//     */
//    CGPathMoveToPoint(path1, NULL,10, 10);
//    
//    /*
//     代表坐标的x，y
//     要与上面的y大小一样，才能使平行的线，不然会画出斜线
//     */
//    CGPathAddLineToPoint(path1, NULL, width-20,10);
//    
//    //赋值给shapeLayer
//    [shapeLayer setPath:path1];
//    
//    //清除
//    CGPathRelease(path1);
//    
//    //可以把self改成任何你想要的UIView.
//    [[foot layer] addSublayer:shapeLayer];
    
    return foot;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _pickTableView) {
        return [UIView new];
    }else{
        DKFilterModel *model = self.filterModels[section];
        
        if (self.delegate && [self.delegate respondsToSelector:
                              @selector(getCustomSectionHeader)]) {
            DKFilterSectionHeaderView *header = [self.delegate getCustomSectionHeader];
            [header setSectionHeaderTitle:model.title];
            return header;
        }
        
        CGFloat width = CGRectGetWidth(self.frame);
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        bg.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, width, 21)];
        titleLabel.textColor = GS_DEFAULT_TITLE_COLOR;
        titleLabel.text = model.title;
        
        [bg addSubview:titleLabel];
        
        
        return bg;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _pickTableView) {
        if(self.selectingModel){
            GSFilterCell *view = (GSFilterCell *)self.selectingModel.cachedView;
            [view setSelectedChoice:[self.pickerChoices objectAtIndex:indexPath.row]];
        }
        [self hidePickerView:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        
        CGFloat sectionHeaderHeight = 30;
        if (self.delegate && [self.delegate respondsToSelector:
                              @selector(getCustomSectionHeaderHeight)]) {
             sectionHeaderHeight = [self.delegate getCustomSectionHeaderHeight];
        }

        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=-20) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);

        }
    }
}

- (UITableView *)pickTableView{
    if (!_pickTableView) {
        _pickTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _pickTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _pickTableView.dataSource = self;
        _pickTableView.delegate = self;
        _pickTableView.tableFooterView = [UIView new];
        _pickTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_pickTableView];
    }
    return _pickTableView;
}

- (void)hidePickerView:(BOOL)hide{
    if (!hide) {
        [self.pickTableView reloadData];
    }
    
    if (CGRectEqualToRect(self.pickTableView.frame, CGRectZero)) {
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        self.pickTableView.frame = CGRectMake(0, height, width, 0);
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat width = CGRectGetWidth(self.frame);
        if (hide) {
            CGFloat height = CGRectGetHeight(self.frame);
            self.pickTableView.frame = CGRectMake(0, height, width, 0);
        }else{
            CGFloat height = CGRectGetHeight(self.frame);
            self.pickTableView.frame = CGRectMake(0, 0, width, height);
        }
    }];
}

- (void)setFilterModels:(NSArray *)models{
    [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       DKFilterModel *model = (DKFilterModel *)obj;
        model.tag = idx;
    }];
    _filterModels = models;
    [_pickTableView reloadData];
    [self.tableView reloadData];

}
@end
