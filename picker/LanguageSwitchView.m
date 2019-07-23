//
//  LanguageSwitchView.m
//  TranslateDemoIOS
//
//  Created by NTTData on 16/3/25.
//  Copyright © 2016年 NTTData. All rights reserved.
//

#import "LanguageSwitchView.h"

@implementation LanguageSwitchView
{
    UIToolbar *_topBar;
    NSMutableArray *_temporaryArr;
    UITapGestureRecognizer *_recognizer;
    UILabel *_titleLable;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (nonnull instancetype)initWithFrame:(CGRect)frame data:(nullable NSArray *)data pickerStyle:(LanguageSwitchViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
        // handleSwipeFrom 是偵測到手势，所要呼叫的方法
        _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [self addGestureRecognizer:_recognizer];
        
        _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
//        _picker.bounds = CGRectMake(0, 0, frame.size.width, 216);
//        _picker.center = CGPointMake(frame.size.width/2., frame.size.height/2.);
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.showsSelectionIndicator = YES;
        //自身代理方法
        _picker.delegate = self;
        //数据源代理
        _picker.dataSource = self;
        [self addSubview:_picker];
        self.style = style;
        self.data = data;
        
    }
    return self;
}

- (void)setStyle:(LanguageSwitchViewStyle)style {
    _style = style;
}

- (void)setData:(NSArray *)data {
    if (![_data isEqual:data] && data) {
        _data = data;
        if (!_temporaryArr) {
            _temporaryArr = [[NSMutableArray alloc] initWithCapacity:_data.count];
        } else {
            [_temporaryArr removeAllObjects];
        }
        for (int i=0; i<_data.count; i++) {
            [_temporaryArr addObject:_data[i][0]];
        }
        _selectData = _temporaryArr;
        
        [_picker reloadAllComponents];
        //[_picker selectRow:0 inComponent:0 animated:YES];
    }
}

- (void)setSelectData:(NSArray *)selectData {
    if (![_selectData isEqual:selectData]) {
        _selectData = selectData;
        _temporaryArr = [_selectData mutableCopy];
    }
    for (int i=0; i<_selectData.count; i++) {
        NSInteger Row = [self.data[i] indexOfObject:_selectData[i]];
        //自动选中行
        [_picker selectRow:Row inComponent:i animated:YES];
    }
    [_picker reloadAllComponents];
}

- (void)setIsBackgroundClick:(BOOL)isBackgroundClick {
    _isBackgroundClick = isBackgroundClick;
    if (!isBackgroundClick) {
        [self removeGestureRecognizer:_recognizer];
    } else {
        [self addGestureRecognizer:_recognizer];
    }
}

- (void)setIsShowToolBar:(BOOL)isShowToolBar {
    _isShowToolBar = isShowToolBar;
    if (isShowToolBar) {
        _topBar = [[UIToolbar alloc] init];
        _topBar.frame = CGRectMake(0, self.bounds.size.height - 216 - 34, self.bounds.size.width, 34);
        _topBar.backgroundColor = [UIColor lightGrayColor];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(chooseDone)];
        [doneBtn setTintColor:kColor_nav_title];
        _titleLable = [[UILabel alloc] init];
        _titleLable.bounds = CGRectMake(0, 0, 200, 34);
        _titleLable.center = CGPointMake(_topBar.bounds.size.width/2., _topBar.bounds.size.height/2.);
        _titleLable.textAlignment = 1;
        _titleLable.text = _title;
        [_topBar addSubview:_titleLable];
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(chooseCancle)];
        [cancleBtn setTintColor:kColor_nav_title];
        // 可拉伸的按钮
         UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        // 可拉伸的按钮
//        UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        fixed.width = 100;
        // 添加UIToolbar里面的按钮
        _topBar.items = @[cancleBtn, flexible, doneBtn];
        [self addSubview:_topBar];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (_titleLable) {
        _titleLable.text = title;
    }
}

