#import "CSDismissSettingsAnimatorController.h"

@implementation CSDismissSettingsAnimatorController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [transitionContext completeTransition:YES];
}

@end
