#import "CSAppDelegate.h"
#import "CSStoriesTableViewController.h"

@implementation CSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CSStoriesTableViewController *storiesTableViewController = [[CSStoriesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:storiesTableViewController];
    
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
