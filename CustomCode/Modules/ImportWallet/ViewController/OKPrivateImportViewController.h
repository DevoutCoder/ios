//
//  OKPrivateImportViewController.h
//  OneKey
//
//  Created by xiaoliang on 2020/10/16.
//  Copyright © 2020 OneKey. All rights reserved..
//

#import "BaseViewController.h"
#import "OKWalletCreateModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OKPrivateImportViewController : BaseViewController
@property (nonatomic, strong) OKWalletCreateModel *model;
+ (instancetype)privateImportViewController;

@end

NS_ASSUME_NONNULL_END
