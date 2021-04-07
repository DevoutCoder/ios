//
//  OKWalletCreateModel.m
//  OneKey
//
//  Created by zj on 2021/4/1.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "OKWalletCreateModel.h"
#import "OKCreateResultModel.h"
#import "OKCreateResultWalletInfoModel.h"
#import "OKMatchingInCirclesViewController.h"
#import "OKPwdViewController.h"
#import "OKBiologicalViewController.h"
#import "OKHDWalletViewController.h"

@interface OKWalletCreateModel () <OKHwNotiManagerDelegate>
@end

@implementation OKWalletCreateModel

- (OKWalletCoinType)walletCoinType {
    return [OKWalletInfoModel walletCoinTypeWithStr:self.coinType];
}

- (NSString *)key {
    return [NSString stringWithFormat:@"OKWalletCreateModel_%@_count", self.coinType];
}

- (NSString *)defaultWalletName {
    NSInteger count = [[OKStorageManager loadFromUserDefaults:self.key] integerValue];
    return [NSString stringWithFormat:@"%@-%ld", self.coinType.uppercaseString, count + 1];
}

- (void)create {
    if (!self.walletName.length) {
        self.walletName = self.defaultWalletName;
    }

    OKWeakSelf(self)
    if (self.addType == OKAddTypeImportAddresses) {
        [self createByImportAddress];
        return;
    }

    if (self.addType == OKAddTypeCreateHWDerived) {
        [self importWallet:nil isInit:NO];
        return;
    }

    if ([kWalletManager checkIsHavePwd]) {
        if (kWalletManager.isOpenAuthBiological) {
           [[YZAuthID sharedInstance] yz_showAuthIDWithDescribe:MyLocalizedString(@"OenKey request enabled", nil) BlockState:^(YZAuthIDState state, NSError *error) {
               if (state == YZAuthIDStateNotSupport
                   || state == YZAuthIDStatePasswordNotSet || state == YZAuthIDStateTouchIDNotSet) { // 不支持TouchID/FaceID
                   [OKValidationPwdController showValidationPwdPageOn:self.delegate isDis:YES complete:^(NSString * _Nonnull pwd) {
                       [weakself importWallet:pwd isInit:NO];
                   }];
               } else if (state == YZAuthIDStateSuccess) {
                   NSString *pwd = [kOneKeyPwdManager getOneKeyPassWord];
                   [weakself importWallet:pwd isInit:NO];
               }
           }];
       }else{
           [OKValidationPwdController showValidationPwdPageOn:self.delegate isDis:NO complete:^(NSString * _Nonnull pwd) {
                [weakself importWallet:pwd isInit:NO];
            }];
       }
    }else{
        OKPwdViewController *pwdVc = [OKPwdViewController setPwdViewControllerPwdUseType:OKPwdUseTypeInitPassword setPwd:^(NSString * _Nonnull pwd) {
            [weakself importWallet:pwd isInit:YES];
        }];
        BaseNavigationController *baseVc = [[BaseNavigationController alloc]initWithRootViewController:pwdVc];
        [weakself.delegate.OK_TopViewController presentViewController:baseVc animated:YES completion:nil];
    }
}

