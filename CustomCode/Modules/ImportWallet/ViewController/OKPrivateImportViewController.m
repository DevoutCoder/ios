//
//  OKPrivateImportViewController.m
//  OneKey
//
//  Created by xiaoliang on 2020/10/16.
//  Copyright © 2020 OneKey. All rights reserved..
//
static const CGFloat advanceCellHeight = 44;

#import "OKPrivateImportViewController.h"
#import "OKSetWalletNameViewController.h"
#import "OKBTCAddressTypeSelectController.h"

@interface OKPrivateImportViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet OKLabel *textPlacehoderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet OKButton *importBtn;
- (IBAction)importBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *accountNameBgView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountNameTextField;

@property (weak, nonatomic) IBOutlet UISwitch *advanceSwitch;
@property (assign, nonatomic) OKBTCAddressType btcType;
@property (weak, nonatomic) IBOutlet OKButtonView *btcAddrTypeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *btcTypeLabel;
@property (weak, nonatomic) IBOutlet OKLabel *bottomTipsView;
@property (weak, nonatomic) IBOutlet UIView *advancedSettingsBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *importBtnTopConsH;

@end

@implementation OKPrivateImportViewController

+ (instancetype)privateImportViewController
{
    return [[UIStoryboard storyboardWithName:@"Import" bundle:nil]instantiateViewControllerWithIdentifier:@"OKPrivateImportViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = MyLocalizedString(@"The private key import", nil);
    self.textPlacehoderLabel.text = MyLocalizedString(@"Enter the private key or scan the QR code (case sensitive)", nil);
    [self.importBtn setLayerRadius:8];
    [self textChange];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemScanBtnWithTarget:self selector:@selector(scanBtnClick)];
    [self stupUI];
}

- (void)stupUI
{
    self.model = self.model ?: [[OKWalletCreateModel alloc] init];
    self.model.delegate = self;
    self.accountNameTextField.placeholder = self.model.defaultWalletName;
    self.btcType = OKBTCAddressTypeSegwit;
    OKWeakSelf(self)
    self.btcAddrTypeView.buttonClick = ^{
        [weakself selectBtcAddress];
    };
    self.containerViewHeight.constant = advanceCellHeight;
    self.btcAddrTypeView.alpha = 0;
    self.advanceSwitch.on = NO;
    self.bottomTipsView.hidden = YES;
    self.advancedSettingsBgView.hidden = [[self.model.coinType uppercaseString] isEqualToString:COIN_BTC] ? NO:YES;
    self.importBtnTopConsH.constant = self.advancedSettingsBgView.hidden ? -advanceCellHeight : 80;
    [self.view layoutIfNeeded];
}

- (IBAction)showAdvance:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        if (self.advanceSwitch.isOn) {
            self.containerViewHeight.constant = advanceCellHeight * 2;
            self.bottomTipsView.hidden = NO;
            self.btcAddrTypeView.alpha = 1.0;
            self.bottomTipsView.alpha = 1.0;
        } else {
            self.containerViewHeight.constant = advanceCellHeight;
            self.bottomTipsView.hidden = YES;
            self.btcAddrTypeView.alpha = 0;
            self.bottomTipsView.alpha = 0;
        }
        [self.view layoutIfNeeded];
    }];
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

- (IBAction)importBtnClick:(UIButton *)sender {
    id reult =  [kPyCommandsManager callInterface:kInterfaceverify_legality parameter:@{@"data":self.textView.text,@"flag":@"private",@"coin":[self.model.coinType lowercaseString]}];
    if (reult != nil) {
        self.model.where = OKWhereToSelectTypeWalletList;
        self.model.privkeys = self.textView.text;
        self.model.btcAddressType = self.btcType;
        self.model.walletName = self.accountNameTextField.text;
        [self.model create];
    }
}

- (void)getAddressType:(void(^)(OKBTCAddressType btcAddressType))callback {
    if (!callback) { return; }

    NSString *coinType = self.model.coinType.lowercaseString;
    if (![coinType isEqualToString:@"btc"]) {
        callback(OKBTCAddressTypeNotBTC);
        return;
    }

    OKWeakSelf(self)
    OKBTCAddressTypeSelectController *vc = [OKBTCAddressTypeSelectController viewControllerWithStoryboard];
    vc.callback = ^(OKBTCAddressType type) {
        [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
        callback(type);
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 扫描二维码
- (void)scanBtnClick
{
    OKWeakSelf(self)
    OKWalletScanVC *vc = [OKWalletScanVC initViewControllerWithStoryboardName:@"Scan"];
    vc.scanningType = ScanningTypeAddress;
    vc.scanningCompleteBlock = ^(OKWalletScanVC *vc, NSString* result) {
        if (result && result.length > 0) {
            weakself.textView.text = result;
            weakself.textPlacehoderLabel.hidden = YES;
            [weakself textChange];
        }
    };
    [vc authorizePushOn:self];
}


#pragma mark - TextView
- (void)textViewDidChange:(UITextView *)textView
{
    [self textChange];
}

- (void)textChange{
    if (self.textView.text.length > 0) {
        [self.importBtn status:OKButtonStatusEnabled];
    }else{
        [self.importBtn status:OKButtonStatusDisabled];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text {
    NSString *result = [textView.text stringByAppendingString:text];
    if (result.length > 100) {
        return NO;
    }
    if (textView == self.textView) {
        if (text.length == 0) { // 退格
            if (textView.text.length == 1) {
                self.textPlacehoderLabel.hidden = NO;
            }
        } else {
            if (self.textPlacehoderLabel.hidden == NO) {
                self.textPlacehoderLabel.hidden = YES;
            }
        }
    }

    return YES;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.accountNameTextField) {
        NSString *str =   [self.accountNameTextField.text stringByAppendingString:string];
        if (str.length > 15) {
            return NO;
        }else{
            if ([string isEqualToString:@" "]) {
                return NO;
            }
            return YES;
        }
    }else{
        return YES;
    }
}
@end
