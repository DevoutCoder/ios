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
@property (nonatomic, weak) UIViewController *delegate;
@property (nonatomic, assign) OKAddType addType;
@property (nonatomic, assign, readonly) OKWalletCoinType walletCoinType; // base on .coinType below
@property (nonatomic, copy) NSString *coinType;

@property (nonatomic, copy) NSString *walletName;
@property (nonatomic, assign) OKBTCAddressType btcAddressType; // for btc
@property (nonatomic, assign) BOOL customPath;
@property (nonatomic, copy, nullable) NSString *path;
@property (nonatomic, copy, nullable) NSString *mnemonic;
@property (nonatomic, copy, nullable) NSString *address;
@property (nonatomic, copy, nullable) NSString *privkeys;
@property (nonatomic, copy, nullable) NSString *keystores;
@property (nonatomic, copy, nullable) NSString *keystore_password;
@property (nonatomic, assign) OKWhereToSelectType where;

- (void)create;
- (NSString *)defaultWalletName;
@end

NS_ASSUME_NONNULL_END
