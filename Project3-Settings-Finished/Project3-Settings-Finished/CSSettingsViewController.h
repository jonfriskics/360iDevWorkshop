//
//  CSSettingsViewController.h
//  Project3-Settings-Start
//
//  Created by Jon Friskics on 8/23/14.
//  Copyright (c) 2014 Code School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSStoriesTableViewController.h"

@interface CSSettingsViewController : UIViewController

@property (weak, nonatomic) id<SettingsProtocol> delegate;

@end
