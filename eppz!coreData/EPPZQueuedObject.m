//
//  One.m
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZQueuedObject.h"


@implementation EPPZQueuedObject


@dynamic creationDate;
@dynamic archivedObject;


+(NSEntityDescription*)entityDescription
{
    //Describe EPPZQueuedObject.
    NSEntityDescription *entityDescription = [NSEntityDescription new];
    entityDescription.name = EPPZQueuedObjectEntityName;
    entityDescription.managedObjectClassName = NSStringFromClass(self);
    
    //Describe creationDate.
    NSAttributeDescription *creationDateDescription = [NSAttributeDescription new];
    creationDateDescription.name = @"creationDate";
    creationDateDescription.attributeType = NSDateAttributeType;
    creationDateDescription.attributeValueClassName = @"NSDate";
    creationDateDescription.defaultValue = nil;    

    //Describe archivedObject.    
    NSAttributeDescription *archivedObjectDescription = [NSAttributeDescription new];
    archivedObjectDescription.name = @"archivedObject";    
    archivedObjectDescription.attributeType = NSBinaryDataAttributeType;
    archivedObjectDescription.attributeValueClassName = @"NSData";
    archivedObjectDescription.defaultValue = nil;
    
    //Add attributes.
    entityDescription.properties = @[ creationDateDescription, archivedObjectDescription ];
    
    //Voila.
    return entityDescription;
}


@end
