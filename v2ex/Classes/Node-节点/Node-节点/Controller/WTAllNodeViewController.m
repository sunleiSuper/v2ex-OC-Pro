//
//  WTAllNodeViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  所有节点的控制器

#import "WTAllNodeViewController.h"
#import "WTNodeViewModel.h"
#import "UIViewController+Extension.h"
#import "WTNodeTopicViewController.h"

NSString * const reuseIdentifier = @"reuseIdentifier";

@interface WTAllNodeViewController ()

@property (nonatomic, strong) NSMutableArray *datas;


@end

@implementation WTAllNodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 加载View
    [self setupView];
    
    // 加载数据
    [self setupData];
}

// 加载View
- (void)setupView
{
    if (self.didClickTitleBlock)    [self navViewWithCloseBtnAndTitle: @"选择节点"];
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: reuseIdentifier];
    
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.sectionHeaderHeight = 22;
    self.tableView.dk_sectionIndexBackgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    self.tableView.dk_sectionIndexColorPicker =  DKColorPickerWithKey(WTNodeSelectedColor);
    self.tableView.bounces = NO;
}

// 加载数据
- (void)setupData
{
    self.datas = [WTNodeViewModel queryAllNodeItemsFromCache];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *nodeItems = self.datas[section];
    return nodeItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewCellBgViewBackgroundColor);
    
    NSArray<WTNodeItem *> *nodeItems = self.datas[indexPath.section];
    cell.textLabel.text = nodeItems[indexPath.row].title;
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    
    label.text = WTIndexTitle[section];
    
    label.frame = CGRectMake(0, 0, WTScreenWidth, 20);
    
    label.dk_textColorPicker = DKColorPickerWithKey(WTTopicTitleColor);
    
    label.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray<WTNodeItem *> *nodeItems = self.datas[indexPath.section];
    WTNodeItem *nodeItem = nodeItems[indexPath.row];
    if (self.didClickTitleBlock)
    {
        self.didClickTitleBlock(nodeItem);
        [self dismissViewControllerAnimated: YES completion: nil];
    }
    else
    {
        WTNodeTopicViewController *nodeTopicVC = [WTNodeTopicViewController new];
        nodeTopicVC.nodeItem = nodeItem;
        [self.navigationController pushViewController: nodeTopicVC animated: YES];
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return WTIndexTitle;
}


@end
