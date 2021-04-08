//
//  OKKeystoreImportViewController.h
//  OneKey
//
//  Created by xiaoliang on 2020/10/16.
//  Copyright © 2020 OneKey. All rights reserved..
//

#import "BaseViewController.h"
#import "OKWalletCreateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OKKeystoreImportViewController : BaseViewController
@property (nonatomic, strong) OKWalletCreateModel *model;
+ (instancetype)keystoreImportViewController;
@end

NS_ASSUME_NONNULL_END
