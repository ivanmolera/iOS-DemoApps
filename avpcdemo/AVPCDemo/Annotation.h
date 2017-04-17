//
//  Annotation.h
//  Marcadores
//
//  Created by IVAN MOLERA on 08/12/13.
//  Copyright (c) 2013 UAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

typedef enum annotationTypes {
    VOLUNTEER,
    CECOPAL,
    FIRE
} AnnotationType;

@property (nonatomic, readonly) CLLocationCoordinate2D  coordinate;
@property (nonatomic, copy) NSString                    *title;
@property (nonatomic, copy) NSString                    *subtitle;

@property (nonatomic, assign) AnnotationType            annotationType;
@property (nonatomic, assign) BOOL                      statusReady;
@property (nonatomic, strong) UIImage                   *imagen;
@property (nonatomic, strong) MKCircle                  *circle;

- (instancetype) initAnnotationWithCoordinates:(CLLocationCoordinate2D)coordinates
                                          type:(AnnotationType)type
                                         title:(NSString*)paramTitle
                                      subtitle:(NSString*)paramSubtitle
                                andStatusReady:(BOOL)status;

- (MKAnnotationView *) annotationView;

@end
