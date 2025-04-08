module warlotpackage::tablemain;
use sui::clock::Clock;
use warlotpackage::projectmain::{Self, Project};
use sui::dynamic_field as dfield;


public struct Table has store{
    name: String,
    table_blobid: String,
    table_blob_object_id: String,
    time_created: u64,
    last_updated: u64,
}


//======errors ======//
#[error]
const InvalidName: vector<u8> = b"name has been created, enter another name";



public fun create(
    project: &mut Project, 
    name: String,
    table_blobid: String, 
    table_blob_object_id: String, 
    clock: &Clock
    ctx: &mut TxContext){

    let table = Table{
        name: name,
        table_blobid: table_blobid,
        table_blob_object_id: table_blob_object_id,
        time_created: clock.timestamp_ms(),
        last_updated: clock.timestamp_ms()
    };

    project.add_table_name(table)

}


public fun modify_table(
    project: &mut Project, 
    name: String,
    table_blobid: String, 
    table_blob_object_id: String, 
    clock: &Clock
){
    let table  = project.get_table(name);
    table.table_blobid = table_blobid;
    table.table_blob_object_id = table_blob_object_id;
    table.last_updated = clock.timestamp_ms();
}



// ======helper =======///
fun add_table_name(project: &mut Project,  table: Table ){
    let name =  table.name;
    assert!(!project.check_name_created(name), InvalidName);

    dfield::add<String, Table>(&mut project.id, name,  table);
}

public fun check_name_created(project: &Project, name: String): bool{
    dfield::exists_(&project.id, name)
}

fun get_table(
    project: &mut Project, 
    name: String,
)&mut Table{
    dfield::borrow_mut<String, Table>(&mut project.id, name)
}