#import <Foundation/Foundation.h>

/**
 `ArchaicURLProtocol` is a subclass of `NSURLProtocol` that serves as the base of other more specific archaic protocols.
 */
@interface ArchaicURLProtocol : NSURLProtocol<NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

/**
 The `NSURLRequest` is not altered in these subclassses.

 @param request The `NSURLRequest` to process.
 */
+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request;

-(void)startLoadingWithPort:(NSInteger)port;

/**
 Stops loading the request and close the underlying screen.
 */
-(void)stopLoading;

/**
 Closes both input and output streams if they haven't already been closed.

 @warning This is not meant to be called directly.
 */
-(void)close;

/**
 Closes the input stream if it hasn't already been closed.

 @warning This is not meant to be called directly.
 */
-(void)closeInput;

/**
 Closes the output stream if it hasn't already been closed.

 @warning This is not meant to be called directly.
 */
-(void)closeOutput;

@end