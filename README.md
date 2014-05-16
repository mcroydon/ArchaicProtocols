# ArchaicProtocols

[![Version](http://cocoapod-badges.herokuapp.com/v/ArchaicProtocols/badge.png)](http://cocoadocs.org/docsets/ArchaicProtocols)
[![Platform](http://cocoapod-badges.herokuapp.com/p/ArchaicProtocols/badge.png)](http://cocoadocs.org/docsets/ArchaicProtocols)

## Introduction

ArchaicProtocols makes older text-based protocols available to iOS developers by subclassing [NSURLProtocol](https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/classes/NSURLProtocol_Class/Reference/Reference.html).

Why? Why not!

Currently implemented:

* [QOTD](http://en.wikipedia.org/wiki/QOTD)

Wishlist:

* Finger
* Gopher

## Example

```objective-c
#import "QOTDURLProtocol.h"

// Register our NSURLProtocol subclass
[NSURLProtocol registerClass:[QOTDURLProtocol class]];

// Create a QTOD URL
NSURL *qotd = [NSURL URLWithString:@"qotd://djxmmx.net/"];

// Get the default session
NSURLSession *session = [NSURLSession sharedSession];

// Create a task and run it
NSURLSessionDataTask *task = [session dataTaskWithURL:qotd completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSLog(@"Response encoded %@ with error %@.", response.MIMEType, error);
    NSString *responseString = [[NSString alloc] initWithData: data
                                                     encoding: NSASCIIStringEncoding];
    NSLog(@"Full response:\n%@", responseString);
}];
[task resume];
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

