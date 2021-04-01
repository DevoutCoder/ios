//
//  OKMnemonicHintTableView.h
//  OneKey
//
//  Created by zj on 2021/3/31.
//  Copyright © 2021 Onekey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OKMnemonicHintCell : UITableViewCell
@property (nonatomic, copy)NSString *hint;
@end


@interface OKMnemonicHintTableView : UITableView
@property (weak, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSArray <NSString *>*hints;
@end

NS_ASSUME_NONNULL_END
