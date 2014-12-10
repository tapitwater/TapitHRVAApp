#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "MapLocationModel.h"

@interface MapAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
    MapLocationModel *model;
    int nIconType;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (readonly) MapLocationModel *model;
@property (nonatomic) int nIconType;

-(NSString *)title;
-(id)initWithNearby:(MapLocationModel *)locationModel;

@end