#pragma mark --- PickerViewDelegate

//返回这个选择视图有多少分区
//NSInteger--对int类型的重定义，实质上还是一个int类型
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.data.count;
}
// returns the # of rows in each component..
//显示每个分区有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.data[component] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCR_W/self.data.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lab = (UILabel *)view;
    if (!lab) {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self pickerView:pickerView widthForComponent:component], [self pickerView:pickerView rowHeightForComponent:component])];
        lab.textAlignment = 1;
        lab.font = [UIFont systemFontOfSize:15.];
    }
    if (component == 1) {
        lab.text = [self.data[component][row] stringByAppendingString:@"点"];
    } else if (component == 2) {
        lab.text = [self.data[component][row] stringByAppendingString:@"分"];
    } else {
        lab.text = self.data[component][row];
    }
    return lab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableArray *arr = [_temporaryArr mutableCopy];
    arr[component] = _data[component][row];
    if (![self isAfterMinTime:arr] && self.minTime) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
        | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateCom = [calendar components:unit fromDate:self.minTime];
        NSString *h = [NSString stringWithFormat:@"%ld",dateCom.hour];
        NSString *m;
        if (dateCom.minute == 0) {
            m = @"00";
        } else if (dateCom.minute <= 10) {
            m = @"10";
        } else if (dateCom.minute <= 20) {
            m = @"20";
        } else if (dateCom.minute <= 30) {
            m = @"30";
        } else if (dateCom.minute <= 40) {
            m = @"40";
        } else if (dateCom.minute <= 50) {
            m = @"50";
        } else {
            m = @"00";
            h = [NSString stringWithFormat:@"%ld",dateCom.hour + 1];
        }
        NSDateComponents *newCom = [calendar components:unit fromDate:[NSDate date]];
        if (dateCom.day!=newCom.day) {
            self.selectData = @[@"明天", h, m];
        } else {
            self.selectData = @[@"今天", h, m];
        }
    } else {
        _temporaryArr[component] = _data[component][row];
        self.selectData = _temporaryArr;
    }
    
    
    if (self.delegate !=nil && ![self.delegate isKindOfClass:[NSNull class]] && [self.delegate respondsToSelector:@selector(LanguageSwitchView:changeValue:)]) {
        [self.delegate LanguageSwitchView:self changeValue:self.selectData];
    }
}

#pragma mark- -UITapGestureRecognizer-
- (void)handleTapFrom:(UITapGestureRecognizer *)sender {
    [self removeFromSuperview];
}

#pragma mark- -UIBarButtonItem- -click-
- (void)chooseCancle {
    if (self.delegate !=nil && ![self.delegate isKindOfClass:[NSNull class]] && [self.delegate respondsToSelector:@selector(cancelLanguageSwitchView:)]) {
        [self.delegate cancelLanguageSwitchView:self];
    }
}

- (void)chooseDone {
    if (self.delegate !=nil && ![self.delegate isKindOfClass:[NSNull class]] && [self.delegate respondsToSelector:@selector(LanguageSwitchView:doneSwith:)]) {
        [self.delegate LanguageSwitchView:self doneSwith:self.selectData];
    }
}

- (BOOL)isAfterMinTime:(NSArray *)selectData { // 是否小于最小时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:[NSDate date]];
    NSLog(@"[NSDate date]   === %@   -----",[NSDate date]);
    if ([selectData[0] isEqualToString:@"明天"]) {
        dateCom.day += 1;
    } else if ([selectData[0] isEqualToString:@"后天"]) {
        dateCom.day += 2;
    }
    dateCom.hour = [selectData[1] integerValue];
    dateCom.minute = [selectData[2] integerValue];
    dateCom.second = 0;
    NSInteger date = (NSInteger)[CPUtils dateTimeDifferenceWithStartTime:self.minTime endTime:[calendar dateFromComponents:dateCom]];
    return (date >= 0);
}

@end
