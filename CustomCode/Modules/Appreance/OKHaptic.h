//
//  OKHaptic.h
//  testaa
//
//  Created by zj on 2021/3/29.
//

#import <UIKit/UIKit.h>

#define kOKHaptic (OKHaptic.sharedInstance)

typedef NS_ENUM(NSInteger, OKHapticStyle) {
    OKHapticStyleLight,
    OKHapticStyleMedium,
    OKHapticStyleHeavy,
    OKHapticStyleSelection,
    OKHapticStyleSuccess,
    OKHapticStyleWarning,
    OKHapticStyleError
};

NS_ASSUME_NONNULL_BEGIN

@interface OKHaptic : NSObject
+ (nullable OKHaptic *)sharedInstance;
- (void)prepare; // With most recent style.
- (void)prepareWith:(OKHapticStyle)style;

- (void)impactOccurred:(OKHapticStyle)style;
- (void)impactOccurredLight; // Equivalent to impactOccurred:OKHapticStyleLight.
- (void)impactOccurredMedium;
@end

NS_ASSUME_NONNULL_END
