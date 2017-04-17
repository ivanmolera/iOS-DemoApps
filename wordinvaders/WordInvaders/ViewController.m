//
//  ViewController.m
//  WordInvaders
//
//  Created by IVAN MOLERA on 1/6/16.
//  Copyright © 2016 Ivan Molera. All rights reserved.
//

#import "ViewController.h"

#define ARC4RANDOM_MAX      0x100000000

#define BLOCK_WIDTH         40
#define BLOCK_HEIGHT        40

@interface ViewController () <UICollisionBehaviorDelegate>

@end

@implementation ViewController

- (void) initJoc {
    paraula = @"HOLA";

    lletres = [NSMutableArray array];

    for (int i=0; i<paraula.length; i++) {
        [lletres addObject:[paraula substringWithRange:NSMakeRange(i, 1)]];
    }

    abecedari = [[NSMutableArray alloc] init];

    [abecedari addObjectsFromArray:lletres];
    [abecedari addObjectsFromArray:[NSMutableArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", nil]];
    [abecedari addObjectsFromArray:lletres];
    [abecedari addObjectsFromArray:[NSMutableArray arrayWithObjects:@"K", @"L", @"M", @"N", @"Ñ", @"O", @"P", @"Q", @"R", @"S", nil]];
    [abecedari addObjectsFromArray:lletres];
    [abecedari addObjectsFromArray:[NSMutableArray arrayWithObjects:@"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]];
    [abecedari addObjectsFromArray:lletres];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initJoc];
    
    [self initParaula];
    
    // Init animator
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    [self initVausView];
    
    [self setGestureRecognizers];
    
    [self initBehaviors];

    
    _blockTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(initBlock)
                                   userInfo:nil
                                    repeats:YES];
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
    [self initGravityBehavior];
    [self initCollisionBehavior];
    [self initVausBehavior];
}

- (void) initVausBehavior {
    _vausDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[_vaus]];
    
    [_vausDynamicProperties setAllowsRotation:NO];
    [_vausDynamicProperties setDensity:1000.0f];
    
    [_collision addItem:_vaus];
    
    [_animator addBehavior:_vausDynamicProperties];
}

- (void) initCollisionBehavior {
    // Collision
    //_collision = [[UICollisionBehavior alloc] initWithItems:@[_vaus]];
    _collision = [[UICollisionBehavior alloc] init];
    
    [self initBlock];
    
    //[_collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [_collision setCollisionDelegate:self];
    [_collision setCollisionMode:UICollisionBehaviorModeItems];
    
    [_collision addBoundaryWithIdentifier:@"bottom"
                                fromPoint:CGPointMake(0, self.view.bounds.size.height)
                                  toPoint:CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [_animator addBehavior:_collision];
}

- (void) initGravityBehavior {
    // Gravity
    _gravity = [[UIGravityBehavior alloc] init];
    
    [_animator addBehavior:_gravity];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier
                  atPoint:(CGPoint)p {

    NSString *identificador = (NSString *)identifier;
    
    
    UIView *myView = (UIView *)item;
    
    for (UIView *view in myView.subviews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *lbl = (UILabel*)view;
            NSLog(@"%@, %@", identificador, [lbl text]);
            
            long pos = [self doesString:paraula contains:[lbl text]];

            if(pos < 0) {
                NSLog(@"OK");
            }
            else {
                [self setLletra:[lbl text] pos:pos ambColor:[UIColor redColor]];
            }
        }
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(nonnull id<UIDynamicItem>)item1 withItem:(nonnull id<UIDynamicItem>)item2 atPoint:(CGPoint)p {

    UIView *view1 = (UIView *)item1;

    if([view1 tag] == 999) {
    
        UIView *myView = (UIView *)item2;
    
        for (UIView *view in myView.subviews)
        {
            if([view isKindOfClass:[UILabel class]])
            {
                UILabel *lbl = (UILabel*)view;
            
                long pos = [self doesString:paraula contains:[lbl text]];
            
                if(pos < 0) {
                    NSLog(@"ERROR");
                }
                else {
                    [self setLletra:[lbl text] pos:pos ambColor:[UIColor greenColor]];
                    [myView removeFromSuperview];
                }
            }
        }
    }
}


- (void) handlePan:(UIPanGestureRecognizer*)paramSender {
    
    if (paramSender.state != UIGestureRecognizerStateEnded &&
        paramSender.state != UIGestureRecognizerStateFailed) {
        
        CGPoint touch = [paramSender locationInView:paramSender.view.superview];
        
        CGFloat centerX = touch.x;
        if(touch.x > self.view.bounds.size.width-20) {
            centerX = self.view.bounds.size.width-20;
        }
        else if(touch.x < 20) {
            centerX = 20;
        }
        
        
        // Updating vaus position
        CGPoint newVausLocation = CGPointMake(centerX, _vaus.center.y);
        _vaus.center = newVausLocation;
        
        CGPoint esquinaDerecha = CGPointMake(_vaus.frame.origin.x + _vaus.frame.size.width,
                                             _vaus.frame.origin.y);
        /*
        // Erasing vaus boundary
        [_collision removeBoundaryWithIdentifier:@"vaus"];

        // Adding vaus boundary
        [_collision addBoundaryWithIdentifier:@"vaus"
                                    fromPoint:_vaus.frame.origin
                                      toPoint:esquinaDerecha];
        */
        [_animator updateItemUsingCurrentState:_vaus];
        
    }
}

- (void) initParaula {

    for (long i=0; i<[lletres count]; i++) {
        
        NSString *lletra = [lletres objectAtIndex:i];
        
        [self setLletra:lletra pos:i ambColor:[UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
    }
}

- (void) setLletra:(NSString *)lletra pos:(long)i ambColor:(UIColor *)color {

    UIView *lletraView = [[UIView alloc] initWithFrame:CGRectMake((i*BLOCK_WIDTH),
                                                                  self.view.bounds.size.height-40,
                                                                  BLOCK_WIDTH,
                                                                  BLOCK_HEIGHT)];
    
    [lletraView setBackgroundColor:color];
    lletraView.layer.zPosition = 999;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
    
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 15.0f]];
    
    [label setText:lletra];
    
    [lletraView addSubview:label];
    
    [self.view addSubview:lletraView];
}

- (void) initVausView {
    
    UIView *vausBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      self.view.bounds.size.height-80,
                                                                      self.view.bounds.size.width,
                                                                      BLOCK_HEIGHT)];
    
    [vausBackground setBackgroundColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f]];
    
    [self.view addSubview:vausBackground];
    
    // Init vaus
    _vaus = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-BLOCK_WIDTH,
                                                          self.view.frame.size.height-80,
                                                          BLOCK_WIDTH,
                                                          BLOCK_HEIGHT)];
    [_vaus setTag:999];
    _vaus.layer.zPosition = 999;

    [_vaus setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
    
    [self.view addSubview:_vaus];
}