- (void)createByImportAddress {
    NSDictionary *create =  [kPyCommandsManager callInterface:kInterfaceImport_Address parameter:@{@"name":self.walletName,@"address":self.address,@"coin":self.coinType}];
    OKCreateResultModel *createResultModel = [OKCreateResultModel mj_objectWithKeyValues:create];
    if (createResultModel) {
        [kTools tipMessage:MyLocalizedString(@"Import success", nil)];
        OKCreateResultWalletInfoModel *walletInfoModel = [createResultModel.wallet_info firstObject];
        OKWalletInfoModel *model = [kWalletManager getCurrentWalletAddress:walletInfoModel.name];
        [kWalletManager setCurrentWalletInfo:model];
        if (kUserSettingManager.currentSelectPwdType.length > 0 && kUserSettingManager.currentSelectPwdType !=  nil) {
            [kUserSettingManager setIsLongPwd:[kUserSettingManager.currentSelectPwdType boolValue]];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiRefreshWalletList object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:kNotiRefreshWalletList object:nil]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiWalletCreateComplete object:nil];

        [self.delegate.OK_TopViewController dismissToViewControllerWithClassName:@"OKSetWalletNameViewController" animated:NO complete:^{

        }];
        [self.delegate.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)importWallet:(NSString *)pwd isInit:(BOOL)isInit
{
    OKWeakSelf(self)
    __block NSDictionary* create = nil;

    NSMutableDictionary *params = [@{
        @"name": self.walletName ?: @"",
        @"password": pwd ?: @"",
        @"coin": [self.coinType lowercaseString] ?: @"btc",
        @"purpose": @(self.btcAddressType)
    } mutableCopy];
    switch (weakself.addType) {
        case OKAddTypeCreateHDDerived:
        {
            create = [kPyCommandsManager callInterface:kInterfaceCreate_derived_wallet parameter:params];
            [weakself createComplete:create isInit:isInit pwd:pwd isHw:NO];
        }
            break;
        case OKAddTypeCreateSolo:
        {
            create = [kPyCommandsManager callInterface:kInterfaceCreate_create parameter:params];
            [weakself createComplete:create isInit:isInit pwd:pwd isHw:NO];
        }
            break;
        case OKAddTypeImportPrivkeys:
        {
            [params addEntriesFromDictionary:@{
                @"privkeys":self.privkeys
            }];
            create = [kPyCommandsManager callInterface:kInterfaceImport_Privkeys parameter:params];
            [weakself createComplete:create isInit:isInit pwd:pwd isHw:NO];
        }
            break;
        case OKAddTypeImportSeed:
        {
            [params addEntriesFromDictionary:@{
                @"seed":self.mnemonic
            }];
            create =  [kPyCommandsManager callInterface:kInterfaceImport_Seed parameter:params];
            [weakself createComplete:create isInit:isInit pwd:pwd isHw:NO];
        }
            break;
        case OKAddTypeCreateHWDerived:
        {
            __block NSString *name = self.walletName;
            [OKHwNotiManager sharedInstance].delegate = self;
            [MBProgressHUD showHUDAddedTo:self.delegate.view animated:YES];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *xpub = [kPyCommandsManager callInterface:kInterfacecreate_hw_derived_wallet parameter:@{@"purpose": @(self.btcAddressType),@"coin":[self.coinType lowercaseString]}];
                if (xpub == nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate.OK_TopViewController dismissViewControllerWithCount:1 animated:YES complete:^{
                            for (int i = 0; i < weakself.delegate.navigationController.viewControllers.count; i++) {
                                UIViewController *vc = weakself.delegate.navigationController.viewControllers[i];
                                if ([vc isKindOfClass:[OKMatchingInCirclesViewController class]]) {
                                    [weakself.delegate.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        }];
                    });
                    return;
                }
                NSArray *array = @[@[xpub,kOKBlueManager.currentDeviceID]];
                NSString *xpubs = [array mj_JSONString];
                create = [kPyCommandsManager callInterface:kInterfaceimport_create_hw_wallet parameter:@{@"name":name,@"m":@"1",@"n":@"1",@"xpubs":xpubs,@"hd":@"0",@"coin":[weakself.coinType lowercaseString]}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself createComplete:create isInit:isInit pwd:pwd isHw:YES];
                });
            });
        }
            break;
        case OKAddTypeImportKeystore:
        {
            [params addEntriesFromDictionary:@{
                @"keystores":self.keystores,
                @"keystore_password":self.keystore_password
            }];
            create =  [kPyCommandsManager callInterface:kInterfaceImport_KeyStore parameter:params];
            [weakself createComplete:create isInit:isInit pwd:pwd isHw:NO];
        }
            break;
        default:
            break;
    }
}

