# Dotflow 

Dotflow is a tool to manage your dotfiles.


```shell
dotflow init # Creates a folder in .config/ called dotflow, you want to make this a repo

dotflow link -p PATH # Move the original file to dotflow folder and creates a link to the previous path

dotflow install # Use this in a new environment, this will put your dotfiles in the right place again

```

## How to install

### Build by yourself
1. Install nim: 
https://nim-lang.org/install.html
2. Install cligen: 
```shell
nimble install cligen
```
3. Build:
```shell
nim c src/dotflow.nim
```
