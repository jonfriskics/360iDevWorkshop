#import "CSHideAuthorViewBehavior.h"

@implementation CSHideAuthorViewBehavior

- (id)initWithItem:(UIView *)item referenceView:(UIView *)referenceView
{
    self = [super init];
    if(self) {
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[item]];
        gravityBehavior.gravityDirection = CGVectorMake(0, 7);
        [self addChildBehavior:gravityBehavior];
        
        UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
        dynamicItemBehavior.allowsRotation = YES;
        [dynamicItemBehavior addAngularVelocity:(M_PI / 2)
                                        forItem:item];
        [self addChildBehavior:dynamicItemBehavior];
        
        gravityBehavior.action = ^{
            if(!CGRectIntersectsRect(referenceView.frame, item.frame)) {
                [item removeFromSuperview];
                [self.dynamicAnimator removeAllBehaviors];
            }
        };
    }
    return self;
}

@end