- (void)createComplete:(NSDictionary *)create isInit:(BOOL)isInit pwd:(NSString *)pwd isHw:(BOOL)isHw
{
    OKWeakSelf(self)
    [self createComplete];
    if (create != nil) {
        OKCreateResultModel *createResultModel = [OKCreateResultModel mj_objectWithKeyValues:create];
        OKCreateResultWalletInfoModel *walletInfoModel = [createResultModel.wallet_info firstObject];
        OKWalletInfoModel *model = [kWalletManager getCurrentWalletAddress:walletInfoModel.name];
        [kWalletManager setCurrentWalletInfo:model];
        if (kUserSettingManager.currentSelectPwdType.length > 0 && kUserSettingManager.currentSelectPwdType !=  nil) {
            [kUserSettingManager setIsLongPwd:[kUserSettingManager.currentSelectPwdType boolValue]];
        }
        if (weakself.addType == OKAddTypeCreateSolo) {
            [kTools tipMessage:MyLocalizedString(@"Creating successful", nil)];
            if (!kWalletManager.isOpenAuthBiological && isInit) {
                OKBiologicalViewController *biologicalVc = [OKBiologicalViewController biologicalViewController:@"OKWalletViewController" pwd:pwd biologicalViewBlock:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiWalletCreateComplete object:@{@"pwd":pwd,@"backupshow":@"1"}];
                }];
                [self.delegate.OK_TopViewController.navigationController pushViewController:biologicalVc animated:YES];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotiRefreshWalletList object:nil];
                [weakself.delegate.OK_TopViewController dismissToViewControllerWithClassName:@"OKSetWalletNameViewController" animated:NO complete:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotiWalletCreateComplete object:@{@"pwd":pwd,@"backupshow":@"1"}];
                }];
                [weakself.delegate.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            switch (weakself.addType) {
                case OKAddTypeCreateHDDerived:
                {
                    [kTools tipMessage:MyLocalizedString(@"Creating successful", nil)];
                }
                    break;
                case OKAddTypeCreateSolo:
                {
                    [kTools tipMessage:MyLocalizedString(@"Creating successful", nil)];
                }
                    break;
                case OKAddTypeImportPrivkeys:
                {
                    [kTools tipMessage:MyLocalizedString(@"Import success", nil)];
                }
                    break;
                case OKAddTypeImportSeed:
                {
                    [kTools tipMessage:MyLocalizedString(@"Import success", nil)];
                }
                    break;
                case OKAddTypeImportAddresses:
                {
                    [kTools tipMessage:MyLocalizedString(@"Import success", nil)];
                }
                    break;
                case OKAddTypeCreateHWDerived:
                {
                    [MBProgressHUD hideHUDForView:self.delegate.view animated:YES];
                    [kTools tipMessage:MyLocalizedString(@"Creating successful", nil)];
                }
                    break;
                default:
                    break;
            }

            if (!kWalletManager.isOpenAuthBiological && isInit && weakself.addType != OKAddTypeImportAddresses && weakself.addType != OKAddTypeCreateHWDerived) {
                OKBiologicalViewController *biologicalVc = [OKBiologicalViewController biologicalViewController:@"OKWalletViewController" pwd:pwd biologicalViewBlock:^{
                    [weakself completeImport];
                }];
                [self.delegate.OK_TopViewController.navigationController pushViewController:biologicalVc animated:YES];
            }else{
                [weakself completeImport];
            }
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.delegate.view animated:YES];
        });
    }
}

- (void)completeImport
{
    [self createComplete];
    OKWeakSelf(self)
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiWalletCreateComplete object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiRefreshWalletList object:nil];

    if (self.where == OKWhereToSelectTypeHDMag) {
        [weakself.delegate.OK_TopViewController dismissToViewControllerWithClassName:@"OKSetWalletNameViewController" animated:NO complete:^{
            for (int i = 0; i < weakself.delegate.OK_TopViewController.navigationController.viewControllers.count; i++) {
                UIViewController *vc = weakself.delegate.OK_TopViewController.navigationController.viewControllers[i];
                if ([vc isKindOfClass:[OKHDWalletViewController class]]) {
                    [weakself.delegate.OK_TopViewController.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
    }else{
        [weakself.delegate.OK_TopViewController dismissToViewControllerWithClassName:@"OKWalletViewController" animated:NO complete:^{
        }];
    }
}

- (void)createComplete {
    NSInteger count = [[OKStorageManager loadFromUserDefaults:self.key] integerValue];
    [OKStorageManager saveToUserDefaults:@(count + 1) key:self.key];
}

#pragma mark - OKHwNotiManagerDekegate
- (void)hwNotiManagerDekegate:(OKHwNotiManager *)hwNoti type:(OKHWNotiType)type
{
    OKWeakSelf(self)
    if(type == OKHWNotiTypePin_Current){
        dispatch_async(dispatch_get_main_queue(), ^{
            OKPINCodeViewController *pinCodeVc = [OKPINCodeViewController PINCodeViewController:^(NSString * _Nonnull pin) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    id result = [kPyCommandsManager callInterface:kInterfaceset_pin parameter:@{@"pin":pin}];
                    if (result != nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakself.delegate.OK_TopViewController dismissViewControllerWithCount:1 animated:YES complete:^{

                            }];
                        });
                        return;
                    }
                });
            }];
            [weakself.delegate.OK_TopViewController presentViewController:pinCodeVc animated:YES completion:nil];
        });
    }
}
@end
