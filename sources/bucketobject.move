module warlotpackage::bucketmain;
use sui::clock::Clock;
use warlotpackage::projectmain::{Self, Project};
use sui::dynamic_object_field as ofields;

public struct Bucket has key, store{
    id: UID,
    name: String,
    description: String,
    time_created: u64
}


public fun create(project: &mut Project, name: String, description: String, clock: &Clock, ctx: &mut TxContext){
    let bucket =  Bucket{
        id: object::new(ctx),
        name: name,
        description: description,
       clock.timestamp_ms(),
    };

    project.add_bucket(bucket)
}



public fun add_bucket(project: &mut Project, bucket: Bucket){
    let name = bucket.name;
    assert!(!check_name_created(project, name));
}


public fun check_name_created(project: &Project, name: String): bool{
    ofield::exists_(&project.id, name)
}