#import "ArchaicURLProtocol.h"
#import "DaytimeURLProtocol.h"

@implementation DaytimeURLProtocol

-(instancetype)init{
    self = [super init];
    return self;
}

+(BOOL) canInitWithRequest:(NSURLRequest *)request
{
	if ([request.URL.scheme caseInsensitiveCompare:@"daytime"] == NSOrderedSame) {
		return YES;
	}
	return NO;
}

/**
 Utilizes the default no payload implementation from ArchaicURLProtocol, specifying port 13, the Daytime port.
 */
-(void)startLoading
{
    [super startLoadingWithPort:13];
}
@end