#import <UIKit/UIKit.h>

@interface CSMenuItemBehavior : UIDynamicBehavior

- (instancetype)initWithItem:(UIView *)item referenceView:(UIView *)referenceView toPoint:(CGPoint)point;

@end
