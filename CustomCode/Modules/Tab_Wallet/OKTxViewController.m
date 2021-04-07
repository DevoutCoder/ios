//
//  OKTxViewController.m
//  OneKey
//
//  Created by xiaoliang on 2020/10/15.
//  Copyright © 2020 OneKey. All rights reserved..
//

#import "OKTxViewController.h"
#import "OKTxTableViewCell.h"
#import "OKTxTableViewCellModel.h"
#import "OKTxDetailViewController.h"
#import "OKAssetTableViewCellModel.h"

@interface OKTxViewController ()<UITableViewDelegate,UITableViewDataSource>
+ (instancetype)txViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *txListArray;
@property (nonatomic,assign)NSInteger start_index;

@end

@implementation OKTxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self stupUI];
}

- (void)stupUI
{
    OKWeakSelf(self);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.start_index += 10;
        [weakself loadList];
     }];
     self.tableView.tableFooterView = [UIView new];
     self.tableView.mj_footer.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiSendTxComplete) name:kNotiSendTxComplete object:nil];

    if ([[self.coinType uppercaseString]isEqualToString:COIN_BTC]) {
        [self loadList];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self loadList];
        });
    }
}

- (void)loadList
{
    OKWeakSelf(self)
    NSMutableDictionary *params = [@{@"search_type":self.searchType,
                                     @"coin":[weakself.coinType lowercaseString],
                                     @"start":@(self.start_index),
                                     @"end":@(self.start_index + 10)} mutableCopy];
    if (weakself.assetTableViewCellModel.contract_addr.length > 0) {
        [params addEntriesFromDictionary:@{
            @"contract_address":weakself.assetTableViewCellModel.contract_addr
        }];
    }
    NSMutableArray *mut_Array = [NSMutableArray arrayWithArray:self.txListArray];
    NSArray *resultArray = [kPyCommandsManager callInterface:kInterfaceGet_all_tx_list parameter:params];
    [mut_Array addObjectsFromArray:[OKTxTableViewCellModel mj_objectArrayWithKeyValuesArray:resultArray]];
    self.txListArray = mut_Array.copy;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (resultArray.count < 10) {
            self.tableView.mj_footer.hidden = YES;
            if (self.txListArray.count > 0)
                self.tableView.tableFooterView = [self getFootView];

        }else{
            self.tableView.mj_footer.hidden = NO;
        }
    });
}


+ (instancetype)txViewController
{
    return [[UIStoryboard storyboardWithName:@"Tab_Wallet" bundle:nil] instantiateViewControllerWithIdentifier:@"OKTxViewController"];
}

#pragma  mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.txListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"OKTxTableViewCell";
    OKTxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OKTxTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    OKTxTableViewCellModel *model = self.txListArray[indexPath.row];
    if (self.assetTableViewCellModel.contract_addr.length > 0) {
        model.coinType = [NSString stringWithFormat:@"token_%@",self.coinType];
    }else{
        model.coinType = self.coinType;
    }
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OKTxTableViewCellModel *model = self.txListArray[indexPath.row];
    OKTxDetailViewController *txDetailVc = [OKTxDetailViewController txDetailViewController];
    txDetailVc.model = model;
    txDetailVc.tx_hash = model.tx_hash;
    txDetailVc.txDate = model.date;
    [self.navigationController pushViewController:txDetailVc animated:YES];
}

#pragma mark - notiSendTxComplete
- (void)notiSendTxComplete
{
    [self loadList];
}
- (UIButton*)getFootView {
    
    UIButton*btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63)];
    [btn setTitleColor:HexColor(0x00B812) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitle:@"See more records".localized forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"greenarrow"] forState:UIControlStateNormal];
    btn.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)buttonClick {
    NSString *url = [kWalletManager getBrowseUrlWithCurrentWalletAddress];
    WebViewVC *vc = [WebViewVC loadWebViewControllerWithTitle:nil url:url];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

