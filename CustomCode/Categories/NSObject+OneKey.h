//
//  NSObject+OneKey.h
//  Electron-Cash
//
//  Created by xiaoliang on 2020/10/9.
//  Copyright © 2020 OneKey. All rights reserved..
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (OneKey)
- (nullable UINavigationController *)OK_NavigationController;
- (nullable UITabBarController *)OK_TabBarController;
- (UIViewController*)OK_TopViewController;
@end

NS_ASSUME_NONNULL_END
