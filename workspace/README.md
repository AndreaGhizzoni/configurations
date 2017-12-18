# Scripts to build my entire workspace from scratch
The rules are simples:
- all folders contained in this directory represents an individual workspace
- in each workspace there are 3 main scripts
    - `install.bash` : that will install some dependencies/sdk/compiler ..
    - `build-workspace.bash` : that will create the necessary folder structure
      of workspace
    - `get-projects.bash` : that will clone (or pull) every projects into the
      workspace
- `builder.bash` : will programmatically call the above scripts for every
  workspace


