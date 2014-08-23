#import "CSDismissSettingsAnimatorController.h"

@implementation CSDismissSettingsAnimatorController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:[transitionContext containerView]];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]
                                  initWithItems:@[fromVC.view]];
    gravity.gravityDirection = CGVectorMake(0, -12);
    [self.animator addBehavior:gravity];
    
    
    gravity.action = ^{
        if(!CGRectIntersectsRect(fromVC.view.frame, [[transitionContext containerView] frame])) {
            [self.animator removeAllBehaviors];
            [transitionContext completeTransition:YES];
        }
    };
}

@end
