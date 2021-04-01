//
//  OKHaptic.m
//  testaa
//
//  Created by zj on 2021/3/29.
//

#import "OKHaptic.h"

@interface OKHaptic()
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGeneratorLight;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGeneratorMedium;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGeneratorHeavy;
@property (nonatomic, strong) UISelectionFeedbackGenerator *selectionFeedbackGenerator;
@property (nonatomic, strong) UINotificationFeedbackGenerator *notificationFeedbackGenerator;
@property (nonatomic, assign) OKHapticStyle lastStyle;
@end

@implementation OKHaptic

static dispatch_once_t once;
+ (OKHaptic *)sharedInstance {
    static OKHaptic *_sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[OKHaptic alloc] init];
    });
    return _sharedInstance;
}

- (void)impactOccurred:(OKHapticStyle)style {
    self.lastStyle = style;
    UIFeedbackGenerator *generator = [self generatorWithStyle:style];
    
    if([generator isKindOfClass:[UIImpactFeedbackGenerator class]]) {
        [(UIImpactFeedbackGenerator *)generator impactOccurred];
    } else if ([generator isKindOfClass:[UISelectionFeedbackGenerator class]]) {
        [(UISelectionFeedbackGenerator *)generator selectionChanged];
    } else if ([generator isKindOfClass:[UINotificationFeedbackGenerator class]]) {
        
        UINotificationFeedbackType type;
        switch (style) {
            case OKHapticStyleWarning: type = UINotificationFeedbackTypeWarning; break;
            case OKHapticStyleError: type = UINotificationFeedbackTypeError; break;
            default :type = UINotificationFeedbackTypeSuccess; break;
        }
        [(UINotificationFeedbackGenerator *)generator notificationOccurred:type];
    }
    [self prepare];
}

- (void)impactOccurredLight {
    [self impactOccurred:OKHapticStyleLight];
}

- (void)impactOccurredMedium {
    [self impactOccurred:OKHapticStyleMedium];
}

- (void)prepareWith:(OKHapticStyle)style {
    self.lastStyle = style;
    [[self generatorWithStyle:style] prepare];
}

- (void)prepare {
    [[self generatorWithStyle:self.lastStyle] prepare];
}

- (UIFeedbackGenerator *)generatorWithStyle:(OKHapticStyle)style {
    UIFeedbackGenerator *generator;
    switch (style) {
        case OKHapticStyleLight:     generator = self.impactFeedbackGeneratorLight; break;
        case OKHapticStyleMedium:    generator = self.impactFeedbackGeneratorMedium; break;
        case OKHapticStyleHeavy:     generator = self.impactFeedbackGeneratorHeavy; break;
        case OKHapticStyleSelection: generator = self.selectionFeedbackGenerator; break;
        default :generator = self.notificationFeedbackGenerator; break;
    }
    return generator;
}

#pragma mark - Lazy loads
- (UIImpactFeedbackGenerator *)impactFeedbackGeneratorLight {
    if (!_impactFeedbackGeneratorLight) {
        _impactFeedbackGeneratorLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    }
    return _impactFeedbackGeneratorLight;
}

- (UIImpactFeedbackGenerator *)impactFeedbackGeneratorMedium {
    if (!_impactFeedbackGeneratorMedium) {
        _impactFeedbackGeneratorMedium = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    }
    return _impactFeedbackGeneratorMedium;
}

- (UIImpactFeedbackGenerator *)impactFeedbackGeneratorHeavy {
    if (!_impactFeedbackGeneratorHeavy) {
        _impactFeedbackGeneratorHeavy = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    }
    return _impactFeedbackGeneratorHeavy;
}

- (UISelectionFeedbackGenerator *)selectionFeedbackGenerator {
    if (!_selectionFeedbackGenerator) {
        _selectionFeedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
    }
    return _selectionFeedbackGenerator;
}

- (UINotificationFeedbackGenerator *)notificationFeedbackGenerator {
    if (!_notificationFeedbackGenerator) {
        _notificationFeedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
    }
    return _notificationFeedbackGenerator;
}
@end
