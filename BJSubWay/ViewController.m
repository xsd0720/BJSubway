//
//  ViewController.m
//  BJSubWay
//
//  Created by xwmedia01 on 2017/3/27.
//  Copyright © 2017年 xwmedia01. All rights reserved.
//

#import "ViewController.h"
#import "Dijkstra.h"
#import "NSDictionary+Category.h"
@interface ViewController ()

@property (nonatomic, strong) NSDictionary *subwayData;
@property (nonatomic, strong) NSArray *edgesData;

@property (nonatomic, strong) Dijkstra *dijkstra;

@property (nonatomic, strong) UITextField *sourceTextField;
@property (nonatomic, strong) UITextField *targetTextField;


@property (nonatomic, strong) UILabel *prompt;
@property (nonatomic, strong) UITextView *searchPathTextView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configDefine];
    
    [self configDataSource];
    [self setUpSubView];
   
    

    

}

- (void)configDefine
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configDataSource
{
    self.subwayData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"subwayData" ofType:@"json"]];
    self.edgesData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edgesData" ofType:@"json"]];
    
    self.dijkstra = [[Dijkstra alloc] init];
    [self.dijkstra configEdagesData:self.edgesData];
}

- (void)setUpSubView
{
    CGFloat width = self.view.frame.size.width/2.2;
    CGFloat margin = (CGRectGetMaxX(self.view.bounds)-width*2)/3;
    self.sourceTextField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 44, width, 44)];
    self.sourceTextField.placeholder = @"始发站";
    self.sourceTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.sourceTextField.layer.borderWidth = 1;
    self.sourceTextField.layer.cornerRadius = 3;
    [self.view addSubview:self.sourceTextField];
    
    
    self.targetTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sourceTextField.frame)+margin, 44, width, 44)];
    self.targetTextField.placeholder = @"终点站";
    self.targetTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.targetTextField.layer.borderWidth = 1;
    self.targetTextField.layer.cornerRadius = 3;
    [self.view addSubview:self.targetTextField];
    
    
    _prompt = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.targetTextField.frame)+5, CGRectGetMaxX(self.view.bounds), 30)];
    _prompt.font = [UIFont systemFontOfSize:14];
    _prompt.textColor = [UIColor blueColor];
    _prompt.textAlignment = NSTextAlignmentCenter;
    _prompt.text = @"里程: 票价:";
    [self.view addSubview:_prompt];
    
    
    UIButton *calButton = [UIButton buttonWithType:UIButtonTypeCustom];
    calButton.frame = CGRectMake(20, CGRectGetMaxY(self.targetTextField.frame)+44, CGRectGetMaxX(self.view.bounds)-40, 44);
    [calButton setTitle:@"计算" forState:UIControlStateNormal];
    calButton.layer.cornerRadius = 5;
    [calButton addTarget:self action:@selector(calButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    calButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:calButton];
    
    
    //显示路线
    _searchPathTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calButton.frame)+20, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds)-CGRectGetMaxX(self.view.bounds))];
    _searchPathTextView.userInteractionEnabled = NO;
    _searchPathTextView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_searchPathTextView];

    self.sourceTextField.text = @"望京东";
    self.targetTextField.text = @"天宫院";
}

- (void)calButtonPressed
{
    
    
    NSString *source = self.sourceTextField.text;
    NSString *target = self.targetTextField.text;
    
    if (source && source.length >0) {
        if (target && target.length >0) {
            
             [self.view endEditing:YES];
            
            float distance = [self.dijkstra shortestPath:source target:target]/1000.0;
            int fare = [self caleFare:distance];

            self.prompt.text = [NSString stringWithFormat:@"里程：%.2f公里  票价：%i元 \n", distance, fare];
            self.searchPathTextView.text = [NSString stringWithFormat:@"路线：\n%@", [self.dijkstra searchPath:source target:target]];
            
        }else
        {
            _prompt.text = @"请输入有效终点站";
        }
    }else
    {
        _prompt.text = @"请输入有效始发站";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (int)caleFare:(float)distance
{
    if (distance <=6) {
        return 3;
    }
    if (distance <=12) {
        return 4;
    }
    if (distance<=32) {
        return 4+ceil((distance-12)/10);
    }
    return 6+ceil((distance-32)/20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
