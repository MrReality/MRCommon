//
//  ViewController.m
//  Alert(弹出框)
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"
#import "MRPopController.h"
#import "MRCurtainView.h"
#import "MRSiderBarView.h"
#import "MRFullView.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

/// tableView
@property (nonatomic, strong, nullable) UITableView *tableView;
/// 数据源
@property (nonatomic, strong, nullable) NSArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 创建 UI
    [self _initUI];
}

/// MARK: 创建 UI
- (void)_initUI{
    [self.view addSubview:self.tableView];
}

/// MARK: 创建两个按钮的弹窗
- (void)func0{
    MRAlertView *alertView = [[MRAlertView alloc] initWithTitle:@"提示" message:@"这是一个提示" andWidth:290];
    alertView.lineColor = [UIColor colorWithRed:0.23 green:0.80 blue:0.42 alpha:1.00];
    alertView.isLineHidden = YES;
    
    /// 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.96 green:0.56 blue:0.40 alpha:1.00] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    @weakify(self);
    [cancelButton tapActionWithBlock:^{
        @strongify(self);
        [self.popController dismiss];          // 让弹窗消失
    }];
    
    /// 确认按钮
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitleColor:[UIColor colorWithRed:0.96 green:0.56 blue:0.40 alpha:1.00] forState:UIControlStateNormal];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton tapActionWithBlock:^{
        @strongify(self);
        [self.popController dismiss];
    }];
    
    /// 添加按钮
    [alertView addCancelButton:cancelButton andOKButton:okButton];
    
    /// 配置设置
    self.popController = [MRPopController new];
    self.popController.transitStyle = PopTransitStyleFromTop;
    self.popController.dropTransitionAnimated = YES;
    self.popController.allowPan = YES;
    [self.popController presentContentView:alertView duration:0.5 elasticAnimated:YES];
}

/// MARK: 创建一个按钮的弹窗
- (void)func1{
    
    MRAlertView *alertView = [[MRAlertView alloc] initWithTitle:@"提示啊" message:@"这是一个提示"];
    alertView.lineColor = [UIColor colorWithRed:0.23 green:0.80 blue:0.42 alpha:1.00];
    //    alertView.isLineHidden = YES;
    
    /// 确认按钮
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitleColor:[UIColor colorWithRed:0.96 green:0.56 blue:0.40 alpha:1.00] forState:UIControlStateNormal];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    @weakify(self);
    [okButton tapActionWithBlock:^{
        @strongify(self);
        [self.popController dismiss];
    }];
    
    /// 添加按钮
    [alertView addSignalButton:okButton];
    
    /// 配置设置
    self.popController = [MRPopController new];
    self.popController.transitStyle = PopTransitStyleShrinkInOut;
    self.popController.dropTransitionAnimated = YES;
    [self.popController presentContentView:alertView duration:0.5 elasticAnimated:YES];
}

/// MARK: 类似 QQ 空间式 窗帘弹窗
- (void)func2{
    
    MRCurtainView *curtainView = [[MRCurtainView alloc] init];
    curtainView.width = [UIScreen mainScreen].bounds.size.width;
    
    [curtainView.closeButton setImage:[UIImage imageNamed:@"qzone_close"] forState:UIControlStateNormal];
    NSArray *imageNames = @[@"说说", @"照片", @"视频", @"签到", @"大头贴"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:imageNames.count];
    for (NSString *imageName in imageNames) {
        UIImage *image = [UIImage imageNamed:[@"qzone_" stringByAppendingString:imageName]];
        [models addObject:[MRIconLabelModel modelWithTitle:imageName image:image]];
    }
    curtainView.models = models;
    
    /// 点击关闭按钮
    [curtainView tapCloseButton:^(UIButton *button) {
        
        [self.popController dismissWithDuration:.25 elasticAnimated:YES];
    }];
    
    /// 点击其他按钮
    [curtainView tapItem:^(MRCurtainView *curtainView, NSInteger index) {
        NSLog(@"index --> %ld", index);
    }];
    
    self.popController = [[MRPopController alloc] init];
    self.popController.locationType = PopLocationTypeTop;
    self.popController.allowPan = YES;
    [self.popController presentContentView:curtainView duration:0.5 elasticAnimated:YES];
}

/// MARK: 侧拉一个 view, 类似与 MMDrawcontroller
- (void)func3{
    
    MRSiderBarView *sidebarView = [[MRSiderBarView alloc] init];
    sidebarView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 90, [UIScreen mainScreen].bounds.size.height);
    sidebarView.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
    sidebarView.models = @[@"我的故事", @"消息中心", @"我的收藏", @"近期阅读", @"离线阅读"];
    
    [sidebarView tapItem:^(MRSiderBarView *siderBarView, NSInteger index) {
        [self.popController dismiss];
        NSLog(@"index --> %ld", index);
    }];
    
    self.popController = [[MRPopController alloc] init];
    self.popController.locationType = PopLocationTypeRight;
    self.popController.allowPan = YES;
    [self.popController presentContentView:sidebarView];
}

/// MARK: 铺满全屏的弹框
- (void)func4{
    \
    MRFullView *fullView = [[MRFullView alloc] initWithFrame:self.view.frame];
    
    NSArray *array = @[@"文字", @"照片视频", @"头条文章", @"红包", @"直播", @"点评", @"好友圈", @"更多", @"音乐", @"商品", @"签到", @"秒拍", @"头条文章", @"红包", @"直播", @"点评"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array) {
        MRIconLabelModel *item = [[MRIconLabelModel alloc] init];
        item.icon = [UIImage imageNamed:[NSString stringWithFormat:@"sina_%@", string]];
        item.text = string;
        [models addObject:item];
    }
    fullView.models = models;
    
    fullView.didClickFullView = ^(MRFullView * _Nonnull fullView) {
        [self.popController dismiss];
    };
    
    fullView.didClickItems = ^(MRFullView *fullView, NSInteger index) {
        NSLog(@"index --> %ld", index);
        [self.popController dismiss];
    };
    
    self.popController = [[MRPopController alloc] init];
    self.popController.maskAlpha = .1;
    self.popController.maskType = PopMaskTypeWhiteBlur;
    self.popController.allowPan = YES;
    [self.popController presentContentView:fullView duration:.2 elasticAnimated:YES];
}

/// MARK: tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell name] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

/// MARK: tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *func = [NSString stringWithFormat:@"func%ld", indexPath.row];
    SEL sel = NSSelectorFromString(func);
    if([self respondsToSelector:sel])
       [self performSelector:sel];
}

/// MARK: 懒加载
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell name]];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)dataList{
    if(!_dataList){
        _dataList = @[@"侧面弹出弹窗带动画", @"中间弹出弹窗", @"QQ 空间式弹出框", @"类似 MMDrawController 弹窗", @"覆盖是弹出框, 带多个按钮可滑动"];
    }
    return _dataList;
}




@end
