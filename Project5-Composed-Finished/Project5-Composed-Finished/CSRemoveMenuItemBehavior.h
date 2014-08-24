#import <UIKit/UIKit.h>

@interface CSRemoveMenuItemBehavior : UIDynamicBehavior

- (instancetype)initWithItem:(UIView *)item referenceView:(UIView *)referenceView overlayView:(UIView *)overlayView;

@end
