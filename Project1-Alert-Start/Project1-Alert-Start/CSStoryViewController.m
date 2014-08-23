#import "CSStoryViewController.h"
#import "CSAuthorView.h"

@interface CSStoryViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *storyTitle;
@property (weak, nonatomic) IBOutlet UILabel *storyAuthor;
@property (weak, nonatomic) IBOutlet UILabel *storyDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@property (strong, nonatomic) CSAuthorView *authorView;

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
    self.authorView.authorName.text = [NSString stringWithFormat:@"%@ is great!",self.storyAuthor.text];
    
    [self.authorView.dismissAuthorView addTarget:self action:@selector(hideAuthorView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.authorView];
}

- (void)hideAuthorView:(id)sender
{
    [self.authorView removeFromSuperview];
}


#pragma mark Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height;
}

@end
