//
//  OKBasicTableViewController.m
//  OneKey
//
//  Created by zj on 2021/3/30.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKBasicTableViewController.h"
static const CGFloat cellHeightDefault = 56;
static const NSInteger cancelIndex = -1;

@implementation OKBasicTableViewCellModel
@end

@interface OKBasicTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeft;
@end

@implementation OKBasicTableViewCell
- (void)setModel:(OKBasicTableViewCellModel *)model {
    _model = model;
    self.textLbl.text = model.text;
    
    if (model.iconUrlStr.length) {
        self.icon.hidden = NO;
        [self.icon sd_setImageWithURL:model.iconUrlStr.toURL placeholderImage:[UIImage imageNamed:@"icon_ph"]];
        self.labelLeft.constant = 56;
        
    } else {
        self.icon.hidden = YES;
        self.labelLeft.constant = 16;
    }
}
@end

@interface OKBasicTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footer;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;

@end

@implementation OKBasicTableViewController

+ (instancetype)controllerWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:@"OKBasicTableViewController"];
}

- (void)dealloc {
    if (self.callback) {
        self.callback(YES, cancelIndex);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.footerLabel setText:self.desc lineSpacing:5];
    self.footer.hidden = !self.desc.length;
}

- (UIColor *)navBarTintColor {
    return UIColor.BG_W02;
}

- (UIScrollView *)scrollViewForNavbar {
    return self.tableView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight ?: cellHeightDefault;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OKBasicTableViewCell *cell = [OKBasicTableViewCell ok_dequeueFrom:tableView];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.callback) {
        self.callback(NO, indexPath.row);
    }
}

@end
