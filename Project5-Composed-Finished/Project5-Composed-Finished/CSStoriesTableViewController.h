#import <UIKit/UIKit.h>

@protocol SettingsProtocol <NSObject>

- (void)closeSettings:(id)sender;

@end

@interface CSStoriesTableViewController : UITableViewController <SettingsProtocol>

@end
