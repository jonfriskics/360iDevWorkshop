#import "CSAuthorView.h"

@implementation CSAuthorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.authorName = [[UILabel alloc] init];
        self.authorName.textAlignment = NSTextAlignmentCenter;

        self.dismissAuthorView = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.dismissAuthorView setTitle:@"OK" forState:UIControlStateNormal];

        [self addSubview:self.authorName];
        [self addSubview:self.dismissAuthorView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.authorName.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 50);
    self.dismissAuthorView.frame = CGRectMake(0, CGRectGetMaxY(self.authorName.frame) + 10, CGRectGetWidth(self.frame), 30);
}

@end
