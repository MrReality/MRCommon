//
//  BaseDataSource.m
//  面向协议+MVVM+RAC 普通网络请求
//
//  Created by Mac on 2017/12/8.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BaseDataSource.h"
#import "RefreshInterface.h"

@interface BaseDataSource ()

@end

@implementation BaseDataSource

- (void)dealloc{
    NSLog(@"%@ --> 💤 delloc", NSStringFromClass([self class]));
}

/// MARK: 创建 dataSource 的方法 1
- (nonnull instancetype)initWithID:(nonnull NSString *)ID  tableView:(nonnull UITableView *)tableView dataList:(nullable NSArray<NSArray *> *)dataList refreshingBlock:(nullable DataSourceRefreshBlock)refreshingblock{
    /// 返回 id 的 block
    DataSourceIDMakerBlock idBlock = ^(NSIndexPath * _Nonnull indexPath, id _Nullable param) {
        return ID;
    };
    return [self initWithTableView:tableView dataList:dataList idBlock:idBlock refreshingBlock:refreshingblock];
}

/// MARK: 创建 dataSource 的方法 2
- (nonnull instancetype)initWithTableView:(nonnull UITableView *)tableView dataList:(nullable NSArray<NSArray *> *)dataList idBlock: (nonnull DataSourceIDMakerBlock)idBlock refreshingBlock:(nullable DataSourceRefreshBlock)refreshingblock{
    return [self initBaseObjectWithTableView:tableView dataList:dataList headers:nil footers:nil idBlock:idBlock refreshingBlock:refreshingblock];
}

// MARK: 最完整的方法
- (nonnull instancetype)initBaseObjectWithTableView:(nonnull UITableView *)tableView dataList:(nullable NSArray<NSArray *> *)dataList headers:(nullable NSArray<NSString *> *)headers footers:(nullable NSArray<NSString *> *)footers idBlock: (nonnull DataSourceIDMakerBlock)idBlock refreshingBlock:(nullable DataSourceRefreshBlock)refreshingblock{
    if(self = [super init]){
        /// 配置各属性
        self.idMakerBlock = idBlock;
        if(refreshingblock)
            self.refreshBlock = refreshingblock;
        self.tableView = tableView;
        self.headerArray = headers.copy;
        self.footerArray = footers.copy;
        if(dataList)                 /// 如果有数据源
            self.dataList = dataList.copy;
        else                            /// 如果没有数据源
            self.dataList = @[];
        [self _initUI];
    }
    return self;
}

/// MARK: 更新数据源
- (void)refreshWithNewDataList:(nonnull NSArray<NSArray *> *)dataList{
    self.dataList = dataList.copy;
    [self.tableView reloadData];
}

- (void)refreshWithNewDataList:(nonnull NSArray<NSArray *> *)dataList sections:(nonnull NSIndexSet *)sections animation:(UITableViewRowAnimation)flag{
    self.dataList = dataList.copy;
    [self.tableView reloadSections:sections withRowAnimation:flag];
}

- (void)refreshWithNewDataList:(nonnull NSArray<NSArray *> *)dataList indexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths animation:(UITableViewRowAnimation)flag{
    self.dataList = dataList.copy;
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:flag];
}

/// MARK: 创建 UI, 不用重写 init 方法了
- (void)_initUI{
    
}

/// MARK: tableView dataSource
/// section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
/// row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
/// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
/// header title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}
/// footer title
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}


@end
