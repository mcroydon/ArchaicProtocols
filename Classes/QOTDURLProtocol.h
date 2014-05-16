#import <Foundation/Foundation.h>

/**
 `QOTDURLProtocol` is a subclass of `NSURLProtocol` that implements the QOTD protocol as defined in RFC 862 (http://tools.ietf.org/html/rfc862). It also implements `NSStreamDelegate` in order to communicate with the underlying network stream.
 */
@interface QOTDURLProtocol : NSURLProtocol<NSStreamDelegate>

@end
