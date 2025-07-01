# delete-node-modules

A utility script to find and delete all `node_modules` folders in a project that haven't been accessed in a specified number of days.

## Features
- Recursively searches for `node_modules` directories from a given starting directory.
- Lists only the main project directories containing these `node_modules`.
- Shows the size of each `node_modules` directory found.
- Prompts for confirmation before deleting.
- Deletes only those `node_modules` folders that haven't been accessed in the specified number of days.

## Usage

```sh
./delete-node-modules.sh [DIRECTORY] [DAYS]
```

- `DIRECTORY`: Starting directory to search from (default: current directory)
- `DAYS`: Number of days since last access (default: 45)

### Example

```sh
./delete-node-modules.sh ~/projects 30
```
This will search in `~/projects` for `node_modules` folders not accessed in the last 30 days.

## Help

```sh
./delete-node-modules.sh --help
```

## Safety
- The script will prompt you before deleting any directories.
- No directories are deleted unless you confirm.

---

**Use with caution!** Always review the list before confirming deletion. 