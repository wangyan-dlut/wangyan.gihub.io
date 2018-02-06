#!/usr/bin/env bash
remote_host=101.201.109.161
project=ctx-cloud-zuul
port=10011
docker tag $project $remote_host:5000/$project:latest
docker push $remote_host:5000/$project
ansible-playbook /home/data/build/ansible/ctx-module-docker.yml --extra-vars "module_name=$project module_port=$port spring_profiles_active=uat"
sleep 10
java -jar /home/tools/sba/ctx-tool-sba-jar-with-dependencies.jar http://$remote_host:10012