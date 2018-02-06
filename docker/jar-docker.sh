#!/bin/bash
docker build -t ctx-cloud-zuul /home/data/build/ctx-cloud-zuul/
docker tag ctx-cloud-zuul 127.0.0.1:5000/ctx-cloud-zuul:latest

result=`docker ps -f "label=service=ctx-cloud-zuul" -q`
if [ -n "$result" ]; then
  echo "=========find exist zuul container: "$result"========="
  echo "=========stop container: "$result"===================="
  docker stop $result
  echo "=========rm container: "$result"======================"
  docker rm $result
else
  echo "=========no zuul service!============================="
fi

echo "=========starting zuul ================================="
docker run -d -p 10011:10011 -e SPRING_PROFILES_ACTIVE=uat --restart=always -l service=ctx-cloud-zuul 127.0.0.1:5000/ctx-cloud-zuul

echo "=========wait 10 seconds for clean spring boot admin===="
sleep 10
echo "=========starting clean spring boot admin==============="
java -jar /home/data/build/tools/ctx-tool-sba-jar-with-dependencies.jar http://localhost:10012