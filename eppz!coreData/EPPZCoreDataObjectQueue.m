//
//  EPPZCoreData.m
//  eppz!tools
//
//  Created by Borbás Geri on 7/7/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZCoreDataObjectQueue.h"
#import "EPPZQueuedObject.h"


static NSString *const EPPZCoreDataObjectQueueDataModelFileName = @"EPPZCoreDataObjectQueue";
static NSString *const EPPZCoreDataObjectQueueDataModelFileExtension = @"momd";
static NSString *const EPPZCoreDataStoreFileExtension = @"sqlite";


@interface EPPZCoreDataObjectQueue ()

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *name;
+(NSString*)name;

//Index.
@property (nonatomic, strong) NSMutableDictionary *queuedObjectsForObjects;

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
        
        //Model (describe the entities).
        _managedObjectModel = [NSManagedObjectModel new];
        [_managedObjectModel setEntities:@[[EPPZQueuedObject entityDescription]]];

        //Coordinator (connects the entities with the SQLite store).
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

        //Context (where the entities live).
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];

        //Add a store (an SQLite file in Documents directory).
        NSError *error;
        NSURL *documents = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documents URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", self.name, EPPZCoreDataStoreFileExtension]];
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:storeURL
                                                            options:nil error:&error];
        [self checkForError:error];
        
        //Fetch, unarchive queued object from Core Data.
        [self fetchQueue];
    }
    return self;
}

-(void)fetchQueue
{
    LOG_METHOD;

    //Collections.
    _queue = [NSMutableArray new];
    _queuedObjectsForObjects = [NSMutableDictionary new];
    
    //Entity.
    NSEntityDescription *entity = [NSEntityDescription entityForName:EPPZQueuedObjectEntityName inManagedObjectContext:self.managedObjectContext];
  
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
    for (EPPZQueuedObject *eachQueuedObject in queuedObjects)
    {
        //Unarchive stored object.
        id eachUnarchivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:eachQueuedObject.archivedObject];
        
        //Collect.
        [self.queue addObject:eachUnarchivedObject];
        
        //Index.
        [self indexQueuedObject:eachQueuedObject onObject:eachUnarchivedObject];
    }
}


#pragma mark - Indexing

-(void)indexQueuedObject:(EPPZQueuedObject*) queuedObject onObject:(NSObject<NSCoding>*) object
{
    if (queuedObject != nil)
        if (object != nil)
            if (self.queuedObjectsForObjects != nil)
            {
                NSString *key = @(object.hash).stringValue;
                [self.queuedObjectsForObjects setObject:queuedObject forKey:key];
            }
}

-(EPPZQueuedObject*)queuedObjectForObject:(NSObject<NSCoding>*) object
{
    if (self.queuedObjectsForObjects != nil)
    {
        NSString *key = @(object.hash).stringValue;
        if ([[self.queuedObjectsForObjects allKeys] containsObject:key])
        {
            return [self.queuedObjectsForObjects objectForKey:key];
        }
    }
    return nil;
}


#pragma mark - Hooks

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

-(NSUInteger)lastIndex
{ return self.count - 1; }

-(id)objectAtIndex:(NSUInteger) index
{
    if (self.queue != nil)
        if (self.queue.count > 0)
            return [self.queue objectAtIndex:index];
    return nil;
}

-(void)pushNewObject:(NSObject<NSCoding>*) object
{
    LOG_METHOD;    
 
    if (object != nil)
    {
        //Archive object.
        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:object];

        //Collect.
        [self.queue addObject:object];

        //Add new entry to Core Data context then configure.
        EPPZQueuedObject *queuedObject = [NSEntityDescription insertNewObjectForEntityForName:EPPZQueuedObjectEntityName
                                                                       inManagedObjectContext:self.managedObjectContext];
        queuedObject.creationDate = [NSDate date];
        queuedObject.archivedObject = archivedObject;
        
        //Index.
        [self indexQueuedObject:queuedObject onObject:object];   
    }
}

-(NSObject<NSCoding>*)firstObject
{
    if (self.queue != nil)
        if (self.queue.count > 0)
            return self.queue[0];
    return nil;
}

-(void)popFirstObject
{
    if (self.queue != nil)
        if (self.queue.count > 0)
            [self popObject:self.queue[0]];
}

-(void)popObject:(NSObject<NSCoding>*) object
{
    LOG_METHOD;    
    
    if (object != nil)
    {
        //Seek and destroy corresponding queuedObject.
        EPPZQueuedObject *queuedObject = [self queuedObjectForObject:object];
        [self.managedObjectContext deleteObject:queuedObject];
        
        //Uncollect.
        [self.queue removeObject:object];
        
        //Save.
        [self save];
    }
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