- (void) initBlock {

    CGFloat position = [self getRandomBlockPosition];
    
    //NSLog(@"position = %f", position);
    
    // Init block
    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(position,
                                                            -50.0f,
                                                            BLOCK_WIDTH,
                                                            BLOCK_HEIGHT)];
    
    [block setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
        
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 15.0f]];
    
    NSString *lletra = [self getRandomLetter];
    
    //NSLog(@"letter = %@", lletra);

    [label setText:lletra];

    [block addSubview:label];

    [self.view addSubview:block];
        
    [_collision addItem:block];
        
    // Adding the block boundary
    CGPoint esqDerBlock = CGPointMake(block.frame.origin.x + block.frame.size.width,
                                          block.frame.origin.y);
        
    [_collision addBoundaryWithIdentifier:lletra
                                fromPoint:block.frame.origin
                                  toPoint:esqDerBlock];
    
    CGVector vector = CGVectorMake(0.0, 0.3);
    [_gravity setGravityDirection:vector];
    
    [_gravity addItem:block];
}

- (long) doesString:(NSString *)string contains:(NSString *)substring {
    
    long pos = [string rangeOfString:substring].location;

    if (pos != NSNotFound) {
        return pos;
    }
    return -1;
}
               
- (CGFloat) getRandomGravity {
    float diff = 0.5 - 0.2;
    return (((float) rand() / RAND_MAX) * diff) + 0.2;
}

- (int) getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

- (NSString *) getRandomLetter {
    return [abecedari objectAtIndex:[self getRandomNumberBetween:0 to:(int)[abecedari count]-1]];
}

- (CGFloat) getRandomBlockPosition {
    return (CGFloat)[self getRandomNumberBetween:0 to:(int)(self.view.bounds.size.width-40)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
