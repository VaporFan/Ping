#import "CUUCD2012APIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kCUUCD2012APIBaseURLString = @"http://mighty-ravine-3570.herokuapp.com/";

@implementation CUUCD2012APIClient

+ (CUUCD2012APIClient *)sharedClient {
    static CUUCD2012APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kCUUCD2012APIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - AFIncrementalStore

- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
    return responseObject;
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation 
                                     ofEntity:(NSEntityDescription *)entity 
                                 fromResponse:(NSHTTPURLResponse *)response 
{
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    
    // Customize the response object to fit the expected attribute keys and values  
    
    return mutablePropertyValues;
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

@end