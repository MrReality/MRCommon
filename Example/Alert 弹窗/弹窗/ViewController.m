//
//  ViewController.m
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "ViewController.h"
//#import "SnailPopupController.h"
#import "MRPopController.h"
#import "MRCommon.h"
#import "MRCurtainView.h"
#import "UIView+MRExtension.h"
#import "MRSiderBarView.h"
#import "MRFullView.h"

static NSString *ID = @"zxcvbndf";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 数据
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _initUI];
}

- (void)_initUI{

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

/// MARK: 创建两个按钮的弹窗
- (void)function0{

    MRAlertView *alertView = [[MRAlertView alloc] initWithTitle:@"提示" message:@"爱上的看法;楼的说法;zx.mv.zncvo" andWidth:290];
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
- (void)function1{
    
    MRAlertView *alertView = [[MRAlertView alloc] initWithTitle:@"提示啊;类似的看法哦阿斯顿发二娃" message:@"爱上的看"];
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
- (void)function2{
    
    MRCurtainView *curtainView = [[MRCurtainView alloc] init];
    curtainView.mr_width = [UIScreen mainScreen].bounds.size.width;

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
//    @weakify(self);
//    self.popController.maskTouched = ^(MRPopController * _Nonnull popupController) {
//        [weak_self.popController dismissWithDuration:0.25 elasticAnimated:NO];
//    };
    [self.popController presentContentView:curtainView duration:0.5 elasticAnimated:YES];

}

/// MARK: 侧拉一个 view, 类似与 MMDrawcontroller
- (void)function3{
    
    MRSiderBarView *sidebarView = [[MRSiderBarView alloc] init];
    sidebarView.mr_size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 90, [UIScreen mainScreen].bounds.size.height);
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
- (void)function4{
    
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
//        [fullView endAnimationsCompletion:^(MRFullView *fullView) {
//            [self.popController dismiss];
//        }];
    };
    
    self.popController = [[MRPopController alloc] init];
    self.popController.maskAlpha = .1;
    self.popController.maskType = PopMaskTypeWhiteBlur;
    self.popController.allowPan = YES;
    [self.popController presentContentView:fullView duration:.2 elasticAnimated:YES];
//    [self.popController presentContentView:fullView];
}

- (void)function5{
    
    
}

// MARK: tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *selName = [NSString stringWithFormat:@"function%ld", indexPath.row];
    SEL sel = NSSelectorFromString(selName);
    if([self respondsToSelector:sel]){      // 如果有这个方法
        [self performSelector:sel]; // 调用
    }
}


// MARK: 懒加载
- (NSMutableArray *)dataList{

    if(!_dataList){
        _dataList = @[@"侧面弹出弹窗带动画", @"中间弹出弹窗", @"QQ 空间式弹出框", @"类似 MMDrawController 弹窗", @"覆盖是弹出框, 带多个按钮可滑动", @"类似于分享的弹出框"].mutableCopy;
    }
    return _dataList;
}


@end
