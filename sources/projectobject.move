module warlotpackage::projectmain;
use sui::clock::Clock;


public struct Project has key, store{
    id: UID,
    name: String,
    description: String,
    time_created: u64
}



public fun create(name: String, description: String, clock: &Clock, ctx: &mut TxContext){
    let project =  Project{
        id: object::new(ctx),
        name: name,
        description: description,
       clock.timestamp_ms(),
    };

    

    transfer::public_transfer(project, ctx.sender())
}


