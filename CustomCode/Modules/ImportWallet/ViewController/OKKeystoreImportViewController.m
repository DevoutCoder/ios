//
//  OKKeystoreImportViewController.m
//  OneKey
//
//  Created by xiaoliang on 2020/10/16.
//  Copyright © 2020 OneKey. All rights reserved..
//

#import "OKKeystoreImportViewController.h"
#import "OKSetWalletNameViewController.h"

@interface OKKeystoreImportViewController ()

@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet OKLabel *textPlacehoderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet OKButton *importBtn;
- (IBAction)importBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *pwdBgView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
- (IBAction)eyeBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *accountNameBgView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountNameTextField;

@end

@implementation OKKeystoreImportViewController
+ (instancetype)keystoreImportViewController
{
    return [[UIStoryboard storyboardWithName:@"Import" bundle:nil]instantiateViewControllerWithIdentifier:@"OKKeystoreImportViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = MyLocalizedString(@"Keystore import", nil);
    self.textPlacehoderLabel.text = MyLocalizedString(@"Copy and paste the contents of the Keystore file, or scan it Keystore QR code import", nil);
    [self.importBtn setLayerDefaultRadius];
    self.pwdTextField.placeholder = MyLocalizedString(@"Enter the Keystore file password", nil);
    [self textChange];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemScanBtnWithTarget:self selector:@selector(scanBtnClick)];
    [self stupUI];
}
- (void)stupUI
{
    self.model = self.model ?: [[OKWalletCreateModel alloc] init];
    self.model.delegate = self;
    self.accountNameTextField.placeholder = self.model.defaultWalletName;
}


- (UIColor *)navBarTintColor {
    return UIColor.BG_W02;
}

#pragma mark - 导入
- (IBAction)importBtnClick:(UIButton *)sender
{
    if (self.textView.text.length == 0) {
        [kTools tipMessage:MyLocalizedString(@"KeyStore cannot be empty", nil)];
        return;
    }
    if (self.pwdTextField.text.length == 0) {
        [kTools tipMessage:MyLocalizedString(@"The password cannot be empty", nil)];
        return;
    }

    id result = [kPyCommandsManager callInterface:kInterfaceverify_legality parameter:@{@"data":self.textView.text,@"flag":@"keystore",@"password":self.pwdTextField.text,@"coin":[self.model.coinType lowercaseString]}];
    if (result != nil) {
        self.model.where = OKWhereToSelectTypeWalletList;
        self.model.keystores = self.textView.text;
        self.model.keystore_password = self.pwdTextField.text;
        self.model.walletName = self.accountNameTextField.text;
        [self.model create];
    }
}
#pragma mark - 扫描
- (void)scanBtnClick
{
    OKWeakSelf(self)
    OKWalletScanVC *vc = [OKWalletScanVC initViewControllerWithStoryboardName:@"Scan"];
    vc.scanningType = ScanningTypeImportKeyStore;
    vc.scanningCompleteBlock = ^(OKWalletScanVC *vc,NSString* result) {
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
    if (self.textView.text.length > 10) {
        [self.importBtn status:OKButtonStatusEnabled];
    }else{
        [self.importBtn status:OKButtonStatusDisabled];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text {
    if (textView == self.textView) {
        if (text.length == 0) {
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

- (IBAction)eyeBtnClick:(UIButton *)sender {
    NSLog(@"点击了眼睛");
}
@end
