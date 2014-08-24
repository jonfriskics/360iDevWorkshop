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
    CGRect toVCStartFrame = CGRectMake(0, -CGRectGetHeight(fromVCStartFrame), CGRectGetWidth(fromVCStartFrame), CGRectGetHeight(fromVCStartFrame));
    
    toVC.view.frame = toVCStartFrame;
    [[transitionContext containerView] addSubview:toVC.view];
    
    self.animator = [[UIDynamicAnimator alloc]
                     initWithReferenceView:[transitionContext containerView]];
    self.animator.delegate = self;
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[toVC.view]];
    gravity.gravityDirection = CGVectorMake(0, 3);
    [self.animator addBehavior:gravity];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
                                      initWithItems:@[toVC.view]];
    [collision addBoundaryWithIdentifier:@"bottomEdge"
                               fromPoint:CGPointMake(0,
                                                     CGRectGetMaxY(fromVC.view.frame)
                                                     )
                                 toPoint:CGPointMake(CGRectGetMaxX(fromVC.view.frame),
                                                     CGRectGetMaxY(fromVC.view.frame)
                                                     )];
    [self.animator addBehavior:collision];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.transitionContext completeTransition:YES];
}

@end
