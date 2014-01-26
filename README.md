# RedditKit

RedditKit is a [reddit API](http://www.reddit.com/dev/api) wrapper, written in Objective-C.

## Installation

### CocoaPods

Add this to your Podfile:

	pod 'RedditKit', '~> 1.0'

Then run:
	
	pod install

### Manually

1. Add RedditKit as a git submodule of your project.
2. Install its dependencies with `git submodule update --init --recursive`
3. Drag and drop RedditKit and its dependencies into your project, and you're done!

## Getting Started

RedditKit is structured around the `RDKClient` class. This class manages authentication for a single reddit account and performs HTTP requests on that user's behalf. `RDKClient` can be used as a singleton with its `sharedClient` class method, or as a standalone object.

```obj-c
[[RDKClient sharedClient] signInWithUsername:@"name" password:@"password" completion:^(NSError *error) {
    if (!error)
    {
        NSLog(@"Successfully signed in!");
    }
}];
```

Once you're signed in, `RDKClient` will keep track of any necessary authentication state. You can then call methods which require authentication, such as getting the subreddits you are subscribed to.

```obj-c
[[RDKClient sharedClient] subscribedSubredditsWithCompletion:^(NSArray *subreddits, NSError *error) {
    NSLog(@"Subreddits: %@", subreddits);
}];
```

Retrieving the current top links in a subreddit is simple.

```obj-c
RDKSubreddit *subreddit = [[self subreddits] firstObject];

[[RDKClient sharedClient] linksInSubreddit:subreddit pagination:nil completion:^(NSArray *links, RDKPagination *pagination, NSError *error) {
    NSLog(@"Links: %@", links);
}];
```

You can then upvote a link.

```obj-c
RDKLink *link = [[self links] firstObject];

[[RDKClient sharedClient] upvote:link completion:^(NSError *error) {
    NSLog(@"Upvoted the link!");
}];
```

> RedditKit doesn't have any built-in rate limiting. reddit's API rules require that you make no more than 30 requests per minute and try to avoid requesting the same page more than once every 30 seconds. You can read up on the API rules [on their wiki page](https://github.com/reddit/reddit/wiki/API).

## OAuth

RedditKit's OAuth support is contained in the `RDKOAuthClient` class, a subclass of `RDKClient`.

When [creating an app on reddit](https://ssl.reddit.com/prefs/apps/), you will need to enter a redirection URL in order for reddit to hand you an OAuth access code. Unfortunately, reddit only allows redirection URLs which have HTTP or HTTPS protocols, meaning you cannot use a custom URL scheme, such as `redditkit://`.

You can solve this by displaying reddit's OAuth authorization page in an instance of `UIWebView`, then implementing the `webView:shouldStartLoadWithRequest:navigationType:` delegate method. In there, you can check for a request to your redirect URL, and extract the access code from there.

Here's how to implement OAuth in your app:

1. Create your app on reddit at [https://ssl.reddit.com/prefs/apps/](https://ssl.reddit.com/prefs/apps/).
2. Give your app a redirect URL beginning with `http://` or `https://`, such as `http://myapp.com/oauth`. Its value is arbitrary; you're going to intercept the request made with that URL anyway, so it will never actually be executed.

RedditKit's [example project](Example/) shows how you could use OAuth in your app.

## More Examples

**Get the top comments for a link:**

```obj-c
RDKLink *link = [[self links] firstObject];

RDKPagination *pagination = [RDKPagination paginationWithLimit:100];
pagination.commentSortingMethod = RDKCommentSortingMethodTop;

[[RDKClient sharedClient] commentsForLink:link pagination:pagination completion:^(NSArray *comments, NSError *error) {
	if (comments)
	{
		NSLog(@"Comments: %@", comments);
	}
}];
```

**Fetch a user's account:**

```obj-c
[[RDKClient sharedClient] userWithUsername:@"name" completion:^(RDKUser *account, NSError *error) {
	if (account)
	{
		NSLog(@"%@", account);
	}
}];
```

**Send private messages:**

```obj-c
[[RDKClient sharedClient] sendMessage:@"Hello!" subject:nil recipient:@"samsymons" completion:nil];
```

**Canceling a request:**

Each of RedditKit's methods return a `NSURLSessionDataTask`, which can be used to cancel a request before it has completed.

```obj-c
NSURLSessionDataTask *task = [[RDKClient sharedClient] frontPageLinksWithCompletion:nil];
[task cancel];
```

## Pagination

Methods which are paginated can accept `RDKPagination` objects.

`RDKPagination` lets you change the sorting of returned objects. For example, when fetching the top 25 links in a subreddit, setting the `subredditCategory` property changes whether you get the top 25 links right now or the top links overall.

In addition to letting you change the pagination of your requests, RedditKit also gives you pagination information for any requests made. A request for links in a subreddit has a pagination object as an argument in its completion block.

> The [example project](Example/) implements pagination in a table view controller, loading new links when the user scrolls to the bottom.

## Multiple Accounts

`RDKClient` manages a single reddit account. When supporting multiple accounts, all you need to do is switch from using the `sharedClient` method to using one `RDKClient` instance per account.

For example, this code:

```obj-c
[[RDKClient sharedClient] signInWithUsername:@"username" password:@"password" completion:nil];
[[RDKClient sharedClient] upvote:someLink completion:nil];
```

Becomes this:

```obj-c
RDKClient *client = [[RDKClient alloc] init];

[client signInWithUsername:@"username" password:@"password" completion:nil];
[client upvote:someLink completion:nil];
```

How you manage the various `RDKClient` instances is up to you. Probably with an `NSDictionary`, using reddit usernames as keys.

## Configuration

You can configure various aspects of RedditKit's operation, including its default API endpoint and user agent. Check out the `RDKClient` header file for more.

**You should set your user agent to the name and version of your app, along with your reddit username. That way, if you ever have a buggy version of your app in the wild, the reddit admins will know who to contact.**

If you do not set one manually, the user agent will be provided by [AFNetworking](AFNetworking).

## Requirements

RedditKit requires either iOS 7.0+ or Mac OS X 10.9+. Xcode 5 is required in order to run its test suite.

ARC is required. For projects that don't use ARC, you can set the `-fobjc-arc` compiler flag on the RedditKit source files.

## Dependencies

* [AFNetworking](AFNetworking)
* [Mantle](https://github.com/github/Mantle)

## Credits

OAuth support was generously contributed in its entirety by [Joseph Pintozzi](https://github.com/pyro2927). If you find it useful, you have him to thank.

[SAMCategories](https://github.com/soffes/SAMCategories) by Sam Soffes is used for unescaping HTML entities in reddit link titles.

## Need Help?

Open an [issue](https://github.com/samsymons/RedditKit/issues), or hit me up on [Twitter](http://twitter.com/sam_symons).

[AFNetworking]: https://github.com/AFNetworking/AFNetworking

## License

Copyright (c) 2013 Sam Symons (http://samsymons.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
