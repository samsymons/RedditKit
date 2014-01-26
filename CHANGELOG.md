## 2.0.0

* Added support for OAuth, courtesy of [Joseph Pintozzi](https://github.com/pyro2927).
* Changed the prefix of the classes from `RK` to `RDK` to avoid potential clashes in the future.

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
