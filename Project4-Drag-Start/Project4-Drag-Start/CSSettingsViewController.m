#import "CSSettingsViewController.h"

@interface CSSettingsViewController ()

- (IBAction)closeSettings:(id)sender;

@end

@implementation CSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)closeSettings:(id)sender {
    [self.delegate closeSettings:sender];
}

@end
