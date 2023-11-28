# Lexical-Analyzer-Compilation-Language-Interpreter

# General Usage
- From the root directory you'll run:
```
docker build -t project1:latest -f docker/Dockerfile .
```
- Then you'll run:
```
docker run --name project1 -v <location_to_root_folder>:/project1 -it project1
```
- Once inside container and ready to test:
```
./compile < <filename>.txt
```
