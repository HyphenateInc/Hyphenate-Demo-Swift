//
//  MJRefreshAutoStateFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//

#import "MJRefreshAutoStateFooter.h"

@interface MJRefreshAutoStateFooter()
{
    __unsafe_unretained UILabel *_stateLabel;
}

@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@end

@implementation MJRefreshAutoStateFooter

- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (void)stateLabelClick
{
    if (self.state == MJRefreshStateIdle) {
        [self beginRefreshing];
    }
}

- (void)prepare
{
    [super prepare];
    
    [self setTitle:MJRefreshAutoFooterIdleText forState:MJRefreshStateIdle];
    [self setTitle:MJRefreshAutoFooterRefreshingText forState:MJRefreshStateRefreshing];
    [self setTitle:MJRefreshAutoFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
    
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (self.isRefreshingTitleHidden && state == MJRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}
@end