//
//  OKImportMnemonicController.m
//  OneKey
//
//  Created by zj on 2021/3/30.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKImportMnemonicController.h"
#import "OKMnemonicHintTableView.h"
#import "OKMnemonic.h"

static const CGFloat advanceCellHeight = 44;

@interface OKImportMnemonicController () <UITableViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet OKButtonView *btcAddrTypeView;
@property (weak, nonatomic) IBOutlet UIView *pathView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet UISwitch *advanceSwitch;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet OKLabel *textViewPlaceholder;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pathField;
@property (weak, nonatomic) IBOutlet OKButtonView *importBtn;

@property (weak, nonatomic) IBOutlet OKMnemonicHintTableView *tableView;

@property (nonatomic, strong) OKMnemonic *mnemonicUtilty;

@property (assign, nonatomic) OKBTCAddressType btcType;
@property (weak, nonatomic) IBOutlet UILabel *btcTypeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipHeight;

@end

@implementation OKImportMnemonicController
+ (instancetype)controllerWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Import" bundle:nil] instantiateViewControllerWithIdentifier:@"OKImportMnemonicController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btcType = OKBTCAddressTypeSegwit;
    self.mnemonicUtilty = [[OKMnemonic alloc] init];
    
    self.scrollView.delegate = self;
    OKWeakSelf(self)
    self.btcAddrTypeView.buttonClick = ^{
        [weakself selectBtcAddress];
    };
    
    [self.importBtn setLayerRadius:8];
    self.importBtn.buttonClick = ^{
        [weakself import];
    };
    [self setupUI];
}

- (void)setupUI {
    self.title = @"import mnemonic".localized;

    self.containerViewHeight.constant = advanceCellHeight;
    self.btcAddrTypeView.alpha = 0;
    self.pathView.alpha = 0;
    self.tipHeight.constant = 0;
    self.advanceSwitch.on = NO;
    
    self.textView.delegate = self;
    self.tableView.delegate = self;
    [self.tableView makeRotationWithAngle: -90];
    self.tableView.textView = self.textView;
    self.tableView.hints = [self.mnemonicUtilty hintsWithPrefix:nil];
    self.tableView.frame = CGRectMake(0, self.view.height * 2, self.view.width, 48);
}

- (IBAction)showAdvance:(id)sender {
    
    BOOL isBTC = self.model.walletCoinType == OKWalletCoinTypeBTC;
    [UIView animateWithDuration:0.25 animations:^{
        if (self.advanceSwitch.isOn) {
            self.containerViewHeight.constant = isBTC ? advanceCellHeight * 3 : advanceCellHeight * 2;
            self.btcAddrTypeView.alpha = isBTC ? 1 : 0;
            self.pathView.alpha = 1;
            self.tipHeight.constant = 50;
        } else {
            self.containerViewHeight.constant = advanceCellHeight;
            self.btcAddrTypeView.alpha = 0;
            self.pathView.alpha = 0;
            self.tipHeight.constant = 0;
        }
        [self.view layoutIfNeeded];
    }];

}

- (void)import {
    
}




#pragma mark - BTC 相关
- (void)setBtcType:(OKBTCAddressType)btcType {
    _btcType = btcType;
    self.model.btcAddressType = btcType;
    NSString *typeStr;
    switch (btcType) {
        case OKBTCAddressTypeSegwit: typeStr = @"wallet.btc.segwit"; break;
        case OKBTCAddressTypeNativeSegwit: typeStr = @"wallet.btc.nativeSegwit"; break;
        default: typeStr = @"wallet.btc.normalAddr"; break;
    }
    self.btcTypeLabel.text = typeStr.localized;
}

- (void)selectBtcAddress {
    OKBasicTableViewController *selectBtcAddressVC = [OKBasicTableViewController controllerWithStoryboard];
    selectBtcAddressVC.title = @"wallet.AddrType".localized;
    selectBtcAddressVC.cellHeight = advanceCellHeight;
    selectBtcAddressVC.desc = @"import.btc.addresstype".localized;
    OKBasicTableViewCellModel *m0 = [OKBasicTableViewCellModel modelWith: @"wallet.btc.segwit".localized];
    m0.check = self.btcType == OKBTCAddressTypeSegwit;
    OKBasicTableViewCellModel *m1 = [OKBasicTableViewCellModel modelWith: @"wallet.btc.nativeSegwit".localized];
    m1.check = self.btcType == OKBTCAddressTypeNativeSegwit;
    OKBasicTableViewCellModel *m2 = [OKBasicTableViewCellModel modelWith: @"wallet.btc.normalAddr".localized];
    m2.check = self.btcType == OKBTCAddressTypeNormal;
    selectBtcAddressVC.data = @[m0,m1,m2];
    OKWeakSelf(self)
    selectBtcAddressVC.callback = ^(BOOL cancel, NSInteger index) {
        if (cancel) {
            return;
        }
        [kOKHaptic impactOccurredLight];
        weakself.btcType = index == 0 ? OKBTCAddressTypeSegwit : (index == 1 ? OKBTCAddressTypeNativeSegwit : OKBTCAddressTypeNormal);
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    [weakself.navigationController pushViewController:selectBtcAddressVC animated:YES];
}

#pragma mark - 助记词相关 OKMnemonicHintTableView - UITableViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [kOKHaptic prepare];
    if (textView != self.textView) {
        return;
    }
    self.textViewPlaceholder.hidden = textView.text.length;
    NSString *text = textView.text;
    if ([text hasSuffix:@"  "]) {
        textView.text = [text substringToIndex:text.length - 1];
        return;
    }
    
    NSString *textToCursor = [text substringToIndex:[self cursorPosition]];
    NSArray *texts = [textToCursor componentsSeparatedByString:@" "];
    
    self.tableView.hints = [self.mnemonicUtilty hintsWithPrefix:texts.lastObject];
    [self.tableView reloadData];
    
    if (self.tableView.hints.count) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }
}

- (NSInteger)cursorPosition {
    return [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:self.textView.selectedTextRange.start];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView.hints[indexPath.row] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}].width + 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [kOKHaptic impactOccurredLight];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView != self.tableView) {
        return;
    }
    
    NSString *textToCursor = [self.textView.text substringToIndex:[self cursorPosition]];
    
    NSString *hint = self.tableView.hints[indexPath.row];
    
    NSString *text = [textToCursor componentsSeparatedByString:@" "].lastObject;
    hint = [hint substringFromIndex:text.length];
    hint = [hint stringByAppendingString:@" "];
    NSMutableString *mutStr = [NSMutableString stringWithString:self.textView.text];
    [mutStr insertString:hint atIndex:[self cursorPosition]];
    UITextPosition *cur = [self.textView positionFromPosition:self.textView.beginningOfDocument offset:[self cursorPosition] + hint.length];
    
    self.textView.text = mutStr;
    [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:self.textView.selectedTextRange.start];
    if (cur) {
        self.textView.selectedTextRange = [self.textView textRangeFromPosition:cur toPosition:cur];
    }
    [self textViewDidChange:self.textView];
}

#pragma mark - Override
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    if (scrollView == self.scrollView) {
        if (!self.pathField.isFirstResponder) {
            [self.view endEditing:YES];
        }
    }
}

- (UIColor *)navBarTintColor {
    return UIColor.BG_W02;
}

- (UIScrollView *)scrollViewForNavbar {
    return self.scrollView;
}

@end
