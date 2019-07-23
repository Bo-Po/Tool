//
//  CPPickerView.m
//  test
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 bo. All rights reserved.
//  地址选择器

#import "CPPickerView.h"

@interface CPPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy, nonnull) NSArray *regions;  // 源数据
@property (nonatomic, copy, nonnull) NSMutableArray *provinceList;  // 省
@property (nonatomic, copy, nonnull) NSMutableArray *cityList;  // 市
@property (nonatomic, copy, nonnull) NSMutableArray *areaList;  // 区/县
/** 选中的省 */
@property(nonatomic, strong) CPProvinceModel *selectProvinceModel;
/** 选中的市 */
@property(nonatomic, strong) CPCityModel *selectCityModel;
/** 选中的区 */
@property(nonatomic, strong) CPAreaModel *selectAreaModel;

@end

@implementation CPPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setFrame:frame];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0. alpha:.3657];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPickerView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat y = 0;
    CGFloat h = 0;
    if (frame.size.height < 216.) {
        y = 0;
        h = frame.size.height;
//        self.pickerView.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        self.pickerView.center = CGPointMake(frame.size.width/2., frame.size.height/2.);
    } else {
        y = frame.size.height-216;
        h = 216;
//        self.pickerView.frame = CGRectMake(0, frame.size.height-216, frame.size.width, 216);
    }
    self.pickerView.frame = CGRectMake(0, y, frame.size.width, h);
}
- (void)setDataSource:(nonnull NSArray *)source {
    self.regions = source;
    
    NSMutableArray *tempArr1 = [NSMutableArray array];
    for (NSDictionary *proviceDic in source) {
        CPProvinceModel *proviceModel = [[CPProvinceModel alloc]init];
        proviceModel.code = proviceDic[kAddressCode];
        proviceModel.name = proviceDic[kAddressName];
        proviceModel.index = [source indexOfObject:proviceDic];
        NSArray *citylist = proviceDic[kAddressCitylist];
        NSMutableArray *tempArr2 = [NSMutableArray array];
        for (NSDictionary *cityDic in citylist) {
            CPCityModel *cityModel = [[CPCityModel alloc]init];
            cityModel.code = cityDic[kAddressCode];
            cityModel.name = cityDic[kAddressName];
            cityModel.index = [citylist indexOfObject:cityDic];
            NSArray *arealist = cityDic[kAddressArealist];
            NSMutableArray *tempArr3 = [NSMutableArray array];
            for (NSDictionary *areaDic in arealist) {
                CPAreaModel *areaModel = [[CPAreaModel alloc]init];
                areaModel.code = areaDic[kAddressCode];
                areaModel.name = areaDic[kAddressName];
                areaModel.index = [arealist indexOfObject:areaDic];
                [tempArr3 addObject:areaModel];
            }
            cityModel.arealist = [tempArr3 copy];
            [tempArr2 addObject:cityModel];
        }
        proviceModel.citylist = [tempArr2 copy];
        [tempArr1 addObject:proviceModel];
    }
    
    [self.provinceList removeAllObjects];
    [self.provinceList addObjectsFromArray:[tempArr1 copy]];
    
    //设置默认选中的
    self.selectProvinceModel = self.provinceList.firstObject;
    self.selectCityModel = self.selectProvinceModel.citylist.firstObject;
    self.selectAreaModel = self.selectCityModel.arealist.firstObject;
    
    [self.cityList removeAllObjects];
    [self.areaList removeAllObjects];
    
    [self.cityList addObjectsFromArray:self.selectProvinceModel.citylist];
    [self.areaList addObjectsFromArray:self.selectCityModel.arealist];
    
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
    [self.pickerView selectRow:0 inComponent:2 animated:YES];
}
- (void)show {
    [self showToView:nil];
}
- (void)showToView:(UIView *)view {
    if (view) {
        [UIView animateWithDuration:0.2 animations:^{
            [view addSubview:self];
        }];
    } else {
        UIWindow *mainWindow = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
            mainWindow = [[UIApplication sharedApplication].windows firstObject];
        } else {
            mainWindow = [[UIApplication sharedApplication].windows lastObject];
        }
        [UIView animateWithDuration:0.2 animations:^{
            [mainWindow addSubview:self];
        }];
    }
    if (self.changeEnd) {
        self.changeEnd(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
    }
}
#pragma mark- -UIPickerViewDelegate, UIPickerViewDataSource-
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 3;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceList.count;
    } else if (component == 1) {
        return [self.cityList count];
    } else {
        return self.areaList.count;
    }
    return 5;
}

-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        CPProvinceModel *province = [self.provinceList objectAtIndex:row];
//        _selectProvinceId = province.code;
        return province.name;
    } else if (component == 1) {
        CPCityModel *city = [self.cityList objectAtIndex:row];
//        _selectCityId = city.code;
        return city.name;
    } else {
        CPAreaModel *area = [self.areaList objectAtIndex:row];
//        _selectAreaId = area.code;
        return area.name;
    }
    return @"每一行要显示的内容";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectProvinceModel = [self.provinceList objectAtIndex:row];
//        _selectProvinceId = province.code;
        [self.cityList removeAllObjects];
        [self.cityList addObjectsFromArray:self.selectProvinceModel.citylist];
        self.selectCityModel = self.cityList.firstObject;
        [self.areaList removeAllObjects];
        [self.areaList addObjectsFromArray:self.selectCityModel.arealist];
        self.selectAreaModel = self.areaList.firstObject;
    } else if (component == 1) {
        self.selectCityModel = [self.cityList objectAtIndex:row];
        [self.areaList removeAllObjects];
        [self.areaList addObjectsFromArray:self.selectCityModel.arealist];
        self.selectAreaModel = self.areaList.firstObject;
    } else {
        self.selectAreaModel = [self.areaList objectAtIndex:row];
    }
    [pickerView reloadAllComponents];
    [pickerView selectRow:self.selectCityModel.index inComponent:1 animated:YES];
    [pickerView selectRow:self.selectAreaModel.index inComponent:2 animated:YES];
    if (self.changeEnd) {
        self.changeEnd(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
    }
}

- (void)dismissPickerView {
    [UIView animateWithDuration:0.2 animations:^{
        [self removeFromSuperview];
    }];
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216);
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
    }
    return _pickerView;
}
- (NSMutableArray *)provinceList{
    if (!_provinceList) {
        _provinceList = [NSMutableArray new];
    }
    return _provinceList;
}
- (NSMutableArray *)cityList{
    if (!_cityList) {
        _cityList = [NSMutableArray new];
    }
    return _cityList;
}
- (NSMutableArray *)areaList{
    if (!_areaList) {
        _areaList = [NSMutableArray new];
    }
    return _areaList;
}

@end


@implementation CPProvinceModel

- (id)copyWithZone:(NSZone *)zone{
    CPProvinceModel * model = [[CPProvinceModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    CPProvinceModel * model = [[CPProvinceModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
@end


@implementation CPCityModel
- (id)copyWithZone:(NSZone *)zone{
    CPCityModel * model = [[CPCityModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    CPCityModel * model = [[CPCityModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
@end


@implementation CPAreaModel
- (id)copyWithZone:(NSZone *)zone{
    CPAreaModel * model = [[CPAreaModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    CPAreaModel * model = [[CPAreaModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
@end
