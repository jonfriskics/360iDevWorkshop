#import "CSStoriesTableViewController.h"
#import "CSStoryCell.h"
#import "CSStoryViewController.h"
#import "CSSettingsViewController.h"
#import "CSPresentSettingsAnimationController.h"
#import "CSDismissSettingsAnimatorController.h"

@interface CSStoriesTableViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSURLSession *session;
@property (copy, nonatomic) NSArray *stories;

@end

static const CGFloat kCellPadding = 14;

@implementation CSStoriesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Code School Blog";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CSStoryCell" bundle:nil] forCellReuseIdentifier:@"storyCell"];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *requestTask = [self.session dataTaskWithURL:[NSURL URLWithString:@"http://jonfriskics.com/360iDev/CodeSchoolBlog/stories.json"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *requestError;
        NSArray *stories = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&requestError];
        
        if(stories != nil) {
            self.stories = stories;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"error: %@ %@ %@",requestError.localizedDescription, requestError.localizedDescription, requestError.userInfo);
        }
    }];
    
    [requestTask resume];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsTapped:)];
    self.navigationItem.leftBarButtonItem = settingsButton;
}

#pragma mark - Action methods

- (void)settingsTapped:(id)sender
{
    CSSettingsViewController *settingsVC = [[CSSettingsViewController alloc] init];
    settingsVC.delegate = self;
    settingsVC.modalPresentationStyle = UIModalPresentationCustom;
    settingsVC.transitioningDelegate = self;
    
    [self presentViewController:settingsVC animated:YES completion:^{
    }];
}


#pragma mark - SettingsProtocol method
- (void)closeSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Transition delegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return [[CSPresentSettingsAnimationController alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[CSDismissSettingsAnimatorController alloc] init];
}


#pragma mark - Table view data source

- (CGFloat)calculateLabelHeightForText:(NSString *)text
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 292, 0)];
    tempLabel.numberOfLines = 0;
    tempLabel.text = text;
    [tempLabel sizeToFit];
    
    return CGRectGetHeight(tempLabel.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * story = self.stories[indexPath.row];
    
    return [self calculateLabelHeightForText:story[@"title"]] + kCellPadding * 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    
    NSDictionary *story = self.stories[indexPath.row];
    cell.storyTitle.text = story[@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    CSStoryViewController *storyVC = [[CSStoryViewController alloc] init];
    storyVC.story = self.stories[indexPath.row];
    [self.navigationController pushViewController:storyVC animated:YES];
}

@end
