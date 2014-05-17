#import <Foundation/Foundation.h>

/**
 `QOTDURLProtocol` is a subclass of `NSURLProtocol` that implements the QOTD protocol as defined in RFC 862 (http://tools.ietf.org/html/rfc862). It also implements `NSStreamDelegate` in order to communicate with the underlying network stream.
 */
@interface QOTDURLProtocol : NSURLProtocol<NSStreamDelegate>

/**
 Only responds to a `NSURLRequest` that starts with `qotd://`, case insensitive.

 @param request The `NSURLRequest` that might be processed.
 */
+(BOOL) canInitWithRequest:(NSURLRequest *)request;

/**
 The `NSURLRequest` is not altered in this subclass.
 @param request The `NSURLRequest` to process.
 */
+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request;

/**
 Start processing the QOTD request from the host provided in the URL.

 @warning Requests are sent to the host in the URL to port 17. This port cannot be overriden if specified in the URL.

 */
-(void)startLoading;

/**
 Stops loading the QOTD request and closes the underlying screen.
 */
-(void)stopLoading;

@end
