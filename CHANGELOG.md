## 2.0.0

* Added support for OAuth, courtesy of [Joseph Pintozzi](https://github.com/pyro2927).
* Changed the prefix of the classes from `RK` to `RDK` to avoid potential clashes in the future.
* Using multiple `RDKClient` instances simultaneously will now work as advertised. Previously, they would accidentally use the same cookie storage.

## 1.0.1

* Fixed crashes where RKThing subclasses would be created with nil JSON keys.

## 1.0.0

Initial release of RedditKit!
