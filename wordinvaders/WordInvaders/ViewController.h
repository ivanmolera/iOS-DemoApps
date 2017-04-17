//
//  ViewController.h
//  WordInvaders
//
//  Created by IVAN MOLERA on 1/6/16.
//  Copyright © 2016 Ivan Molera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    NSString        *paraula;
    NSMutableArray  *lletres;
    NSMutableArray  *abecedari;

    NSString *nextLetter;
}

@property (nonatomic, strong) NSTimer               *blockTimer;

@property (nonatomic, strong) UIImageView           *ball;
@property (nonatomic, strong) UIView                *vaus;

@property (nonatomic, strong) UIPushBehavior        *push;
@property (nonatomic, strong) UICollisionBehavior   *collision;
@property (nonatomic, strong) UIGravityBehavior     *gravity;
@property (nonatomic, strong) UIDynamicAnimator     *animator;

@property (nonatomic, strong) UIDynamicItemBehavior *ballDynamicProperties;
@property (nonatomic, strong) UIDynamicItemBehavior *vausDynamicProperties;


@end

