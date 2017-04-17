//
//  Annotation.h
//  Marcadores
//
//  Created by IVAN MOLERA on 08/12/13.
//  Copyright (c) 2013 UAB. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (instancetype) initAnnotationWithCoordinates:(CLLocationCoordinate2D)coordinates
                                           type:(AnnotationType)type
                                          title:(NSString*)paramTitle
                                      subtitle:(NSString*)paramSubtitle
                                andStatusReady:(BOOL)statusReady {
    self = [super init];
    
    if(self != nil) {
        _coordinate = coordinates;
        _title = paramTitle;
        _subtitle = paramSubtitle;
        _statusReady = statusReady;
        _annotationType = type;
        
        CLLocationDistance fenceDistance = 0;

        if(_imagen == nil) {
            
            switch (_annotationType) {
                case VOLUNTEER:
                    _imagen = [UIImage imageNamed:_statusReady ? @"pin_green" : @"pin_red"];
                    fenceDistance = 20;
                    break;
                    
                case CECOPAL:
                    _imagen = [UIImage imageNamed:@"pin_blue"];
                    break;
                    
                case FIRE:
                    _imagen = [UIImage imageNamed:@"fire"];
                    fenceDistance = 300;
                    break;
                    
                default:
                    _imagen = [UIImage imageNamed:@"pin_blue"];
                    break;
            }
            
        }
        
        _circle = [MKCircle circleWithCenterCoordinate:coordinates radius:fenceDistance];
        
    }
    
    return self;
}

- (MKAnnotationView *) annotationView {
        MKAnnotationView *aView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                               reuseIdentifier:@"volunteer"];
    
        // Configuramos la vista
        [aView setCenterOffset:CGPointMake(0, -20)];
        [aView setEnabled:YES];
        [aView setDraggable:YES];
        [aView setCanShowCallout:YES];

        aView.image = _imagen;
    
        // Le damos el tamaño al pin
        CGRect frame = aView.frame;
        frame.size.width = 20;
        frame.size.height = 32;
    
        aView.frame = frame;

        return aView;
}

@end
