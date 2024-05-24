# Pigs-Version-Control

**Pigs** is a mock version control system based off git and is written entirely in Bash. It provides the basic functionalty of git but is lightweight and used as a way to learn about the intricacies of how version control works.

# Basics
* Repository: Your project's versioned directory.
* Commit: Snapshot of your project at a point in time.
* Branch: Parallel version for separate work.

# Commands 

* **Init**: Start tracking a project
```
./pigs-init
```

* **Add**: Stage changes
```
./pigs-add <filename>
```

* **Commit**: Save changes
```
./pigs-commit [-a | -m "msg"]
```

* **Branch**: Manage branches
  * List
  ```
  ./pigs-branch
  ```
  * Create
  ```
  ./pigs-branch <branch-name>
  ```
* **Log**: View commit history
```
./pigs-log
```

* **Remove**: Delete files
```
./pigs-rm <filename>
```

* **Show**: Display Changes
```
./pigs-show
```

* **Status**: Check file status
```
./pigs-status
```
