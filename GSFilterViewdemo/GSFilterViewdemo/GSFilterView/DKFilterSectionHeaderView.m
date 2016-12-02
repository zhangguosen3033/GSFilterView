//
//  DKFilterSectionHeaderView.m
//  Partner
//
//

#import "DKFilterSectionHeaderView.h"

@implementation DKFilterSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSectionHeaderTitle:(NSString *)title{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil];
}
@end
