//
//  UITableViewCell+OKCommon.h
//  OneKey
//
//  Created by zj on 2021/3/30.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (OKCommon)
+ (instancetype)ok_dequeueFrom:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
