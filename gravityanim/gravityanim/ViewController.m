//
//  ViewController.m
//  gravityanim
//
//  Created by IVAN MOLERA on 28/2/16.
//  Copyright © 2016 UAB. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // CENTER POINT
    CGPoint anchorPoint = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    // PLANET
    CGRect planetBounds = CGRectMake(CGRectGetMidX(self.view.bounds)-50, CGRectGetMidY(self.view.bounds)-200, 100.0f, 100.0f);

    UIView *planet = [[UIView alloc] initWithFrame:planetBounds];

    [planet setBackgroundColor:[UIColor redColor]];
    [planet.layer setCornerRadius:50.0f];
    [planet.layer setBorderColor:[UIColor blackColor].CGColor];
    [planet.layer setBorderWidth:3.0f];
    [self.view addSubview:planet];
    
    // MOON
    CGRect moonBounds = CGRectMake(CGRectGetMidX(self.view.bounds)-100, CGRectGetMidY(self.view.bounds)-225, 20.0f, 20.0f);
    
    UIView *moon = [[UIView alloc] initWithFrame:moonBounds];
    
    [moon setBackgroundColor:[UIColor greenColor]];
    [moon.layer setCornerRadius:10.0f];
    [moon.layer setBorderColor:[UIColor blackColor].CGColor];
    [moon.layer setBorderWidth:1.0f];
    [self.view addSubview:moon];
    
    // BLACK HOLE
    CGRect blackHoleBounds = CGRectMake(0, 0, 20.0f, 20.0f);

    UIView *blackHole = [[UIView alloc] initWithFrame:blackHoleBounds];

    [blackHole setCenter:anchorPoint];
    [blackHole setBackgroundColor:[UIColor blackColor]];
    [blackHole.layer setCornerRadius:10.0f];
    [self.view addSubview:blackHole];
    
    // BEHAVIORS

    // ITEM BEHAVIOR: PLANET, MOON
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[planet, moon]];
    
    // Remove rotation
    [itemBehavior setAllowsRotation:NO];
    
    // Better collisions, no friction
    [itemBehavior setElasticity:1.0];
    [itemBehavior setFriction:0.0];
    [itemBehavior setResistance:0.0];

    [_animator addBehavior:itemBehavior];
    
    // PLANET ATTACHMENT TO CENTER
    _planetAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:planet
                                                        offsetFromCenter:UIOffsetMake(0.0f, -CGRectGetHeight(planet.bounds)/2.5f)
                                                        attachedToAnchor:anchorPoint];
    
    [_planetAttachmentBehavior setDamping:0];
    [_planetAttachmentBehavior setLength:200];
    [_planetAttachmentBehavior setFrequency:0];
    [_animator addBehavior:_planetAttachmentBehavior];

    // MOON ATTACHMENT TO PLANET
    _moonAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:moon attachedToItem:planet];
    [_animator addBehavior:_moonAttachmentBehavior];


    // GRAVITY
    _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[moon]];
    [_gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
    _gravityBehavior.action =  ^{
        NSLog(@"Planet %@, Moon %@",
              NSStringFromCGPoint(planet.center),
              NSStringFromCGPoint(moon.center));

        //CGVector gravityVector = [self vectorMakeFromPoint:planet.center toPoint:moon.center];
        //[_gravityBehavior setGravityDirection:gravityVector];
    };

    [_animator addBehavior:_gravityBehavior];

    // SNAP
    /*
    _snapBehavior = [[UISnapBehavior alloc] initWithItem:moon snapToPoint:anchorPoint];
    [_animator addBehavior:_snapBehavior];
    */
    

    // PUSH
    _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[planet]
                                                     mode:UIPushBehaviorModeInstantaneous];
    
    UITapGestureRecognizer *tapGestureRecognizer =
                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(pushPlanet:)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void) pushPlanet:(UITapGestureRecognizer*)paramSender {
    [_pushBehavior setPushDirection:CGVectorMake(10, 10)];
    [_pushBehavior setActive:YES];
    [_animator addBehavior:_pushBehavior];
}

- (CGVector) vectorMakeFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    return CGVectorMake(toPoint.x - fromPoint.x, toPoint.y - fromPoint.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
