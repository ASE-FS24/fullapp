# NexusNet
This repo makes it easier to run the full NexusNet application. 

## How to run (Linux)

### 1. Install dependencies

You need to install `git`, `docker`, `docker compose`, `java` and `maven`.

### 2. Download and compile projects using `compile` script

```
bash compile
```

Right now the script fetches the `develop` branch. If you like to fetch another branch just do it in this directory (`fullapp`) using git.

### 3. Run the project

```
docker compose up --build
```

### Reset (if needed)

If you like to update the projects and you feel too lazy to pull them, you can use the `reset` script and then go back to STEP2. **Do not execute this script while in another directory.**

```
bash reset
```

## TODO

[ ] Scripts for MacOS and Windows
[ ] Option to pull develop branches
[ ] Option to select folder where to find projects
