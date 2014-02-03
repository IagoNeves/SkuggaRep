//
//  ContactCell.h
//  Socialize
//
//  Created by Iago Almeida Neves on 1/11/14.
//  Copyright (c) 2014 Iago Neves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell


@property (nonatomic, strong) IBOutlet UIImageView *contactPhoto;
@property (weak, nonatomic) IBOutlet UILabel *contactName;

@end
