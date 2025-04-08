module warlotpackage::projectmain;
use sui::clock::Clock;
use warlotpackage::projectmain::{Self, Project};
use warlotpackage::bucketmain::{Self, Bucket};

public struct FileMeta has key, store {
 id: UID, //using the indexer you can get the file by id fast
 name: String,
 description: String,
 file_type: String, // e.g .txt, .pdf, .mp4 e.t.c
 uploader: address,
 blod_id: String,
 blob_object_id: address,
 bucket: String, 
 time_created: u64,
 uploaded_epoch: u64,
    expires_at: u64,
 }

public fun create(
    project: &mut Project,
    name: String,
    description: String,
    file_type: String,
    blod_id: String,
    blob_object_id: address,
    bucket: String, 
    uploaded_epoch: u64,
    expires_at: u64,
    ctx: &mut TxContext
){
    let file = FileMeta{
        id : object::new(ctx),
        name : name,
        description: description,
        file_type: file_type,
        uploader: ctx.sender(),
        blod_id: blod_id,
        blob_object_id: blob_object_id,
        bucket: bucket,
        time_created: clock.timestamp_ms(),
        uploaded_epoch: uploaded_epoch,
        expires_at = expires_at,
    };


    let bucket_object_x = project.get_bucket(project, bucket);

    ofields::add<String, FileMeta>(&mut bucket_object_x.id, file.name, file);



}



fun get_bucket(project: &mut Project, bucket_name: String): &mut Bucket{
    ofields::borrow_mut<String, Bucket>(&mut project.id, name)
}









