module warlotpackage::tablemain;
use sui::clock::Clock;
use std::string::{String};

public struct Table has key, store{
    id: UID,
    name: String,
    table_blobid: String,
    table_blob_object_id: String,
    time_created: u64,
    last_updated: u64,
}




public fun create(
    name: String,
    table_blobid: String, 
    table_blob_object_id: String, 
    clock: &Clock,
    ctx: &mut TxContext): Table{

    let table = Table{
        id: object::new(ctx),
        name: name,
        table_blobid: table_blobid,
        table_blob_object_id: table_blob_object_id,
        time_created: clock.timestamp_ms(),
        last_updated: clock.timestamp_ms()
    };

    table

}




public fun get_name(table: &Table): String{
    table.name 
}

public fun update(
    table: &mut Table,
    table_blobid: String, 
    table_blob_object_id: String, 
    clock: &Clock
    ){
    table.table_blobid = table_blobid;
    table.table_blob_object_id = table_blob_object_id;
    table.last_updated = clock.timestamp_ms();
}
// ======helper =======///



// fun add_col(table: &mut Table, name: String){
//     let col: vector<String>  = vector::empty<String>();
//     ofield::add<String, vector<String>>(&mut table.id, name, col)

// }

// json{
//     "id": [],
//     "name": [],
//     "username" [],
// }
// // }


// no| id | name | username
// 0 | x1 |gospel| steven 