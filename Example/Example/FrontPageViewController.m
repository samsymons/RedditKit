// FrontPageViewController.m
//
// Copyright (c) 2013 Sam Symons (http://samsymons.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "FrontPageViewController.h"

#import "AuthenticationManager.h"
#import "BrowserViewController.h"
#import "LinkTableViewCell.h"

#import <RedditKit/RedditKit.h>

static NSString * const kLinkCellReuseIdentifier = @"kLinkCellReuseIdentifier";

@interface FrontPageViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *links;
@property (nonatomic, strong) RKPagination *currentPagination;

@property (nonatomic, strong) LinkTableViewCell *autoLayoutCell;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;

@property (nonatomic, strong) AuthenticationManager *authenticationManager;
@property (nonatomic, strong) UIBarButtonItem *accountButton;
@property (nonatomic, strong) UIBarButtonItem *actionButton;

@property (nonatomic, getter = isLoadingNewLinks) BOOL loadingNewLinks;

- (UIBarButtonItem *)signInBarButtonItem;
- (UIBarButtonItem *)signOutBarButtonItem;

- (void)updateCell:(LinkTableViewCell *)cell withLink:(RKLink *)link;
- (CGFloat)estimatedHeightForLink:(RKLink *)link;
- (NSArray *)indexPathsForArrayToAppend:(NSArray *)array;

- (void)signOut;

- (void)resetLinks;
- (void)loadNewLinks;

- (void)showSortingOptionsActionSheet;

@end

@implementation FrontPageViewController

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain])
	{
        self.title = NSLocalizedString(@"Front Page", @"Front Page");
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the table view:
    
    Class linkCellClass = [LinkTableViewCell class];
    [[self tableView] registerClass:linkCellClass forCellReuseIdentifier:kLinkCellReuseIdentifier];
    
    self.autoLayoutCell = [[linkCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	self.autoLayoutCell.hidden = YES;
    
	[[self tableView] addSubview:self.autoLayoutCell];
    
    // Set up the toolbar:
    
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSortingOptionsActionSheet)];
    self.toolbarItems = @[space, self.actionButton];
    
    // Set up the navigation, and load some links:
    
    self.accountButton = [self signInBarButtonItem];
    self.navigationItem.leftBarButtonItem = self.accountButton;
    
    [self loadNewLinks];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSArray *)links
{
    if (!_links)
    {
        _links = @[];
    }
    
    return _links;
}

#pragma mark - Private

- (UIBarButtonItem *)signInBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(showSignInAlertView)];
}

- (UIBarButtonItem *)signOutBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)];
}

- (void)showSignInAlertView
{
    __weak __typeof(self)weakSelf = self;
    
    self.authenticationManager = [[AuthenticationManager alloc] init];
    
    [[self authenticationManager] showSignInAlertViewWithCompletion:^{
        weakSelf.accountButton = [self signOutBarButtonItem];
        weakSelf.navigationItem.leftBarButtonItem = weakSelf.accountButton;
        
        [weakSelf resetLinks];
    }];
}

- (void)updateCell:(LinkTableViewCell *)cell withLink:(RKLink *)link
{
    cell.titleLabel.text = link.title;
	cell.karmaLabel.text = [NSString stringWithFormat:@"%li", (long)link.score];
	cell.commentsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)link.totalComments];
	cell.subredditLabel.text = link.subreddit;
}

- (CGFloat)estimatedHeightForLink:(RKLink *)link
{
    NSDictionary *bodyTextAttributes = @{ NSFontAttributeName : self.autoLayoutCell.titleLabel.font };
    
    CGFloat width = self.tableView.frame.size.width - 20;
    CGRect boundingRect = [[link title] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:bodyTextAttributes
                                                     context:NULL];
    
    CGFloat estimate = boundingRect.size.height + 16;
    
    return ceilf(estimate);
}

- (NSArray *)indexPathsForArrayToAppend:(NSArray *)array
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:[array count]];
    NSUInteger currentLinkTotal = self.links.count;
    
    for (int index = 0; index < [array count]; index++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(currentLinkTotal + index) inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    return [indexPaths copy];
}

- (void)signOut
{
    [[RKClient sharedClient] signOut];
    
    self.accountButton = [self signInBarButtonItem];
    self.navigationItem.leftBarButtonItem = self.accountButton;
    
    [self resetLinks];
}

- (void)resetLinks
{
    self.links = @[];
    self.currentPagination = nil;
    
    [[self tableView] reloadData];
    
    [self loadNewLinks];
}

- (void)loadNewLinks
{
    self.loadingNewLinks = YES;
    
    __weak __typeof(self)weakSelf = self;
    [[RKClient sharedClient] frontPageLinksWithPagination:self.currentPagination completion:^(NSArray *collection, RKPagination *pagination, NSError *error) {
        if (!error)
        {
            [[weakSelf tableView] beginUpdates];
            
            NSArray *indexPaths = [weakSelf indexPathsForArrayToAppend:collection];
            [[weakSelf tableView] insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            weakSelf.links = [[weakSelf links] arrayByAddingObjectsFromArray:collection];
            weakSelf.currentPagination = pagination;
            
            [[weakSelf tableView] endUpdates];
            
            weakSelf.loadingNewLinks = NO;
        }
        else
        {
            NSLog(@"Failed to get links, with error: %@", error);
        }
    }];
}

- (void)showSortingOptionsActionSheet
{
    UIActionSheet *sortOptionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sorting"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Cancel"
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:@"Hot", @"New", @"Rising", @"Controversial", @"Top", nil];
    
    [sortOptionsActionSheet showFromBarButtonItem:self.actionButton animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self links] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLinkCellReuseIdentifier forIndexPath:indexPath];
    
	RKLink *link = self.links[indexPath.row];
	[self updateCell:cell withLink:link];
	
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    
    if ([[self cellHeights] objectForKey:key])
    {
        NSNumber *height = self.cellHeights[key];
        return [height floatValue];
    }
    
    RKLink *link = self.links[indexPath.row];
    CGFloat estimatedHeight = [self estimatedHeightForLink:link] + 25;
    
    self.cellHeights[key] = @(estimatedHeight);
    
    return estimatedHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RKLink *link = self.links[indexPath.row];
    LinkTableViewCell *layoutCell = self.autoLayoutCell;
    
    [self updateCell:layoutCell withLink:link];
    
    [[layoutCell contentView] updateConstraintsIfNeeded];
    [[layoutCell contentView] layoutIfNeeded];
    
    CGSize size = [[[self autoLayoutCell] contentView] systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return ceilf(size.height + 1);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKLink *link = self.links[indexPath.row];
    BrowserViewController *browserViewController = [[BrowserViewController alloc] initWithLink:link];
    
    [[self navigationController] pushViewController:browserViewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.contentSize.height == 0 || self.isLoadingNewLinks)
	{
		return;
	}
    
	if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height))
	{
        [self loadNewLinks];
    }
}

@end
