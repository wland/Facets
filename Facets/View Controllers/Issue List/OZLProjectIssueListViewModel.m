//
//  OZLProjectIssueListViewModel.m
//  Facets
//
//  Created by Justin Hill on 11/4/15.
//  Copyright © 2015 Justin Hill. All rights reserved.
//

#import "OZLProjectIssueListViewModel.h"
#import "OZLModelIssue.h"
#import "OZLNetwork.h"

@interface OZLProjectIssueListViewModel ()

@property NSMutableArray *issues;
@property RLMResults *projects;
@property BOOL moreIssuesAvailable;
@property BOOL isLoading;

@end

@implementation OZLProjectIssueListViewModel

@synthesize delegate;
@synthesize sortAndFilterOptions = _sortAndFilterOptions;
@synthesize projectId = _projectId;
@synthesize title;
@synthesize issues;
@synthesize projects;

- (instancetype)init {
    if (self = [super init]) {
        self.sortAndFilterOptions = [[OZLSortAndFilterOptions alloc] init];
        self.moreIssuesAvailable = YES;
    }
    
    return self;
}

- (BOOL)shouldShowComposeButton {
    return YES;
}

- (BOOL)shouldShowProjectSelector {
    return YES;
}

- (void)refreshProjectList {
    self.projects = [[OZLModelProject allObjects] sortedResultsUsingProperty:@"name" ascending:YES];
}

- (NSString *)title {
    return [OZLModelProject objectForPrimaryKey:@(self.projectId)].name;
}

- (void)setTitle:(NSString *)title {
    NSAssert(NO, @"This issue list view model doesn't support setting a custom title");
}

- (void)setProjectId:(NSInteger)projectId {
    if (projectId != _projectId) {
        self.issues = [NSMutableArray array];
        [OZLSingleton sharedInstance].currentProjectID = projectId;
    }
    
    _projectId = projectId;
}

- (void)setSortAndFilterOptions:(OZLSortAndFilterOptions *)sortAndFilterOptions {
    if (![sortAndFilterOptions isEqual:self.sortAndFilterOptions]) {
        self.issues = [NSMutableArray array];
    }
    
    _sortAndFilterOptions = sortAndFilterOptions;
}

- (void)loadIssuesCompletion:(void (^)(NSError *error))completion {
    
    __weak OZLProjectIssueListViewModel *weakSelf = self;
    
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    
    NSDictionary *params = [self.sortAndFilterOptions requestParameters];

    // load issues
    [[OZLNetwork sharedInstance] getIssueListForProject:weakSelf.projectId offset:0 limit:25 params:params completion:^(NSArray *result, NSInteger totalCount, NSError *error) {
        
        weakSelf.isLoading = NO;
        
        if (error) {
            NSLog(@"error getIssueListForProject: %@", error.description);
            completion(error);
            
        } else {
            weakSelf.issues = [result mutableCopy];
            weakSelf.moreIssuesAvailable = (weakSelf.issues.count < totalCount);
            completion(nil);
        }
    }];
}

- (void)loadMoreIssuesCompletion:(void(^)(NSError *error))completion {
    
    __weak OZLProjectIssueListViewModel *weakSelf = self;
    
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    
    NSDictionary *params = [self.sortAndFilterOptions requestParameters];
    
    [[OZLNetwork sharedInstance] getIssueListForProject:weakSelf.projectId offset:self.issues.count limit:25 params:params completion:^(NSArray *result, NSInteger totalCount, NSError *error) {
        
        weakSelf.isLoading = NO;
        
        if (error) {
            NSLog(@"error getIssueListForProject: %@", error.description);
            completion(error);
            
        } else {
            [weakSelf.issues addObjectsFromArray:result];
            weakSelf.moreIssuesAvailable = (weakSelf.issues.count < totalCount);
            completion(nil);
        }
    }];
}

- (void)deleteIssueAtIndex:(NSInteger)index completion:(void (^)(NSError *))completion {
    NSAssert(index >= 0 && index < self.issues.count, @"index out of range");
    
    OZLModelIssue *issue = self.issues[index];
    
    __weak OZLProjectIssueListViewModel *weakSelf = self;
    [[OZLNetwork sharedInstance] deleteIssue:issue.index withParams:nil completion:^(BOOL success, NSError *error) {
        if (completion) {
            if (error) {
                completion(error);
                
            } else {
                [weakSelf.issues removeObjectAtIndex:index];
            }
        }
    }];
}

- (void)processUpdatedIssue:(OZLModelIssue *)issue {
    NSInteger issueIndex = [self.issues indexOfObjectPassingTest:^BOOL(OZLModelIssue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return (issue.index == obj.index);
    }];
    
    if (issueIndex != NSNotFound) {
        [self.issues replaceObjectAtIndex:issueIndex withObject:issue];
        [self.delegate viewModelIssueListContentDidChange:self];
    }
}

#pragma mark - OZLQuickAssignDelegate
- (void)quickAssignController:(OZLQuickAssignViewController *)quickAssign didChangeAssigneeInIssue:(OZLModelIssue *)issue from:(OZLModelUser *)from to:(OZLModelUser *)to {
    [self processUpdatedIssue:issue];
}

@end
