#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate;
@synthesize model;
@synthesize nIconType;

- (NSString *)title{
    return [model name];
}


-(id)initWithNearby:(MapLocationModel *)locationModel
{
    model = locationModel;
    nIconType = model.icontype;
    coordinate.latitude = [model latitude];
    coordinate.longitude = [model longitude];
    
    return [super init];
}


@end