module warlotpackage::projectmain;
use sui::clock::Clock;
use sui::dynamic_object_field as ofields;
use warlotpackage::tablemain::{Self, Table};
use warlotpackage::bucketmain::{Self, Bucket};
use warlotpackage::filemain::{Self, FileMeta};
use std::string::{String};


// project istance is being owned by the user 
// allowing the sdk to get all the one the user has created
public struct Project has key, store{
    id: UID,
    name: String,
    description: String,
    time_created: u64
}


//======errors ======//
// #[error]
// const InvalidName: vector<u8> = b"name has been created, enter another name";



#[allow(lint(self_transfer))]
public fun create_project(name: String, description: String, clock: &Clock, ctx: &mut TxContext){
    let project =  Project{
        id: object::new(ctx),
        name,
        description,
       time_created: clock.timestamp_ms(),
    };


    transfer::public_transfer(project, ctx.sender())
}



public fun create_bucket(
    project: &mut Project, 
    name: String, 
    description: String, 
    clock: &Clock, 
    ctx: &mut TxContext){

    let bucket: Bucket = bucketmain::create(name, description, clock, ctx);
    project.add_bucket(bucket);
}


public fun create_table(
    project: &mut Project,
    name: String,
    cache_obj: address,
    cache_file: String,
    clock: &Clock,
    ctx: &mut TxContext){
    let table: Table = tablemain::create(name, cache_obj, cache_file, clock, ctx);
    project.add_table(table);
}



public fun update_table(
    project: &mut Project,
    table_name: String, 
    cache_obj: address,
    cache_file: String,
    clock: &Clock
){
    let table = get_table(project, table_name);
    tablemain::update( table, cache_obj, cache_file, clock);
}



public fun create_file(
    project: &mut Project,
    name: String,
    description: String,
    file_type: String,
    blod_id: String,
    blob_object_id: address,
    bucket: String, 
    blob_settings: address,
    clock: &Clock,
    ctx: &mut TxContext
){
    let file: FileMeta = filemain::create(
        name, 
        description, 
        file_type, 
        blod_id, 
        blob_object_id, 
        bucket, 
        blob_settings,
        clock, 
        ctx
        );

    let ref_bucket: &mut Bucket = project.get_bucket(bucket);
    ref_bucket.add_file(file);


}





//========= Bucket ========//
public fun add_bucket(project: &mut Project, bucket: Bucket){
    let name = bucket.get_name();
    // assert!(!check_bucket_name_created(project, name));
    ofields::add<String, Bucket>(&mut project.id, name , bucket);
}


public fun check_bucket_name_created(project: &Project, name: String): bool{
    ofields::exists_(&project.id, name)
}


public fun get_bucket(project: &mut Project, name: String): &mut Bucket{
    assert!(check_bucket_name_created(project, name));
    ofields::borrow_mut<String, Bucket>(&mut project.id, name)
}





// ====== table editor ======== // 
//===== Table to project =======//

public fun add_table(project: &mut Project,  table: Table ){
    let name =  table.get_name();
    // assert!(!project.check_name_created(name), InvalidName);

    ofields::add<String, Table>(&mut project.id, name,  table);
}

public fun check_name_created(project: &Project, name: String): bool{
    ofields::exists_(&project.id, name)
}

public fun get_table(
    project: &mut Project, 
    name: String,
): &mut Table{
    ofields::borrow_mut<String, Table>(&mut project.id, name)
}

