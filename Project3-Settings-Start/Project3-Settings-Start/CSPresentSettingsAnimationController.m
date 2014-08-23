#import "CSPresentSettingsAnimationController.h"

@implementation CSPresentSettingsAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect fromVCStartFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toVCStartFrame = CGRectMake(0, 0, CGRectGetWidth(fromVCStartFrame), CGRectGetHeight(fromVCStartFrame));
    
    toVC.view.frame = toVCStartFrame;
    [[transitionContext containerView] addSubview:toVC.view];
    
    [self.transitionContext completeTransition:YES];
}

@end
