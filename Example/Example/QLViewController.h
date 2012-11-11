//
//  QLViewController.h
//  Example
//
//  Created by Quang on 11/11/12.
//  Copyright (c) 2012 Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLCoverFlowPagesView.h"

@interface QLViewController : UIViewController <QLCoverFlowPagesViewDataSource>
@property (weak, nonatomic) IBOutlet QLCoverFlowPagesView *coverFlowView;

@end
