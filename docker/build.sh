#!/usr/bin/env bash

FILE_NAME=$1

if [[ $FILE_NAME == "base" ]]
then
    echo "Setting up base version."
    sh ./docker_base/build_docker.sh
elif [[ $FILE_NAME == "bike" ]]
then
    echo "Setting up normal version with bike OSRM server."
    sh ./docker_normal_bike/build_docker.sh
elif [[ $FILE_NAME == "car" ]]
then
    echo "Setting up normal version  with car OSRM server."
    sh ./docker_normal_car/build_docker.sh
elif [[ $FILE_NAME == "foot" ]]
then
    echo "Setting up normal version  with foot OSRM server."
    sh ./docker_normal_foot/build_docker.sh
elif [[ $FILE_NAME == "advanced" ]]
then
    echo "Setting up advanced version with 3 OSRM servers."
    sh ./docker_advanced/build_docker.sh
else
    echo "The input '$FILE_NAME' is not among the available choices. Please try again."
fi