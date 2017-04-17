//
//  ViewController.h
//  gravityanim
//
//  Created by IVAN MOLERA on 28/2/16.
//  Copyright © 2016 UAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property(nonatomic, strong) UIDynamicAnimator      *animator;

@property(nonatomic, strong) UIDynamicBehavior      *dynamicBehavior;

@property(nonatomic, strong) UIGravityBehavior      *gravityBehavior;
@property(nonatomic, strong) UICollisionBehavior    *snapBehavior;

@property(nonatomic, strong) UIAttachmentBehavior   *planetAttachmentBehavior;
@property(nonatomic, strong) UIAttachmentBehavior   *moonAttachmentBehavior;

@property(nonatomic, strong) UIPushBehavior         *pushBehavior;
@property(nonatomic, strong) UIPushBehavior         *moonPushBehavior;

@end

