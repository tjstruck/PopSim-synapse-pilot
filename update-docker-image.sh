docker build -t popsim-pilot-slim:1.2 .
docker tag popsim-pilot-slim:1.2 tjstruck/popsim-pilot-slim:1.2
docker login -u "" -p "" docker.io
docker push tjstruck/popsim-pilot-slim:1.2