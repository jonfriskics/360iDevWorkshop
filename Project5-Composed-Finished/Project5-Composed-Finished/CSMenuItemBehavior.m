#import "CSMenuItemBehavior.h"

@implementation CSMenuItemBehavior

- (id)initWithItem:(UIView *)item referenceView:(UIView *)referenceView toPoint:(CGPoint)point
{
    self = [super init];
    if(self) {
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:item snapToPoint:point];
        snapBehavior.damping = 1.8;
        [self addChildBehavior:snapBehavior];
        
        UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
        dynamicItemBehavior.allowsRotation = NO;
        [self addChildBehavior:dynamicItemBehavior];
    }
    return self;
}

@end
