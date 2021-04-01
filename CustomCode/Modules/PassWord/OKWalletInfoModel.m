//
//  OKWalletInfoModel.m
//  OneKey
//
//  Created by xiaoliang on 2020/12/7.
//  Copyright © 2020 OneKey. All rights reserved.
//

#import "OKWalletInfoModel.h"

@implementation OKWalletInfoModel
+ (OKWalletType)walletTypeWithStr:(NSString *)type {

    OKWalletType walletType = OKWalletTypeHD;
    #define OK_WALLET_TYPE_CASE(argTypeStr,argType) \
        else if([type ignoreCaseCointain:(argTypeStr)]) {walletType = (argType);}
    if ([type ignoreCaseCointain:@"hd-standard"]) {
        walletType = OKWalletTypeHD;
    }
    OK_WALLET_TYPE_CASE(@"derived-standard",    OKWalletTypeHD)
    OK_WALLET_TYPE_CASE(@"private-standard",    OKWalletTypeIndependent)
    OK_WALLET_TYPE_CASE(@"watch-standard",      OKWalletTypeObserve)
    OK_WALLET_TYPE_CASE(@"hw-derived-",         OKWalletTypeHardware)
    OK_WALLET_TYPE_CASE(@"hd-hw-",              OKWalletTypeHardware)
    OK_WALLET_TYPE_CASE(@"hw-",                 OKWalletTypeMultipleSignature)
    OK_WALLET_TYPE_CASE(@"standard",            OKWalletTypeIndependent)
    return walletType;
}

- (void)setType:(NSString *)type {
    if (type == _type || [type isEqualToString:_type]) {
        return;
    }
    _type = type;
    if ([type hasPrefix:@"eth"] ||
        [type hasPrefix:@"bsc"] ||
        [type hasPrefix:@"heco"]
        ) {
        self.chainType = OKWalletChainTypeETHLike;
    } else {
        self.chainType = OKWalletChainTypeBTC;
    }
    self.walletType = [OKWalletInfoModel walletTypeWithStr:type];
}

- (NSString *)walletTypeDesc {
    switch (self.walletType) {
        case OKWalletTypeHD:        return @"HD".localized; break;
        case OKWalletTypeHardware:  return @"hardware".localized; break;
        case OKWalletTypeObserve:   return @"Observation".localized; break;
        default: return @""; break;
    }
}


+ (OKWalletCoinType)walletCoinTypeWithStr:(NSString *)coinName {
    coinName = coinName.lowercaseString;

    OKWalletCoinType type = OKWalletCoinTypeUnknown;
    #define OK_WALLET_COIN_TYPE_CASE(coinName__,coinType__) \
        else if([coinName hasPrefix:(coinName__)]) {type = (coinType__);}
    if ([coinName hasPrefix:@"btc"]) {
        type = OKWalletCoinTypeBTC;
    }
    OK_WALLET_COIN_TYPE_CASE(@"eth",    OKWalletCoinTypeETH)
    OK_WALLET_COIN_TYPE_CASE(@"bsc",    OKWalletCoinTypeBSC)
    OK_WALLET_COIN_TYPE_CASE(@"heco",   OKWalletCoinTypeHECO)

    return type;
}

- (OKWalletCoinType)walletCoinType {
    return [OKWalletInfoModel walletCoinTypeWithStr: self.type];
}

@end
