# Lexical-Analyzer-Compilation-Language-Interpreter

# General Usage
- From the root directory you'll run:
```
docker build -t lang-interpreter:latest -f docker/Dockerfile .
```
- Then you'll run:
```
docker run --name lang-interpreter -v <location_to_root_folder>:/lang-interpreter -it lang-interpreter
```
- Once inside container and ready to test:
```
./compile < <filename>.txt
```
