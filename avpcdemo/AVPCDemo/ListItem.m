//
//  ListItem.m
//  AVPCDemo
//
//  Created by IVAN MOLERA on 18/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

- (instancetype)initWithMemberData:(NSDictionary*)dictionary {

    NSString *identifier = @"Item";

    if (self = [super initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:identifier]) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            UIImage *img = [UIImage imageNamed:@"sensefoto.jpg"];

            if([dictionary objectForKey:@"photo"] != nil && ![[dictionary objectForKey:@"photo"] isEqualToString:@""]) {
                NSURL *url = [NSURL URLWithString:dictionary[@"photo"]];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                img = [[UIImage alloc] initWithData:imageData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.textLabel setText:[NSString stringWithFormat:@"%@ %@", dictionary[@"name"], dictionary[@"surname1"]]];
                [self.detailTextLabel setText:dictionary[@"mobilephoneNumber"]];
                [self.imageView setFrame:CGRectMake(0, 0, 80, 70)];
                [self.imageView setImage:img];
            });
        });
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
