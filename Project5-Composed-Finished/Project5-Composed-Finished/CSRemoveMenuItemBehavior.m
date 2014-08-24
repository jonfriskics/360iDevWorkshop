#import "CSRemoveMenuItemBehavior.h"

@implementation CSRemoveMenuItemBehavior

- (instancetype)initWithItem:(UIView *)item referenceView:(UIView *)referenceView overlayView:(UIView *)overlayView
{
    self = [super init];
    if(self) {
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[item] mode:UIPushBehaviorModeContinuous];
        pushBehavior.pushDirection = CGVectorMake(-9,0);
        
        [self addChildBehavior:pushBehavior];
        
        __weak CSRemoveMenuItemBehavior *weakSelf = self;
        pushBehavior.action = ^{
            if(!CGRectIntersectsRect(referenceView.frame, item.frame)) {
                [weakSelf.dynamicAnimator removeAllBehaviors];
                [UIView animateWithDuration:0.3 animations:^{
                    overlayView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [overlayView removeFromSuperview];
                }];
            }
        };
    }
    return self;
}

@end
