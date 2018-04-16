#!/bin/bash

JENKINS_PORT="8080"
JENKINS_SAVEPATH="/docker/jenkins_cfg"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--port)
    JENKINS_PORT="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--savepath)
    JENKINS_SAVEPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    echo "sudo $0 [docker image name]"
    echo ""
    echo "Option :"
    echo "    -p [jenkins port]"
    echo "    -s [jenkins save files path]"
    exit 0
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -n $1 ]]; then
    DOCKER_NAME=$1
    DOCKER_STRING=$DOCKER_NAME" "
    if [ $(docker images | grep "$DOCKER_STRING" | wc -l) = "0" ]; then
        echo ""
        echo "please check docker image name : $DOCKER_NAME"
        echo ""
        exit 0
    fi
else
    echo ""
    echo "please insert docker image name"
    echo ""
    exit 0
fi

if [ $(docker ps | grep "$DOCKER_STRING" | wc -l) != "0" ]; then
    echo $(docker rm $(docker stop $(docker ps -a -q --filter ancestor=$DOCKER_NAME --format="{{.ID}}")))
    echo "$DOCKER_NAME is stopping..."
fi

echo $(mkdir -p ${JENKINS_SAVEPATH})
echo $(docker run -p ${JENKINS_PORT}:8080 -v ${JENKINS_SAVEPATH}:/var/jenkins_home --privileged ${DOCKER_NAME}) 

if [ $(docker ps | grep "$DOCKER_STRING" | wc -l) != "0" ]; then
    echo ""
    echo "Jenkins port                = ${JENKINS_PORT}"
    echo "Jenkins save files path     = ${JENKINS_SAVEPATH}"
    echo "DOCKER_NAME                 = $1"
    echo ""
else
    echo ""
    echo "$DOCKER_NAME run fail..."
    echo ""
fi

