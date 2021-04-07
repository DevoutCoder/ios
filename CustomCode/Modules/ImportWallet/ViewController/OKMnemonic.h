//
//  OKMnemonic.h
//  OneKey
//
//  Created by zj on 2021/3/31.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OKMnemonic : NSObject
@property (strong, nonatomic) NSArray <NSString *>*mnemonic;
- (NSArray <NSString *>*)hintsWithPrefix:(nullable NSString *)prefix;
+ (nullable NSString *)checkMnemnoic:(NSString*)mnc;
@end

NS_ASSUME_NONNULL_END
