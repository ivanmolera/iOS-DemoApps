//
//  ViewController.h
//  Arkanoid
//
//  Created by IVAN MOLERA on 12/3/16.
//  Copyright © 2016 UAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) UIImageView           *ball;
@property (nonatomic, strong) UIImageView           *vaus;

@property (nonatomic, strong) UIPushBehavior        *push;
@property (nonatomic, strong) UICollisionBehavior   *collision;
@property (nonatomic, strong) UIDynamicAnimator     *animator;

@property (nonatomic, strong) UIDynamicItemBehavior *ballDynamicProperties;
@property (nonatomic, strong) UIDynamicItemBehavior *vausDynamicProperties;

@end

