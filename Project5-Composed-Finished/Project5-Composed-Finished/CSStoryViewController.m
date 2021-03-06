#import "CSStoryViewController.h"
#import "CSAuthorView.h"

#import "CSAuthorViewBehavior.h"
#import "CSHideAuthorViewBehavior.h"
#import "CSMenuItemBehavior.h"
#import "CSRemoveMenuItemBehavior.h"

@interface CSStoryViewController () <UIWebViewDelegate, UIDynamicAnimatorDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *storyTitle;
@property (weak, nonatomic) IBOutlet UILabel *storyAuthor;
@property (weak, nonatomic) IBOutlet UILabel *storyDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@property (strong, nonatomic) CSAuthorView *authorView;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;

@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIButton *mailButton;

@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) UIGravityBehavior *gravityBehaviorWhenPanned;

@property (strong, nonatomic) CSAuthorViewBehavior *authorViewBehavior;
@property (strong, nonatomic) CSAuthorViewBehavior *hideAuthorViewBehavior;
@property (strong, nonatomic) CSMenuItemBehavior *menuItemBehavior;
@property (strong, nonatomic) CSRemoveMenuItemBehavior *removeMenuItemBehavior;

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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    longPress.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:longPress];
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
    
    self.authorViewBehavior = [[CSAuthorViewBehavior alloc] initWithItem:self.authorView referenceView:self.view];
    
    [self.animator addBehavior:self.authorViewBehavior];
}

- (void)hideAuthorView:(id)sender
{
    CSHideAuthorViewBehavior *hideAuthorViewBehavior = [[CSHideAuthorViewBehavior alloc] initWithItem:self.authorView referenceView:self.view];
    
    [self.animator addBehavior:hideAuthorViewBehavior];
}

- (void)showMenu:(id)sender
{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        if([self.overlayView isDescendantOfView:self.view]) {
        } else {
            self.overlayView = [[UIView alloc] init];
            self.overlayView.frame = self.view.frame;
            self.overlayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
            self.overlayView.alpha = 0.0;
            [self.view addSubview:self.overlayView];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.overlayView.alpha = 0.9;
            } completion:^(BOOL finished) {
                self.mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.mailButton setImage:[UIImage imageNamed:@"mail_icon"]
                                 forState:UIControlStateNormal];
                [self.mailButton addTarget:self action:@selector(mailTapped:) forControlEvents:UIControlEventTouchUpInside];
                [self.overlayView addSubview:self.mailButton];
                
                self.mailButton.frame = CGRectMake(-100,80,40,40);
                
                CSMenuItemBehavior *menuItemBehavior = [[CSMenuItemBehavior alloc] initWithItem:self.mailButton referenceView:self.view toPoint:CGPointMake(80, 100)];
                [self.animator addBehavior:menuItemBehavior];
            }];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenu:)];
        [self.overlayView addGestureRecognizer:tapGesture];
    }
}

- (void)removeMenu:(id)sender
{
    [self.animator removeAllBehaviors];
    
    CSRemoveMenuItemBehavior *removeMenuItemBehavior = [[CSRemoveMenuItemBehavior alloc] initWithItem:self.mailButton referenceView:self.view overlayView:self.overlayView];
    
    [self.animator addBehavior:removeMenuItemBehavior];
}

- (void)mailTapped:(id)sender
{
    NSString *subject = self.storyTitle.text;
    NSString *body = self.story[@"body"];
    NSArray *to = [NSArray arrayWithObject:@"nowhere@example.com"];
    
    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    [composeVC setSubject:subject];
    [composeVC setMessageBody:body isHTML:YES];
    [composeVC setToRecipients:to];
    
    [self presentViewController:composeVC animated:YES completion:^{
        [self removeMenu:nil];
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint authorViewTouchPoint = [gesture locationInView:self.authorView];
        
        CGFloat halfTheWidth = CGRectGetWidth(self.authorView.frame) / 2.0;
        CGFloat halfTheHeight = CGRectGetHeight(self.authorView.frame) / 2.0;
        
        UIOffset touchPointOffsetFromCenter = UIOffsetMake(authorViewTouchPoint.x - halfTheWidth, authorViewTouchPoint.y - halfTheHeight);
        
        CGPoint anchorInSuperview = [gesture locationInView:self.view];

        [self.animator removeAllBehaviors];
        self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.authorView
                                                            offsetFromCenter:touchPointOffsetFromCenter
                                                            attachedToAnchor:anchorInSuperview];
        
        [self.animator addBehavior:self.attachmentBehavior];
        
        self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.authorView]];
        self.dynamicItemBehavior.angularResistance = 1.0f;
        [self.animator addBehavior:self.dynamicItemBehavior];
        
        self.gravityBehaviorWhenPanned = [[UIGravityBehavior alloc] initWithItems:@[self.authorView]];
        self.gravityBehaviorWhenPanned.magnitude = 0.7;
        [self.animator addBehavior:self.gravityBehaviorWhenPanned];

    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint newAnchor = [gesture locationInView:self.view];
        self.attachmentBehavior.anchorPoint = newAnchor;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachmentBehavior];
        [self.animator removeBehavior:self.dynamicItemBehavior];
        [self.animator removeBehavior:self.gravityBehaviorWhenPanned];
        self.gravityBehaviorWhenPanned = [[UIGravityBehavior alloc] initWithItems:@[self.authorView]];
        self.gravityBehaviorWhenPanned.gravityDirection = CGVectorMake(0, 7);
        [self.animator addBehavior:self.gravityBehaviorWhenPanned];
        
        __weak CSStoryViewController *weakSelf = self;
        self.gravityBehaviorWhenPanned.action = ^{
            if(!CGRectIntersectsRect(weakSelf.view.frame, weakSelf.authorView.frame)) {
                [weakSelf.authorView removeFromSuperview];
                [weakSelf.animator removeBehavior:weakSelf.gravityBehaviorWhenPanned];
            }
        };
    }
}

#pragma mark Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.animator removeBehavior:self.authorViewBehavior];

    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.authorView addGestureRecognizer:gesture];
}

@end
