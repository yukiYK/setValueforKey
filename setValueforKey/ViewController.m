//
//  ViewController.m
//  setValueforKey
//
//  Created by APiX on 2017/10/17.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "ViewController.h"
#import "AuthenticationModel.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ViewController
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupTableView];
    [self fillData];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)fillData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers) error:nil];
    
    [AuthenticationModel analysisAuthentication:dic];
    
    for (NSString *property in [AuthenticationModel getAllProperties]) {
        NSString *str = [NSString stringWithFormat:@"%@ = %@", property, [[AuthenticationModel sharedModel] valueForKey:property]];
        NSLog(@"%@", str);
        
        [self.dataArr addObject:str];
    }
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

@end
