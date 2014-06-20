## 1.2

* RKLink now has a `shortURL` method.
* RKLink now has properties for `upvoteRatio` and `gilded`.
* Fixes for those using submodules to install RedditKit.

## 1.1

* RKVotable subclasses now automatically update their voteStatus. (@rickharrison)
* Messages can be marked as read or unread in batches. (@rickharrison)
* Ensure that HTML entities are always unescaped correctly. (@christianselig)
* Comments can be sorted. (@rickharrison)
* It's now possible to access a user's saved and hidden links. (@rickharrison)
* Support for storing links as a reddit gold member. (@rickharrison)
* Improved support for multireddits. (@rickharrison)
* RKUser now subclasses RKCreated. (@rickharrison)
* Completion blocks are now called on the main thread.

## 1.0.3

* Fix an issue where subreddit categories were being ignored. (@rickharrison)

## 1.0.2

* Fix a bug in RKVotable where `voted` would return an incorrect value.
* Add pagination to subscribed subreddits.
* Change RKLink's `URL` property from an NSString to an NSURL.

## 1.0.1

Fix a couple crashes where RKThing subclasses would be created with nil JSON keys.

## 1.0.0

Initial release of RedditKit!
