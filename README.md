# Q-SYS Plugin Template

## Build Tasks
use the default build task to take your parts and create a singular .qplug plugin

you have a few options for semantic versioning

- major
- minor
- patch
- build

## Output .qplug
youll find the compiled plugin in the /output/ folder after running the build task

## Modules
you can separate your logic out into flat lua files in the /modules folder, these can be added using require('filenamewithoutextension')

if you want to further separate into folders, you would need to do the following for any folder within /modules 

require('folder/somefilenamewithoutextension)