//
//  OKWalletCreateModel.h
//  OneKey
//
//  Created by zj on 2021/4/1.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OKWalletCreateModel : NSObject
@property (nonatomic, assign) OKAddType importType;
@property (nonatomic, assign, readonly) OKWalletCoinType walletCoinType; // base on .coinType
@property (nonatomic, copy) NSString *coinType;


@property (nonatomic, assign) BOOL customPath;
@property (nonatomic, assign) BOOL walletName;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) OKBTCAddressType btcAddressType; // for btc

@end

NS_ASSUME_NONNULL_END
