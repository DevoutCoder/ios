//
//  OKActionSheetController.m
//  OneKey
//
//  Created by zj on 2021/3/29.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKActionSheetController.h"

static const CGFloat cellHeight = 56;
static const CGFloat animationDuration = 0.25;
static const CGFloat maskAlpha = 0.4;
static const NSInteger cancelIndex = -1;

@interface OKActionSheetCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation OKActionSheetCell
- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
}
@end

@interface OKActionSheetController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *mask;
@property (weak, nonatomic) IBOutlet UIView *sheet;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet OKButtonView *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheetBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@end

@implementation OKActionSheetController
+ (instancetype)controllerWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:@"OKActionSheetController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tipLabel.text = self.title;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableViewHeight.constant = cellHeight * self.entries.count;
    self.sheetBottom.constant = -self.view.height;

    OKWeakSelf(self)
    self.cancelBtn.buttonClick = ^{
        [weakself cancel];
    };
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
    [self.mask addGestureRecognizer:tap];
    
    self.mask.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.sheetBottom.constant = -self.sheet.height;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:animationDuration animations:^{
        self.mask.alpha = maskAlpha;
        self.sheetBottom.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"OKActionSheetCell";
    OKActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = cell ?: [[OKActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.text = self.entries[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissWithIndex:indexPath.row];
}

- (void)cancel {
    [self dismissWithIndex:cancelIndex];
}

- (void)dismissWithIndex:(NSInteger)index {
    if (self.callback) {
        self.callback(index == cancelIndex, index);
    }
    [UIView animateWithDuration:animationDuration animations:^{
        self.mask.alpha = 0;
        self.sheetBottom.constant = -self.sheet.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
