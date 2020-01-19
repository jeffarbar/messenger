docker build -t jeffersonfarias/mensagem-front:1.0.1  -f Dockerfile .
docker login --username=jeffersonfarias
docker push jeffersonfarias/mensagem-front:1.0.1
