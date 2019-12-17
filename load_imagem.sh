docker build -t jeffersonfarias/mensagem-front:latest  -f Dockerfile .
docker login --username=jeffersonfarias
docker push jeffersonfarias/mensagem-front:latest
