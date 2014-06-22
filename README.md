# RedditKit [![Build Status](https://travis-ci.org/samsymons/RedditKit.svg?branch=master)](https://travis-ci.org/samsymons/RedditKit)

RedditKit is a [reddit API](http://www.reddit.com/dev/api) wrapper, written in Objective-C.

## Documention

Documentation for RedditKit is [available on CocoaDocs](http://cocoadocs.org/docsets/RedditKit/1.2.0/).

## Installation

### CocoaPods

Add this to your Podfile:

	pod 'RedditKit', '~> 1.2'

Then run:
	
	pod install

### Submodules

**Adding RedditKit:**

1. Add RedditKit as a git submodule of your project: `git submodule add https://github.com/samsymons/RedditKit.git`
2. Fetch its dependencies with `git submodule update --init --recursive`

**Adding AFNetworking:**

Inside the newly created `RedditKit` directory, there exists an `External` directory containing its dependencies which the `git submodule update` command will have populated. Drag AFNetworking's `Classes` directory into your project.

**Adding Mantle:**

Follow [Mantle's instructions on getting the project set up](https://github.com/Mantle/Mantle#importing-mantle).

Once you have everything set up, you may need to restart Xcode to have it pick up your changes.

## Getting Started

RedditKit is structured around the `RKClient` class. This class manages authentication for a single reddit account and performs HTTP requests on that user's behalf. `RKClient` can be used as a singleton with its `sharedClient` class method, or as a standalone object.

```obj-c
[[RKClient sharedClient] signInWithUsername:@"name" password:@"password" completion:^(NSError *error) {
    if (!error)
    {
        NSLog(@"Successfully signed in!");
    }
}];
```

Once you're signed in, `RKClient` will keep track of any necessary authentication state. You can then call methods which require authentication, such as getting the subreddits you are subscribed to.

**Note:** RedditKit does not persist your authentication credentials itself; you'll have to do this manually via the Keychain, and call `signInWithUsername:password:completion:` on your application's launch.

```obj-c
[[RKClient sharedClient] subscribedSubredditsWithCompletion:^(NSArray *subreddits, NSError *error) {
    NSLog(@"Subreddits: %@", subreddits);
}];
```

Retrieving the current top links in a subreddit is simple.

```obj-c
RKSubreddit *subreddit = [[self subreddits] firstObject];

[[RKClient sharedClient] linksInSubreddit:subreddit pagination:nil completion:^(NSArray *links, RKPagination *pagination, NSError *error) {
    NSLog(@"Links: %@", links);
}];
```

You can then upvote a link.

```obj-c
RKLink *link = [[self links] firstObject];

[[RKClient sharedClient] upvote:link completion:^(NSError *error) {
    NSLog(@"Upvoted the link!");
}];
```

> RedditKit doesn't have any built-in rate limiting. reddit's API rules require that you make no more than 30 requests per minute and try to avoid requesting the same page more than once every 30 seconds. You can read up on the API rules [on their wiki page](https://github.com/reddit/reddit/wiki/API).

## More Examples

**Get the top comments for a link:**

```obj-c
RKLink *link = [[self links] firstObject];

[[RKClient sharedClient] commentsForLink:link completion:^(NSArray *comments, NSError *error) {
	if (comments)
	{
		NSLog(@"Comments: %@", comments);
	}
}];
```

**Fetch a user's account:**

```obj-c
[[RKClient sharedClient] userWithUsername:@"name" completion:^(RKUser *account, NSError *error) {
	if (account)
	{
		NSLog(@"%@", account);
	}
}];
```

**Send private messages:**

```obj-c
[[RKClient sharedClient] sendMessage:@"Hello!" subject:nil recipient:@"samsymons" completion:nil];
```

**Canceling a request:**

Each of RedditKit's methods return a `NSURLSessionDataTask`, which can be used to cancel a request before it has completed.

```obj-c
NSURLSessionDataTask *task = [[RKClient sharedClient] frontPageLinksWithCompletion:nil];
[task cancel];
```

## Pagination

Methods which are paginated can accept `RKPagination` objects.

`RKPagination` lets you change the sorting of returned objects. For example, when fetching the top 25 links in a subreddit, setting the `subredditCategory` property changes whether you get the top 25 links right now or the top links overall.

In addition to letting you change the pagination of your requests, RedditKit also gives you pagination information for any requests made. A request for links in a subreddit has a pagination object as an argument in its completion block.

> The [example project](Example/) implements pagination in a table view controller, loading new links when the user scrolls to the bottom.

## Multiple Accounts

`RKClient` manages a single reddit account. When supporting multiple accounts, all you need to do is switch from using the `sharedClient` method to using one `RKClient` instance per account.

For example, this code:

```obj-c
[[RKClient sharedClient] signInWithUsername:@"username" password:@"password" completion:nil];
[[RKClient sharedClient] upvote:someLink completion:nil];
```

Becomes this:

```obj-c
RKClient *client = [[RKClient alloc] init];

[client signInWithUsername:@"username" password:@"password" completion:nil];
[client upvote:someLink completion:nil];
```

How you manage the various `RKClient` instances is up to you. Probably with an `NSDictionary`, using reddit usernames as keys.

## Configuration

You can configure various aspects of RedditKit's operation, including its default API endpoint and user agent. Check out the `RKClient` header file for more.

**You should set your user agent to the name and version of your app, along with your reddit username. That way, if you ever have a buggy version of your app in the wild, the reddit admins will know who to contact.**

If you do not set one manually, the user agent will be provided by [AFNetworking](AFNetworking).

## Requirements

RedditKit requires either iOS 7.0+ or Mac OS X 10.9+. Xcode 5 is required in order to run its test suite.

ARC is required. For projects that don't use ARC, you can set the `-fobjc-arc` compiler flag on the RedditKit source files.

## Dependencies

* [AFNetworking](AFNetworking)
* [Mantle](https://github.com/github/Mantle)

## Credits

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
