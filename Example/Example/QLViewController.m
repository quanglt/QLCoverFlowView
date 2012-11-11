//
//  QLViewController.m
//  Example
//
//  Created by Quang on 11/11/12.
//  Copyright (c) 2012 Quang. All rights reserved.
//

#import "QLViewController.h"

@interface QLViewController ()

@end

@implementation QLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.coverFlowView.dataSource = self;
    self.coverFlowView.showPageControl = YES;
    self.coverFlowView.scrollView.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QLCoverFlowPagesView datasource
- (NSInteger)coverFlowPagesView:(QLCoverFlowPagesView *)coverFlowPagesView numberOfPagesInSection:(NSInteger)section {
    return 10;
}
- (UIView *)coverFlowPagesView:(QLCoverFlowPagesView *)coverFlowPageView viewForPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *commentViewId = @"commentViewID";
    static NSString *pageViewId = @"imagePageViewID";
    if (indexPath.row == 3) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"CommentPageView" owner:self options:nil];
        QLPageView *view = [nibViews objectAtIndex:0];
        
        return view;
    }
    QLPageView *view = [coverFlowPageView dequeueReusablePageViewWithIdentifier:pageViewId];
    if (view == nil) {
        view = [[QLPageView alloc] initWithReuseIdentifier:pageViewId];
        view.enableReflection = YES;
    }
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"image-%d.png", indexPath.row]];
    return view;
}

@end
