// BrowserViewController.m
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

#import "BrowserViewController.h"

@interface BrowserViewController ()

@property (nonatomic, strong) RKLink *link;
@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIBarButtonItem *upvoteItem;
@property (nonatomic, strong) UIBarButtonItem *downvoteItem;
@property (nonatomic, strong) UIBarButtonItem *saveItem;
@property (nonatomic, strong) UIBarButtonItem *hideItem;

- (UIBarButtonItem *)barButtonItemWithImageNamed:(NSString *)imageName;
- (void)tappedActionButton:(id)sender;

- (void)upvoteLink;
- (void)downvoteLink;
- (void)saveLink;
- (void)hideLink;

@end

@implementation BrowserViewController

- (instancetype)initWithLink:(RKLink *)link
{
    _link = link;
    return [self initWithURL:link.URL];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        self.title = [URL absoluteString];
        _currentURL = URL;
    }
    
    return self;
}

- (void)loadView
{
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    [self loadURL:self.currentURL];
    
    self.view = self.webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSArray *)toolbarItems
{
    if (!self.link) {
        return nil;
    }
    
    self.upvoteItem = [self barButtonItemWithImageNamed:@"upvote"];
    self.downvoteItem = [self barButtonItemWithImageNamed:@"downvote"];
    self.saveItem = [self barButtonItemWithImageNamed:@"save"];
    self.hideItem = [self barButtonItemWithImageNamed:@"hide"];
    
    UIBarButtonItem *spacingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    return @[self.upvoteItem, spacingItem, self.downvoteItem, spacingItem, self.saveItem, spacingItem, self.hideItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self navigationController] setToolbarHidden:YES animated:YES];
}

- (void)loadURL:(NSURL *)URL
{
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [[self webView] loadRequest:request];
}

#pragma mark - Private

- (UIBarButtonItem *)barButtonItemWithImageNamed:(NSString *)imageName
{
    UIImage *upvoteImage = [UIImage imageNamed:imageName];
    return [[UIBarButtonItem alloc] initWithImage:upvoteImage style:UIBarButtonItemStyleBordered target:self action:@selector(tappedActionButton:)];
}

- (void)tappedActionButton:(id)sender
{
    if (![[RKClient sharedClient] isAuthenticated])
    {
        return;
    }
    
    if (sender == self.upvoteItem)
    {
        [self upvoteLink];
    }
    else if (sender == self.downvoteItem)
    {
        [self downvoteLink];
    }
    else if (sender == self.saveItem)
    {
        [self hideLink];
    }
    else if (sender == self.hideItem)
    {
        [self saveLink];
    }
    else
    {
        NSLog(@"Unknown sender: %@", sender);
        return;
    }
}

- (void)upvoteLink
{
    __weak __typeof(self)weakSelf = self;
    [[RKClient sharedClient] upvote:self.link completion:^(NSError *error) {
        if (!error)
        {
            weakSelf.upvoteItem.enabled = NO;
            weakSelf.downvoteItem.enabled = YES;
        }
    }];
}

- (void)downvoteLink
{
    __weak __typeof(self)weakSelf = self;
    [[RKClient sharedClient] downvote:self.link completion:^(NSError *error) {
        if (!error)
        {
            weakSelf.downvoteItem.enabled = NO;
            weakSelf.upvoteItem.enabled = YES;
        }
    }];
}

- (void)saveLink
{
    __weak __typeof(self)weakSelf = self;
    [[RKClient sharedClient] saveLink:self.link completion:^(NSError *error) {
        if (!error)
        {
            weakSelf.saveItem.enabled = NO;
        }
    }];
}

- (void)hideLink
{
    __weak __typeof(self)weakSelf = self;
    [[RKClient sharedClient] hideLink:self.link completion:^(NSError *error) {
        if (!error)
        {
            weakSelf.hideItem.enabled = NO;
        }
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[RKClient sharedClient] handleRedirectURI:request.URL]) {
        [[RKClient sharedClient] retrieveAccessTokenWithCompletion:^(id object, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(browserViewControllerDidAuthenticate:)]) {
                [self.delegate browserViewControllerDidAuthenticate:self];
            }
        }];
        
        return NO;
    }
    
    return YES;
}

@end
