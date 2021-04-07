//
//  OKImportMnemonicController.h
//  OneKey
//
//  Created by zj on 2021/3/30.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKWalletCreateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OKCreateWalletController : BaseViewController
@property (nonatomic, strong) OKWalletCreateModel *model;
+ (instancetype)controllerWithStoryboard;
@end

NS_ASSUME_NONNULL_END
