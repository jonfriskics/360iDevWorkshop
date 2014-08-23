#import "CSStoryViewController.h"
#import "CSAuthorView.h"

@interface CSStoryViewController () <UIWebViewDelegate, UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *storyTitle;
@property (weak, nonatomic) IBOutlet UILabel *storyAuthor;
@property (weak, nonatomic) IBOutlet UILabel *storyDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@property (strong, nonatomic) CSAuthorView *authorView;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UISnapBehavior *snapBehavior;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;

@end

@implementation CSStoryViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = self.story[@"title"];
    }
    return self;
}


#pragma mark View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.scrollView.scrollEnabled = NO;
    
    UIBarButtonItem *authorButton = [[UIBarButtonItem alloc] initWithTitle:@"Author" style:UIBarButtonItemStylePlain target:self action:@selector(showAuthorView:)];
    self.navigationItem.rightBarButtonItem = authorButton;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.storyTitle.text = self.story[@"title"];
    self.storyAuthor.text = self.story[@"author"];
    self.storyDate.text = self.story[@"date"];
    
    NSString *cssShim = @"<style type='text/css'>body { font-family: Avenir, Helvetica, sans-serif; } img { width: 304px; }</style>";
    
    NSString *htmlString = [NSString stringWithFormat:@"%@ %@",cssShim,self.story[@"body"]];
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
}


#pragma mark Action Methods

- (void)showAuthorView:(id)sender
{
    self.authorView = [[CSAuthorView alloc] init];
    self.authorView.frame = CGRectMake(-400, 120, 260, 160);
    self.authorView.authorName.text = [NSString stringWithFormat:@"%@ is great!",self.storyAuthor.text];
    
    [self.authorView.dismissAuthorView addTarget:self action:@selector(hideAuthorView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.authorView];

    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.authorView snapToPoint:CGPointMake(CGRectGetMidX(self.view.frame), 200)];
    self.snapBehavior.damping = 0.4;
    
    [self.animator addBehavior:self.snapBehavior];
}

- (void)hideAuthorView:(id)sender
{
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.authorView]];
    self.gravityBehavior.gravityDirection = CGVectorMake(0, 7);
    [self.animator addBehavior:self.gravityBehavior];
    
    self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.authorView]];
    self.dynamicItemBehavior.allowsRotation = YES;
    [self.dynamicItemBehavior addAngularVelocity:(M_PI / 2)
                                         forItem:self.authorView];
    [self.animator addBehavior:self.dynamicItemBehavior];
    
    __weak CSStoryViewController *weakSelf = self;
    self.gravityBehavior.action = ^{
        if(!CGRectIntersectsRect(weakSelf.view.frame, weakSelf.authorView.frame)) {
            [weakSelf.authorView removeFromSuperview];
            [weakSelf.animator removeBehavior:weakSelf.gravityBehavior];
            [weakSelf.animator removeBehavior:weakSelf.dynamicItemBehavior];
        }
    };
}


#pragma mark Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.animator removeBehavior:self.snapBehavior];
}

@end
