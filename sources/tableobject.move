module warlotpackage::tablemain;
use sui::clock::Clock;
use sui::dynamic_field as dfield;
use std::string::{String};

public struct Table has key, store{
    id: UID,
    name: String,
    time_created: u64,
    last_updated: u64,
    columns: u64,
    rows: u64,
    column_labels: vector<String>
}

//======errors ======//
#[error]
const EInvalidLabel: vector<u8> = b"Label has been created, enter another Label";


#[error]
const EInvalidData: vector<u8> = b"enter valid dataset";


public fun create(
    name: String,
     rows: u64,
    clock: &Clock,
    ctx: &mut TxContext): Table{

    let table = Table{
        id: object::new(ctx),
        name: name,
        time_created: clock.timestamp_ms(),
        last_updated: clock.timestamp_ms(),
        columns: 0,
        rows: rows,
        column_labels: vector::empty<String>(),
    };

    table

}




public fun get_name(table: &Table): String{
    table.name 
}

public fun update(
    table: &mut Table, 
    clock: &Clock
    ){
    table.last_updated = clock.timestamp_ms();
}
// ======helper =======///






public fun add_col(table: &mut Table, col_label: String) {
    assert!(!check_col_label(table, col_label), EInvalidLabel);
    table.columns = table.columns + 1;

    // Fill the new column with "null" entries equal to the number of rows
    let mut col: vector<String> = vector::empty<String>();
    let mut i = 0;
    while (i < table.rows) {
        vector::push_back(&mut col, b"_".to_string()); // default value
        i = i + 1;
    };
    vector::push_back(&mut table.column_labels, col_label);

    dfield::add<String, vector<String>>(&mut table.id, col_label, col);
}


// pls keep the following in mind
// if updating multiple data value 
// make sure the label index matches the col_index and matches the value index
// else you will update the wrong data

public fun add_data_to_table(
    table: &mut Table,
    col_labels: vector<String>,
    col_indexes: vector<u64>, 
    row_values: vector<String>,
    clock: &Clock
) {
    let len = vector::length(&col_labels);
    assert!(len == vector::length(&col_indexes) && len == vector::length(&row_values), EInvalidData);

    let mut i = 0;
    while (i < len) {
        let label = vector::borrow(&col_labels, i);
        let col_idx = *vector::borrow(&col_indexes, i);
        let val = vector::borrow(&row_values, i);

        let col = get_col(table, *label);
        let cell = vector::borrow_mut(col, col_idx);
        *cell = *val;

        i = i + 1;
    };

    update(table, clock);
}


fun clone_string_vector(original: &vector<String>): vector<String> {
    let mut copy_vec = vector::empty<String>();
    let len = vector::length(original);
    let mut i = 0;
    while (i < len) {
        let val = vector::borrow(original, i);
        vector::push_back(&mut copy_vec, *val); 
        i = i + 1;
    };
    copy_vec
}


public fun add_row(
    table: &mut Table,
    col_labels: vector<String>,
    col_values: vector<String>,
    clock: &Clock
) {
    let provided = vector::length(&col_labels);
    assert!(provided == vector::length(&col_values), EInvalidData);

    // Update all columns in the table
    let all_labels = clone_string_vector(get_all_col_labels(table));
    let mut i = 0;
    while (i < vector::length(&all_labels)) {
        let label = vector::borrow(&all_labels, i);
        let col = get_col(table, *label);

        // Check if user provided value for this column
        let mut j = 0;
        let mut found = false;
        while (j < provided) {
            if (*vector::borrow(&col_labels, j) == *label) {
                let val = vector::borrow(&col_values, j);
                vector::push_back(col, *val);
                found = true;
                break
            };
            j = j + 1;
        };

        if (!found) {
            vector::push_back(col, b"_".to_string());
        };

        i = i + 1;
    };

    table.rows = table.rows + 1;
    update(table, clock);
}

public fun update_cell(
    table: &mut Table,
    label: String,
    row_index: u64,
    new_value: String,
    clock: &Clock
) {
    assert!(check_col_label(table, label), EInvalidLabel);
    let col = get_col(table, label);
    *vector::borrow_mut(col, row_index) = new_value;
    update(table, clock);
}



fun get_col(table: &mut Table, col_label: String): &mut vector<String> {
    assert!(check_col_label(table, col_label), EInvalidLabel);
    dfield::borrow_mut<String, vector<String>>(&mut table.id, col_label)
}

public fun check_col_label(table: &mut Table, col_label: String): bool {
    dfield::exists_(&table.id, col_label)
}

public fun get_all_col_labels(table: &Table): &vector<String>{
    &table.column_labels
 }