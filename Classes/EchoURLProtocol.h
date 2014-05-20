#import <Foundation/Foundation.h>
#import "ArchaicURLProtocol.h"

/**
 `EchoURLProtocol` is a subclass of `NSURLProtocol` that implements the echo protocol as defined in [RFC 862](http://tools.ietf.org/html/rfc862). It also implements `NSStreamDelegate` in order to communicate with the underlying network stream.

 The contents of the query string (i.e. `querystring`) will be sent to be echoed back.

 There aren't many public echo servers but it is possible to run your own with `inetd`, `xinetd`, or `netcat`.
 
 You may try echo://protocolmuseum.postneo.com/?test which may be available for testing purposes.
 */
@interface EchoURLProtocol : ArchaicURLProtocol

/**
 Only responds to a `NSURLRequest` that starts with `echo://`, case insensitive.

 @param request The `NSURLRequest` that might be processed.
 */
+(BOOL) canInitWithRequest:(NSURLRequest *)request;


/**
 Start processing the echo request from the host provided in the URL.

 @warning Requests are sent to the host in the URL to port 7. This port cannot be overriden if specified in the URL.

 */
-(void)startLoading;

@end