//
//  ViewController.m
//  Arkanoid
//
//  Created by IVAN MOLERA on 12/3/16.
//  Copyright © 2016 UAB. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Init animator
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    [self initBallView];
    
    [self initVausView];
    
    [self setGestureRecognizers];
    
    [self pushBall];

    [self initBehaviors];
}

- (void) setGestureRecognizers {
    // Interacción con la plataforma
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];

    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;

    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void) initBehaviors {

    [self initCollisionBehavior];
    [self initBallBehavior];
    [self initVausBehavior];
}

- (void) initBallBehavior {
    // Remove rotation
    _ballDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[_ball]];

    [_ballDynamicProperties setAllowsRotation:NO];

    // Better collisions, no friction
    [_ballDynamicProperties setElasticity:1.0];
    [_ballDynamicProperties setFriction:0.0];
    [_ballDynamicProperties setResistance:0.0];
    
    [_animator addBehavior:_ballDynamicProperties];
}

- (void) initVausBehavior {
    _vausDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[_vaus]];

    [_vausDynamicProperties setAllowsRotation:NO];
    [_vausDynamicProperties setDensity:1000.0f];

    [_animator addBehavior:_vausDynamicProperties];
}

- (void) initCollisionBehavior {
    // Collision
    _collision = [[UICollisionBehavior alloc] initWithItems:@[_ball]];

    [self initBlocks];

    [_collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [_collision setCollisionDelegate:self];
    [_collision setCollisionMode:UICollisionBehaviorModeEverything];

    [_animator addBehavior:_collision];
    
    // Adding collison boundary for vaus
    CGPoint esquinaDerecha = CGPointMake(_vaus.frame.origin.x + _vaus.frame.size.width,
                                         _vaus.frame.origin.y);
    
    [_collision addBoundaryWithIdentifier:@"vaus"
                                fromPoint:_vaus.frame.origin
                                  toPoint:esquinaDerecha];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier
                  atPoint:(CGPoint)p {

    NSLog(@"Boundary contact occurred - %@", identifier);

    NSString *identificador = (NSString*)identifier;

    NSRange replaceRange = [identificador rangeOfString:@"block"];
    
    if(replaceRange.location != NSNotFound) {
        NSString *str = [identificador stringByReplacingCharactersInRange:replaceRange withString:@""];
        NSLog(@"Remove - %@", str);
//        [[self.view viewWithTag:[str intValue]] removeFromSuperview];
    }
}

- (void) handlePan:(UIPanGestureRecognizer*)paramSender {
    
    if (paramSender.state != UIGestureRecognizerStateEnded &&
        paramSender.state != UIGestureRecognizerStateFailed) {
        
        CGPoint touch = [paramSender locationInView:paramSender.view.superview];
        
        // Updating vaus position
        CGPoint newVausLocation = CGPointMake(touch.x, _vaus.center.y);
        _vaus.center = newVausLocation;
        
        CGPoint esquinaDerecha = CGPointMake(_vaus.frame.origin.x + _vaus.frame.size.width,
                                             _vaus.frame.origin.y);
        
        // Erasing vaus boundary
        [_collision removeBoundaryWithIdentifier:@"vaus"];
        
        // Adding vaus boundary
        [_collision addBoundaryWithIdentifier:@"vaus"
                                   fromPoint:_vaus.frame.origin
                                     toPoint:esquinaDerecha];
        
        [_animator updateItemUsingCurrentState:_vaus];
    }
}

- (void) initBallView {
    // Init ball
    _ball = [[UIImageView alloc] initWithFrame:
             CGRectMake(CGRectGetMidX(self.view.bounds)-50,
                        200.0f,
                        30.0f,
                        30.0f)];
    
    [_ball setImage:[UIImage imageNamed:@"tennisball.png"]];
    
    [self.view addSubview:_ball];
}

- (void) initVausView {
    // Init vaus
    _vaus = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-75,
                                                          self.view.frame.size.height-100,
                                                          88.0f,
                                                          22.0f)];
    
    [_vaus setImage:[UIImage imageNamed:@"vaus.png"]];
    
    [self.view addSubview:_vaus];
}

- (void) initBlocks {

    for(int i=0;i<5;i++) {

        // Init block
        UIView *block = [[UIView alloc] initWithFrame:CGRectMake(100*i,
                                                          50.0f,
                                                          70.0f,
                                                          40.0f)];
        
        [block setBackgroundColor:[UIColor brownColor]];
        [block setTag:i];

        [self.view addSubview:block];
        
        [_collision addItem:block];
        
        // Adding the block boundary
        CGPoint esqDerBlock = CGPointMake(block.frame.origin.x + block.frame.size.width,
                                          block.frame.origin.y);
        
        [_collision addBoundaryWithIdentifier:[NSString stringWithFormat:@"block%i", i]
                                    fromPoint:block.frame.origin
                                      toPoint:esqDerBlock];
    }
}

- (void) pushBall {
    // Start ball off with a push
    _push = [[UIPushBehavior alloc] initWithItems:@[_ball]
                                             mode:UIPushBehaviorModeInstantaneous];
    
    [_push setPushDirection:CGVectorMake(0.5, 1.0)];
    [_push setActive:YES];
    
    // Because push is instantaneous, it will only happen once
    [self.animator addBehavior:_push];
}

- (void) viewDidAppear:(BOOL)animated {

    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
