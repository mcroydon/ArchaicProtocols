# ArchaicProtocols

[![Version](http://cocoapod-badges.herokuapp.com/v/ArchaicProtocols/badge.png)](http://cocoadocs.org/docsets/ArchaicProtocols)
[![Platform](http://cocoapod-badges.herokuapp.com/p/ArchaicProtocols/badge.png)](http://cocoadocs.org/docsets/ArchaicProtocols)

## Introduction

ArchaicProtocols makes older text-based protocols available to iOS developers by subclassing [NSURLProtocol](https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/classes/NSURLProtocol_Class/Reference/Reference.html).

Why? Why not!

Currently implemented:

* [Daytime](http://en.wikipedia.org/wiki/Daytime_Protocol)
* [Echo](http://en.wikipedia.org/wiki/Echo_Protocol)
* [Finger](http://en.wikipedia.org/wiki/Finger_protocol)
* [QOTD](http://en.wikipedia.org/wiki/QOTD)

Wishlist:

* Gopher

## Examples

### Finger

```objective-c
#import "FingerURLProtocol.h"

// Register our NSURLProtocol subclass
[NSURLProtocol registerClass:[FingerURLProtocol class]];

// Create a Finger URL (the user part is optional)
NSURL *finger = [NSURL URLWithString:@"finger://help@bathroom.mit.edu/"];
```

### QOTD

```objective-c
#import "QOTDURLProtocol.h"

// Register our NSURLProtocol subclass
[NSURLProtocol registerClass:[QOTDURLProtocol class]];

// Create a QTOD URL
NSURL *qotd = [NSURL URLWithString:@"qotd://djxmmx.net/"];
```

### Daytime

```objective-c
#import "DaytimeURLProtocol.h"

// Register our NSURLProtocol subclass
[NSURLProtocol registerClass:[DaytimeURLProtocol class]];

// Create a Daytime URL
NSURL *daytime = [NSURL URLWithString:@"daytime://time-c.nist.gov/"];
```

### Echo

```objective-c
#import "EchoURLProtocol.h"

// Register our NSURLProtocol subclass
[NSURLProtocol registerClass:[EchoURLProtocol class]];

// Create an Echo URL
NSURL *echo = [NSURL URLWithString:@"echo://protocolhistory.postneo.com/?testecho"];
```

### Full example

```objective-c
#import "FingerURLProtocol.h"

// Register our NSURLProtocol subclass
[NSURLProtocol registerClass:[FingerURLProtocol class]];

// Create a Finger URL (the user part is optional)
NSURL *finger = [NSURL URLWithString:@"finger://help@bathroom.mit.edu/"];

// Get the default session
NSURLSession *session = [NSURLSession sharedSession];

// Create a task and run it
NSURLSessionDataTask *task = [session dataTaskWithURL:finger completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSLog(@"Response encoded %@ with error %@.", response.MIMEType, error);
    NSString *responseString = [[NSString alloc] initWithData: data
                                                     encoding: NSASCIIStringEncoding];
    NSLog(@"Full response:\n%@", responseString);
}];
[task resume];
```

```
[nw61-310-8.mit.edu]
Random Hall Bathroom Server v2.1

                         Bonfire Kitchen: *IN*USE* for 36 min
                         Bonfire  Lounge: vacant for 6 hr
                          Pecker  Lounge: vacant for 2 min
                          Pecker Kitchen: vacant for 39 min
   K 282  L  290 K          Clam Kitchen: *IN*USE* for 33 min
   ... ... ... ...          Clam  Lounge: vacant for 4 hr
  | x : o | o : o |          BMF  Lounge: vacant for 3 min
  | x : o | o : o |          BMF Kitchen: vacant for 14 min
  | o : o | o : o |         Loop Kitchen: vacant for 2 sec
  | o : o | - : o |         Loop  Lounge: vacant for 6 hr
 ~~~~~~~~~~~~~~~~~~~  Black Hole  Lounge: vacant for 53 min
                      Black Hole Kitchen: vacant for 3 hr
      o = vacant!        Destiny Kitchen: vacant for 9 min
      x = in use          Destiny Lounge: vacant for 4 hr
                                     Foo: vacant for 59 min

For more information finger help@bathroom.mit.edu

(2181964)
```

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Installation

ArchaicProtocols is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "ArchaicProtocols"

## Tests

To run tests, clone the repo, open Example.xcworkspace in the Example directory, then run `pod install`.

Tests are in Example/ExampleTests/ExampleTests.m and can be run with Product -> Test. The tests are also a complete example of ArchaicProtocols in action.

If you run in to errors during build, remove `libPods-Example.a` from the Link Binary With Libraries under Build Phases. See [this CocoaPods issue](https://github.com/CocoaPods/CocoaPods/issues/1729) for more information.

## Development Status

ArchaicProtocols is in early experimental development, and should be considered "alpha" quality and not fit for deployment. If you find an error or run in to any problems, please open an issue or a pull request.

## Author

Matt Croydon, mcroydon@gmail.com

## License

ArchaicProtocols is available under the MIT license. See the LICENSE file for more info.

