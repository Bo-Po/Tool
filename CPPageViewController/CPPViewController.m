//
//  CPViewController.m
//  OCTest
//
//  Created by 陈波 on 2019/7/24.
//  Copyright © 2019 陈波. All rights reserved.
//

#import "CPPViewController.h"

@interface CPPViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic) UIPageViewController *pageViewController;

@end

@implementation CPPViewController

- (instancetype)init {
    if (self = [super init]) {
        self.pageStyle = UIPageViewControllerTransitionStyleScroll;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjects:@[[NSNumber numberWithInteger:self.pageSpacing], [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid]] forKeys:@[UIPageViewControllerOptionInterPageSpacingKey, UIPageViewControllerOptionSpineLocationKey]];
        // [NSMutableDictionary dictionaryWithObjects:@[[NSNumber numberWithInteger:self.pageSpacing], [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid]] forKeys:@[UIPageViewControllerOptionInterPageSpacingKey, UIPageViewControllerOptionSpineLocationKey] count:2];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:self.pageStyle navigationOrientation:self.navigationOrientation options:options];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self addChildViewController:_pageViewController];
        _pageViewController.view.frame = self.view.bounds;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    NSInteger num = 1;
    if (self.pageStyle == UIPageViewControllerTransitionStylePageCurl) {
        num = 2;
    }
    NSArray *controller = nil;
    if (_viewControllers.count>num) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:num];
        for (NSInteger i = 0; i < num; i++) {
            [arr addObject:_viewControllers[i]];
        }
        controller = arr;
    } else {
        controller = _viewControllers;
    }
    [self.pageViewController setViewControllers:controller direction:(UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSLog(@"后一个视图控制器");
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == self.viewControllers.count - 1 || (index == NSNotFound)) {
        return nil;
    }
    index++;
    
    return [self.viewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSLog(@"前一个视图控制器");
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    index--;
    
    return [self.viewControllers objectAtIndex:index];
}

@end
