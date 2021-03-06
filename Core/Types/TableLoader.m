//
//  Created by Rene Dohan on 1/11/13.
//


#import "TableLoader.h"
#import "Response.h"
#import "CSPullToRefreshView.h"

@implementation TableLoader {
    UIView *_loadNextIndicator;
    NSMutableArray *_data;
    BOOL _noNext;
    BOOL _loading;
}

- (TableLoader *)from:(UITableView *)table :(UIView *)loadNextIndicator :(NSMutableArray *)data {
    _table = table;
    _table.visible = YES;
    _loadNextIndicator = loadNextIndicator;
    _loadNextIndicator.hidden = YES;
    _data = data;
    _refreshHeaderView = [[CSPullToRefreshView alloc] initWithScrollView:_table];
    _refreshHeaderView.delegate = self;
    [_table addSubview:_refreshHeaderView];
    return self;
}

- (void)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldLoadNext:indexPath]) [self loadNext];
}


- (void)loadNext {
    [_loadNextIndicator fadeIn];
    _loading = YES;
    _onLoadNext().onDone = ^{
        [self onDone];
        [_loadNextIndicator fadeOut];
    };
}

- (BOOL)shouldLoadNext:(NSIndexPath *)indexPath {
    if (_loading)return NO;
    return !_noNext && indexPath.row > _data.count - 5;
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [self reload];
}

- (void)reload {
    self.emptyLabel.visible = NO;
    _noNext = NO;
    _loading = YES;
    Response *response = self.onReload();
    if (_table.hidden) [_table.superview showProgress:response];
    response.onDone = ^{
        [self onDone];
    };
}

- (void)setEmptyLabel:(UIView *)emptyLabel {
    _emptyLabel = emptyLabel;
    _emptyLabel.visible = NO;
}

- (void)onDone {
    _loading = NO;
    [self updateEmpty];
    [_refreshHeaderView refreshLastUpdatedDate];
    [_refreshHeaderView finishedLoading];
}

- (void)updateEmpty {
    _emptyLabel.fadeVisible = _data.empty;
    _emptyLabel.userInteractionEnabled = NO;
}

- (void)onReloadSuccess:(NSArray *)array {
    [_data replaceFromArray:array];
    [self onLoadSuccess:array];
}

- (void)onLoadSuccess:(NSArray *)array {
    _noNext = array.count == 0;
    [_table reloadData];
    [self updateEmpty];
}

- (void)viewWillAppear {
    [_table deselectRowAtIndexPath:_table.indexPathForSelectedRow animated:YES];
    [_table reloadData];
}

- (void)addItem:(id)item {
    [_data addObject:item];
    [_table reloadData];
    [self updateEmpty];
}

- (void)insertItem:(id)item :(int)index {
    [_data insertObject:item atIndex:(uint) index];
    [_table reloadData];
    [self updateEmpty];
}

- (void)removeItem:(id)item {
    [_data removeObject:item];
    [_table reloadData];
    [self updateEmpty];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [_data removeObjectAtIndex:index];
    [_table reloadData];
    [self updateEmpty];
}
@end