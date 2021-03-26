//
//  OKDeviceIdInconsistentViewController.m
//  OneKey
//
//  Created by xiaoliang on 2021/2/7.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKDeviceIdInconsistentViewController.h"

@interface OKDeviceIdInconsistentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iKnowBtn;
- (IBAction)iKnowBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
- (IBAction)closeBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,copy)NSString *bleName;
@end

@implementation OKDeviceIdInconsistentViewController
+ (instancetype)deviceIdInconsistentViewController:(NSString *)bleName
{
    OKDeviceIdInconsistentViewController *vc = [[UIStoryboard storyboardWithName:@"Hardware" bundle:nil]instantiateViewControllerWithIdentifier:@"OKDeviceIdInconsistentViewController"];
    vc.bleName = bleName;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.iKnowBtn setLayerRadius:20];
    [self.contentView setLayerRadius:20];
    
    self.titleLabel.text = MyLocalizedString(@"The operation failure", nil);
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@%@",@"It is possible that the".localized,self.bleName,@"has been reset and changed the mnemonic. Import the original mnemonic into this hardware wallet and try again.".localized];
    [self.iKnowBtn setTitle:MyLocalizedString(@"determine", nil) forState:UIControlStateNormal];
}

- (IBAction)iKnowBtnClick:(UIButton *)sender {
    OKWeakSelf(self)
    [weakself dismissViewControllerAnimated:NO completion:^{
        [weakself.OK_TopViewController.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    OKWeakSelf(self)
    [weakself dismissViewControllerAnimated:NO completion:^{
        [weakself.OK_TopViewController.navigationController popViewControllerAnimated:YES];
    }];
}
@end
