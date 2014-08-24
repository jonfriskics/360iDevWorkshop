#import "CSAuthorViewBehavior.h"

@implementation CSAuthorViewBehavior

- (id)initWithItem:(UIView *)item referenceView:(UIView *)referenceView
{
    self = [super init];
    if(self) {
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:item snapToPoint:CGPointMake(CGRectGetMidX(referenceView.frame), 200)];
        snapBehavior.damping = 0.4;
        [self addChildBehavior:snapBehavior];
    }
    return self;
}

@end
