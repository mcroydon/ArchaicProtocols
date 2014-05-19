#import <Foundation/Foundation.h>
#import "ArchaicURLProtocol.h"

/**
 `DaytimeURLProtocol` is a subclass of `NSURLProtocol` that implements the Daytime protocol as defined in [RFC 867](http://tools.ietf.org/html/rfc867). It also implements `NSStreamDelegate` in order to communicate with the underlying network stream.

 NIST [maintains a list of time servers that support the Daytime protocol](http://tf.nist.gov/tf-cgi/servers.cgi).
 */
@interface DaytimeURLProtocol : ArchaicURLProtocol

/**
 Only responds to a `NSURLRequest` that starts with `daytime://`, case insensitive.

 @param request The `NSURLRequest` that might be processed.
 */
+(BOOL) canInitWithRequest:(NSURLRequest *)request;


/**
 Start processing the Daytime request from the host provided in the URL.

 @warning Requests are sent to the host in the URL to port 13. This port cannot be overriden if specified in the URL.

 */
-(void)startLoading;

@end