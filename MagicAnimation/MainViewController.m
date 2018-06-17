//
//  MainViewController.m
//  MagicAnimation
//
//  Created by 九尾 on 2018/6/16.
//  Copyright © 2018年 九尾. All rights reserved.
//

#import "MainViewController.h"

//Models
#import "ListItem.h"
#import "CommonDefine.h"
//Controllers
#import "MagicOneViewController.h"
#import "MagicTwoViewController.h"

#import "CAAnimation+keyName.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

static NSString *const mainCell = @"mainCell";

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CABasicAnimation *fd = [CABasicAnimation animation];
    fd.animationKey = @"fdafs";
    NSLog(@"我是:%@",fd.animationKey);
    
    [self.view addSubview:self.mainTableView];
    self.dataArr = [[NSMutableArray alloc] init];
    [self.dataArr addObject:[ListItem itemWithName:@"magic1" object:[MagicOneViewController class]]];
    [self.dataArr addObject:[ListItem itemWithName:@"magic2" object:[MagicTwoViewController class]]];
    
    if (@available(iOS 11,*)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    // Do any additional setup after loading the view.
}

#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainCell];
    }
    
    ListItem *model = self.dataArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"1. %@",model.title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListItem *model = self.dataArr[indexPath.row];
    UIViewController *itemc = [model.itemClass new];
    itemc.view.backgroundColor = [UIColor whiteColor];
    itemc.title = model.title;
    //    self.navigationController.hidesBarsOnSwipe = YES;
    [self.navigationController pushViewController:itemc animated:YES];
    
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mainTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
