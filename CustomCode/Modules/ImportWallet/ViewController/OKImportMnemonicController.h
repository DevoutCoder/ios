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

@interface OKImportMnemonicController : BaseViewController
@property (nonatomic, strong) OKWalletCreateModel *model;

//@property (nonatomic, assign) OKAddType importType;
//@property (nonatomic, copy) NSString *coinType;
+ (instancetype)controllerWithStoryboard;
@end

NS_ASSUME_NONNULL_END
