

# 📁 Warlot: Project Data Manager on Sui
# 🗄️Light Table 
Welcome to **Warlot**, a modular and decentralized data management system built on the **Sui Blockchain**! This project lets you create and manage 🧱 Projects, 🗃️ Buckets, 📝 Tables, and 📄 Files seamlessly.

---

## 🚀 Features

✨ Warlot provides:

- 🆕 **Project creation** with metadata and timestamp  
- 🗃️ **Buckets** to group files with unique names  
- 📄 **File metadata management** including type, uploader, and expiry  
- 📝 **Tables** with rows, columns, and editable cells  
- 🔒 Secure storage using `UID` & `TxContext`  

---
## ⚙️ Package
```rust
 PackageID: 0x7f905a1f764029161b45c66e90420e4fa7e936b3d05f24ae31de82ce1d0e0b89                 
│  │ Version: 1                                                                                    │
│  │ Digest: CUVVYRfC7mZ6dhTz1FK3DFL8xskYmEDBS7oucFvhsNGM                                          │
│  │ Modules: bucketmain, filemain, projectmain, tablemain, warlotpackage   
```

---
## 📦 Modules Breakdown

### `projectobject.move` 🧱  
Manages the entire Project lifecycle.

- `create_project`: Create a new project with name and description  
- `add_bucket`, `get_bucket`: Manage and fetch file buckets  
- `add_table`, `get_table`: Add and retrieve dynamic tables  
- `create_file`: Attach a file to an existing bucket  

### `bucketobject.move` 🗃️  
Handles file containers grouped under projects.

- `create`: Instantiate a new bucket  
- `add_file`: Add a file to this bucket  
- `check_file_name_created`: Prevent duplicate file names  

### `fileobject.move` 📄  
Manages file-level metadata.

- `create`: Create a file entry with type, blob IDs, and expiration  
- `get_name`: Retrieve the file name  

### `tableobject.move` 📝  
Dynamic table logic with editable structure.

- `create`: Make a table with row count  
- `add_col`: Add a column with auto-filled default values  
- `add_row`: Add data to specific columns  
- `add_data_to_table`: Bulk update values by index  
- `update_cell`: Edit a specific cell  
- `check_col_label`, `get_col`: Utility for safe label handling  

---

## 🧩 Architecture

```
Project
│
├── Buckets (Name-based)
│   └── Files (Blob Info + Metadata)
│
└── Tables (Name-based)
    └── Columns → Rows (Label → Data)
```

Each item is stored using dynamic object fields and ensures name uniqueness at every level. 🌐

---

## 🔐 Error Handling
please make sure that you follow the structure of the table
- ❌ `InvalidName`: Duplicate name found
- ❌ `EInvalidLabel`: Column label already exists
- ❌ `EInvalidData`: Mismatched or invalid dataset input

These are designed to prevent accidental overwrites and ensure consistent behavior.

---

## 🛠️ Usage Guide (Example Flow)

1. Create a project:
   ```move
   create_project("ResearchX", "AI Project", clock);
   ```

2. Add a bucket:
   ```move
   create_bucket(&mut project, "images", "Dataset images", clock);
   ```

3. Add a file:
   ```move
   create_file(&mut project, "cat.png", "Image of a cat", ".png", "blob_id", addr, "images", epoch, expiry, clock);
   ```

4. Create a table:
   ```move
   create_table(&mut project, "metrics", 5, clock);
   ```

5. Add column:
   ```move
   add_col(&mut table, "Accuracy");
   ```

6. Update data:
   ```move
   add_row(&mut table, ["Accuracy"], ["0.95"], clock);
   ```
