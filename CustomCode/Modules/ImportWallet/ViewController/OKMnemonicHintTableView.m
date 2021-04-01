//
//  OKMnemonicHintTableView.m
//  OneKey
//
//  Created by zj on 2021/3/31.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKMnemonicHintTableView.h"
@interface OKMnemonicHintCell ()
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@end

@implementation OKMnemonicHintCell
- (void)setHint:(NSString *)hint {
    self.hintLabel.text = hint;
}
@end


@interface OKMnemonicHintTableView () <UITableViewDataSource>
@end

@implementation OKMnemonicHintTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    if (!self.textView.isFirstResponder) {
        return;
    }
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat y = [self.window convertPoint:keyboardRect.origin toView:self.superview].y;
    
    self.y = y - 46; // IQToolbar height
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.y = self.superview.height * 2;
}

#pragma mark - OKMnemonicHintTableView - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OKMnemonicHintCell *cell = [OKMnemonicHintCell ok_dequeueFrom:tableView];
    cell.hint = self.hints[indexPath.row];
    [cell makeRotationWithAngle: 90];
    return cell;
}
@end
