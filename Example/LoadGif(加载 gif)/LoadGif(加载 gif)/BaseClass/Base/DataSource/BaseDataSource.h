//
//  BaseDataSource.h
//  面向协议+MVVM+RAC 普通网络请求
//
//  Created by Mac on 2017/12/8.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

///  封装好的 DataSource，旨在将 DataSource 从 ViewController 中分离开，做到单一职责.
/// 获取 cell ID 的 block, param 传入的参数, 返回 cell 的 id
typedef  NSString * _Nonnull  (^DataSourceIDMakerBlock) (NSIndexPath * _Nonnull indexPath, id _Nullable param);
/// 刷新的 block, cell 实现 RefreshInterface 接口的 cell, param 传入的参数
typedef void (^DataSourceRefreshBlock) (NSIndexPath * _Nonnull indexPath, UITableViewCell *_Nonnull cell, id _Nullable param);


/// MARK: 处理 dataSource 数据的基类
@interface BaseDataSource : NSObject <UITableViewDataSource>

/// tableView
@property (nonatomic, weak, nullable) UITableView *tableView;
/// 数据源
@property (nonatomic, strong, nullable) NSArray <NSArray *> *dataList;
/// header 标题数组
@property (nonatomic, strong, nullable) NSArray <NSString *> *headerArray;
/// footer 标题数组
@property (nonatomic, strong, nullable) NSArray <NSString *> *footerArray;

/// 生成 id 的 block
@property (nonatomic, copy, nonnull) DataSourceIDMakerBlock idMakerBlock;
/// 刷新的 block
@property (nonatomic, copy, nonnull) DataSourceRefreshBlock refreshBlock;

/// 创建 UI, 不用重写 init 方法了
- (void)_initUI;

/// 根据 ID 等参数创建 dataSource 的方法
/**
 @param ID                        id
 @param tableView            tableView
 @param dataList               数据源
 @param refreshingblock    刷新的 block
 */
- (nonnull instancetype)initWithID:(nonnull NSString *)ID  tableView:(nonnull UITableView *)tableView dataList:(nullable NSArray<NSArray *> *)dataList refreshingBlock:(nullable DataSourceRefreshBlock)refreshingblock;

/// 最简单的创建 dataSource 的方法
/**
 @param tableView           tableView
 @param dataList              数据源
 @param idBlock                获取 id 的 block
 @param refreshingblock    刷新的 block
 */
- (nonnull instancetype)initWithTableView:(nonnull UITableView *)tableView dataList:(nullable NSArray<NSArray *> *)dataList idBlock: (nonnull DataSourceIDMakerBlock)idBlock refreshingBlock:(nullable DataSourceRefreshBlock)refreshingblock;

// 最完整的创建 dataSource 的方法
/**
 创建 dataSource 的方法
 @param tableView           tableView
 @param dataList              数据源
 @param headers              header 标题数组
 @param footers                footer  标题数组
 @param idBlock                获取 id 的block
 @param refreshingblock   刷新的 block
 */
- (nonnull instancetype)initBaseObjectWithTableView:(nonnull UITableView *)tableView dataList:(nullable NSArray<NSArray *> *)dataList headers:(nullable NSArray<NSString *> *)headers footers:(nullable NSArray<NSString *> *)footers idBlock: (nonnull DataSourceIDMakerBlock)idBlock refreshingBlock:(nullable DataSourceRefreshBlock)refreshingblock;

/// 更新数据源
- (void)refreshWithNewDataList:(nonnull NSArray<NSArray *> *)dataList;

- (void)refreshWithNewDataList:(nonnull NSArray<NSArray *> *)dataList sections:(nonnull NSIndexSet *)sections animation:(UITableViewRowAnimation)flag;

- (void)refreshWithNewDataList:(nonnull NSArray<NSArray *> *)dataList indexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths animation:(UITableViewRowAnimation)flag;

@end
