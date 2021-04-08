//
//  OKObserveImportViewController.m
//  OneKey
//
//  Created by xiaoliang on 2020/10/16.
//  Copyright © 2020 OneKey. All rights reserved..
//

#import "OKObserveImportViewController.h"
#import "OKSetWalletNameViewController.h"

@interface OKObserveImportViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet OKLabel *textPlacehoderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet OKButton *importBtn;
- (IBAction)importBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *accountNameBgView;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountNameTextField;
@end

@implementation OKObserveImportViewController
+ (instancetype)observeImportViewController
{
    return [[UIStoryboard storyboardWithName:@"Import" bundle:nil]instantiateViewControllerWithIdentifier:@"OKObserveImportViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = MyLocalizedString(@"Observe the purse import", nil);
    self.textPlacehoderLabel.text = MyLocalizedString(@"Please enter an address or public key, support xPub, or scan Two-dimensional code import", nil);
    [self.importBtn setLayerRadius:8];
    [self textChange];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemScanBtnWithTarget:self selector:@selector(scanBtnClick)];
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
    id result =  [kPyCommandsManager callInterface:kInterfaceverify_legality parameter:@{@"data":self.textView.text,@"flag":@"address"}];
    if (result != nil) {
        self.model.where = OKWhereToSelectTypeWalletList;
        self.model.address = self.textView.text;
        self.model.walletName = self.accountNameTextField.text;
        [self.model create];
    }
}
#pragma mark - 扫描
- (void)scanBtnClick
{
    OKWeakSelf(self)
    OKWalletScanVC *vc = [OKWalletScanVC initViewControllerWithStoryboardName:@"Scan"];
    vc.scanningType = ScanningTypeAddress;
    vc.scanningCompleteBlock = ^(OKWalletScanVC *vc, id result) {
        if (result) {
            NSDictionary *typeDict = [kPyCommandsManager callInterface:kInterfaceparse_pr parameter:@{@"data":result}];
            if (typeDict != nil) {
                NSInteger type = [typeDict[@"type"] integerValue];
                switch (type) {
                    case 1:
                    {
                        NSDictionary *data = typeDict[@"data"];
                        NSString *address = [data safeStringForKey:@"address"];
                        if (address && address.length > 0) {
                            weakself.textView.text = address;
                            weakself.textPlacehoderLabel.hidden = YES;
                            [weakself textChange];
                        }
                    }
                        break;
                    case 2:
                        break;
                    default:
                        [kTools tipMessage:result];
                        break;
                }
            }else{
                [kTools tipMessage:result];
            }
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
    }
    else{
        [self.importBtn status:OKButtonStatusDisabled];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text {
    NSString *result = [textView.text stringByAppendingString:text];
    if (result.length > 100) {
        return NO;
    }
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

@end
