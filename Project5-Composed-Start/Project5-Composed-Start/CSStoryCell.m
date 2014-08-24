#import "CSStoryCell.h"

@implementation CSStoryCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UILabel *label = self.storyTitle;
    [label sizeToFit];
    
    CGRect frame = self.storyTitle.frame;
    frame.size.height = label.frame.size.height;
    self.storyTitle.frame = frame;
}

@end
