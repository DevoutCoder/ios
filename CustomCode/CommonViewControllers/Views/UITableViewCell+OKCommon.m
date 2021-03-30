//
//  UITableViewCell+OKCommon.m
//  OneKey
//
//  Created by zj on 2021/3/30.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import "UITableViewCell+OKCommon.h"

@implementation UITableViewCell (OKCommon)

+ (instancetype)ok_dequeueFrom:(UITableView *)tableView {
    Class cellClass = [self class];
    NSString *ID = NSStringFromClass(cellClass);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = cell ?: [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    return cell;
}

@end
