//
//  OKTxDetailSeeMoreView.m
//  OneKey
//
//  Created by bixin on 2021/4/7.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKTxDetailSeeMoreView.h"
#import "OKTxDetailSeeMoreCell.h"
@interface OKTxDetailSeeMoreView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSArray<OKTxDetailSectionModel*> *dateArray;

@end
@implementation OKTxDetailSeeMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:[self getBaseView]];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dateArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dateArray[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OKTxDetailSeeMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seeMoreCell" forIndexPath:indexPath];
    cell.model = self.dateArray[indexPath.section].list[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //未使用 dequeueReusableHeaderFooterViewWithIdentifier 只有两组
    OKTxDetailSectionModel *model = self.dateArray[section];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
    UILabel* label =[[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-16, 58)];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = model.titleName;
    [headView addSubview:label];
    return headView;
}


- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, SCREEN_HEIGHT-236-48) style:0];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.rowHeight = 45;
        _myTableView.sectionHeaderHeight = 58;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = 0;
        _myTableView.contentInset = UIEdgeInsetsMake(0, 0,KDevice_SafeArea_Bottom, 0);
        [_myTableView registerNib:[UINib nibWithNibName:@"OKTxDetailSeeMoreCell" bundle:nil]  forCellReuseIdentifier:@"seeMoreCell"];
        
    }
    return _myTableView;
}

- (NSArray<OKTxDetailSectionModel *> *)dateArray {
    if (!_dateArray) {
        id result = [kPyCommandsManager callInterface:kInterfaceGet_detail_tx_info_by_hash parameter:@{@"tx_hash":self.tx_hash}];
        OKTxDetailSeeMoreModel *model = [OKTxDetailSeeMoreModel mj_objectWithKeyValues:result];
        
        if (model.input_list.count == 1) {
            OKTxInputOutputModel *InputOutputModel = model.input_list.firstObject;
            InputOutputModel.cornerType = cornerAll;
        }else{
            [model.input_list enumerateObjectsUsingBlock:^(OKTxInputOutputModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    obj.cornerType = cornerTop;
                }else if(idx == model.input_list.count - 1){
                    obj.cornerType = cornerBottom;
                }else{
                    obj.cornerType = cornerNone;
                }

            }];
        }
        if (model.output_list.count == 1) {
            OKTxInputOutputModel *InputOutputModel = model.output_list.firstObject;
            InputOutputModel.cornerType = cornerAll;
        }else{
            [model.output_list enumerateObjectsUsingBlock:^(OKTxInputOutputModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    obj.cornerType = cornerTop;
                }else if(idx == model.output_list.count - 1){
                    obj.cornerType = cornerBottom;
                }else{
                    obj.cornerType = cornerNone;
                }

            }];
        }
        OKTxDetailSectionModel *inputModel = [OKTxDetailSectionModel new];
        inputModel.list = model.input_list;
        inputModel.titleName = [NSString stringWithFormat:@"Input(%ld)",model.input_list.count];
        
        OKTxDetailSectionModel *outputModel = [OKTxDetailSectionModel new];
        outputModel.list = model.output_list;
        outputModel.titleName = [NSString stringWithFormat:@"Output(%ld)",model.output_list.count];
        _dateArray = @[inputModel,outputModel];
    }
    return _dateArray;

}


- (UIView*)getBaseView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 236, SCREEN_WIDTH, SCREEN_HEIGHT - 236)];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topview_width = 48;
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake((view.width - topview_width) * 0.5, 16, topview_width, 4)];
    topview.backgroundColor = HexColor(0XE5E5EA);
    [view addSubview:topview];
    [view addSubview:self.myTableView];

   UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(20, 20)];
   CAShapeLayer *layer = [ [CAShapeLayer alloc ] init];
   layer.frame = view.bounds;
   layer.path = cornerRadiusPath.CGPath;
   view.layer.mask = layer;

    return view;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}


@end

