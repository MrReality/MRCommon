//
//  ViewController.m
//  ListView(下拉菜单栏)
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;

/// 下拉栏
@property (nonatomic, strong) MRListDownView *listView;
@property (nonatomic, strong) MRListDownView *listView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);
    [self.rightButton buttonActionWith:^(UIButton *button) {
        @strongify(self);
        [self.view addSubview:self.listView];
    }];
    
    [self.leftButton buttonActionWith:^(UIButton *button) {
        @strongify(self);
        [self.view addSubview:self.listView2];
    }];
}

// MARK: 懒加载 Lazy loading
- (MRListDownView *)listView{
    if(!_listView){
        // 创建下拉栏, 如果 images == nil, 则不显示照片栏, point 为起始点
        // Create a dropdown, if images == nil, Do not show photos section, Point as the starting point
        // 如果 point.x 小于屏幕宽的一半, 动画从左向右进行, 否则从右向左进行
        // If point.x is less than the half width of the screen, animation, from left to right or from right to left
        _listView = [[MRListDownView alloc] initWithOptions:@[@"dropdown", @"photos", @"starting", @"Create - Create - Create"] andImages:@[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"] andBeginPoint:CGPointMake(self.rightButton.centerX, self.rightButton.bottom + 5)];
        
        @weakify(self);
        // 选中选项调用的 block, Selected option call block
        [self.listView seletedWithBlock:^(NSInteger tag, NSInteger index) {
            @strongify(self);
            NSArray *array = @[@"dropdown", @"photos", @"starting", @"Create - Create - Create"];
            
            // 弹出一个只有一个选项的 UIAlertController, Pop up a UIAlertController only one option
            [MRCommonOther alertSingleWithTitle:@"" message:array[index] buttonName:@"OK" viewController:self OKBlock:^{
            }];
            // 关闭下拉栏 close the dropdown
            [self.listView closeView];
            self.listView = nil;
        }];
        
        // 点击阴影视图调用的 block,Click on view shadow call block
        [self.listView clickWithBlock:^{
            @strongify(self);
            // 关闭下拉栏 close the dropdown
            [self.listView closeView];
            self.listView = nil;
        }];
        
        // 设置下拉栏字体大小,     Set the dropdown font size,
        // 默认 15, The default is 15
        //        _listView.titleFont = 17;
        // 设置下拉栏图片宽度     Set dropdown image width
        // 默认 20 The default is 20
        //        _listView.imageWidth = 30;
        // 设置下拉栏图片位置 ListDownImgTypeLeft 为左边, ListDownImgTypeRight 为右边
        // Set the dropdown ListDownImgTypeLeft image location to the left, ListDownImgTypeRight to the right
        // 默认 左边 The default is left
        //        _listView.imageType = ListDownImgTypeLeft;
        // 设置字体颜色   Set the font color
        // 默认 棕黑色  The default is dark brown
        //        _listView.titleColor = [UIColor colorWithRed:0.00 green:0.76 blue:0.51 alpha:1.00];
        // 设置分割线的颜色    Set the color of the line
        // 默认 亮灰色 The default is Light grey
        //        _listView.lineColor = [UIColor colorWithRed:0.00 green:0.76 blue:0.51 alpha:1.00];
        // 设置下拉栏每行高度 Set the dropdown row height
        // 默认 40 The default is 40
        //        _listView.height = 50;
        // 设置下拉栏圆角  Set the dropdown rounded corners
        // 默认 3 The default is 3
        //        _listView.cornerRadius = 4;
        // 设置下拉栏颜色 Set the color dropdown   默认 白色 The default is white
        // _listView.listBackColor = [UIColor colorWithRed:0.00 green:0.50 blue:0.96 alpha:1.00];
    }
    return _listView;
}

- (MRListDownView *)listView2{
    if(!_listView2){
        
        _listView2 = [[MRListDownView alloc] initWithOptions:@[@"dropdown", @"photos", @"starting", @"Create"] andImages:@[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"] andBeginPoint:CGPointMake(self.leftButton.centerX, self.leftButton.bottom + 5)];
        _listView2.imageType = ListDownImgTypeRight;
        
        @weakify(self);
        // 选中选项调用的 block, Selected option call block
        [self.listView2 seletedWithBlock:^(NSInteger tag, NSInteger index) {
            @strongify(self);
            NSArray *array = @[@"dropdown", @"photos", @"starting", @"Create"];
            
            // 弹出一个只有一个选项的 UIAlertController, Pop up a UIAlertController only one option
            [MRCommonOther alertSingleWithTitle:@"" message:array[index] buttonName:@"OK" viewController:self OKBlock:^{
            }];
            // 关闭下拉栏 close the dropdown
            [self.listView2 closeView];
            self.listView2 = nil;
        }];
        
        // 点击阴影视图调用的 block,Click on view shadow call block
        [self.listView2 clickWithBlock:^{
            @strongify(self);
            // 关闭下拉栏 close the dropdown
            [self.listView2 closeView];
            self.listView2 = nil;
        }];
    }
    return _listView2;
}





@end
