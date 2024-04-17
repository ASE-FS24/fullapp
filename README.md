# NexusNet
This repo makes it easier to run the full NexusNet application. 

## How to run (Linux and MacOS)

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

You will now be able to use the app at [localhost:3000](http://localhost:3000).

### Reset (if needed)

If you like to update the projects and you feel too lazy to pull them, you can use the `reset` script and then go back to STEP2. **Do not execute this script while in another directory.**

```
bash reset
```

## How to run (Windows)

The best option right now is to run it in an [emulated bash shell](https://itsfoss.com/install-bash-on-windows/).

## TODO

- [ ] Scripts for Windows
- [ ] Option to pull main branches
- [ ] Option to select folder where to find projects
