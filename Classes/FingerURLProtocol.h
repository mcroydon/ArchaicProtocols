#import <Foundation/Foundation.h>
#import "ArchaicURLProtocol.h"

/**
 `FingerURLProtocol` is a subclass of `NSURLProtocol` that enables the use of the original Finger protocol as defined in RFC 742 (http://tools.ietf.org/html/rfc742). It also implements `NSStreamDelegate` in order to communicate with the underlying network stream.
 
 Example URL formats supported:
 
    finger://bathroom.mit.edu
    finger://help@bathroom.mit.edu
 
 @warning *Note:* `FingerURLProtocol` does not support the advanced functionality outlined in RFC 1288 (http://tools.ietf.org/html/rfc1288) including recursive hostname lookups.
 */
@interface FingerURLProtocol : ArchaicURLProtocol

/**
 Only responds to a `NSURLRequest` that starts with `finger://`, case insensitive.
 
 @param request The `NSURLRequest` that might be processed.
 */
+(BOOL) canInitWithRequest:(NSURLRequest *)request;

/**
 Start processing the Finger request from the host provided in the URL.
 */
-(void)startLoading;

@end
