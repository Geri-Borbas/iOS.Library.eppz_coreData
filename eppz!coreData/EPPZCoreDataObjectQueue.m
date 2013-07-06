//
//  EPPZCoreData.m
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZCoreDataObjectQueue.h"
#import "EPPZQueuedObject.h"


static NSString *const EPPZCoreDataObjectQueueDataModelFileName = @"EPPZCoreDataObjectQueue";
static NSString *const EPPZCoreDataObjectQueueDataModelFileExtension = @"momd";
static NSString *const EPPZCoreDataQueuedObjectEntityName = @"EPPZQueuedObject";
static NSString *const EPPZCoreDataStoreFileExtension = @"sqlite";


@interface EPPZCoreDataObjectQueue ()

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *name;
+(NSString*)name;

@end


@implementation EPPZCoreDataObjectQueue


#pragma mark - Creation

+(NSString*)name { return NSStringFromClass(self); } 
-(id)init
{
    if (self = [super init])
    {
        LOG_METHOD;        
        
        self.name = [[self class] name];
        
        //Model (description of entities within).
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:EPPZCoreDataObjectQueueDataModelFileName withExtension:EPPZCoreDataObjectQueueDataModelFileExtension];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        //Coordinator (connects the objects with the SQLite store).
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        //Context (where the entity objects live).
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        
        //Add store (SQLite).
        NSError *error;
        NSURL *documents = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documents URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", self.name, EPPZCoreDataStoreFileExtension]];
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:storeURL
                                                            options:nil error:&error];
        [self checkForError:error];
        
        //Fetch, unarchive queued object from CoreData.
        [self fetchQueueOnInit];
    }
    return self;
}

-(void)fetchQueueOnInit
{
    LOG_METHOD;
    
    //Entity.
    NSEntityDescription *entity = [NSEntityDescription entityForName:EPPZCoreDataQueuedObjectEntityName inManagedObjectContext:self.managedObjectContext];
  
    //Sort.
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:EPPZQueuedObjectSortingKey ascending:NO];

    //Request.
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    request.sortDescriptors = @[sortDescriptor];
    
    //Execute (assign to the queue).
    NSError *error;
    NSArray *queuedObjects = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    [self checkForError:error];
    
    //Unarchive objects.
    _queue = [NSMutableArray new];
    for (EPPZQueuedObject *eachQueuedObject in queuedObjects)
    {
        id eachUnarchivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:eachQueuedObject.archivedObject];
        [self.queue addObject:eachUnarchivedObject];
    }
}


#pragma mark - Hooks

-(void)applicationWillTerminate:(UIApplication*) application
{ [self save]; }

-(void)save
{
    LOG_METHOD;
    
    NSError *error;
    if ([self.managedObjectContext hasChanges])
        [self.managedObjectContext save:&error];
    [self checkForError:error];
}


#pragma mark - Features

-(NSUInteger)count
{ return self.queue.count; }

-(id)objectAtIndexedSubscript:(NSUInteger) index
{ return [self objectAtIndex:index]; }

-(void)setObject:(id) object atIndexedSubscript:(NSUInteger) index
{ /* Read only */ }

-(id)objectAtIndex:(NSUInteger) index
{
    if (self.queue != nil)
        if (self.queue.count > 0)
            return [self.queue objectAtIndex:index];
    return nil;
}

-(void)pushNewObject:(id<NSCoding>) object
{
    LOG_METHOD;    
    
    //Archive object.
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    //Add to queue.
    [self.queue addObject:object];
    
    //Add new entry to CoreData context then configure.
    EPPZQueuedObject *queuedObject = [NSEntityDescription insertNewObjectForEntityForName:EPPZCoreDataQueuedObjectEntityName
                                                                   inManagedObjectContext:self.managedObjectContext];
    queuedObject.creationDate = [NSDate date];
    queuedObject.archivedObject = archivedObject;
}

-(void)popFirstObject
{
    if (self.queue != nil)
        if (self.queue.count > 0)
            [self popObject:self.queue[0]];
}

-(void)popObject:(id<NSCoding>) object
{
    LOG_METHOD;    
    
    //Remove from queue.
    
    //Remove from context.   
}


#pragma mark - Errors

-(void)checkForError:(NSError*) error
{
    if (error != nil)
    {
        #warning Implement proper error dispatch for the clients.
        NSLog(@"Error: %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
