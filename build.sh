#!/bin/bash

# Script to build all images and push to Docker hub

docker_user=adilinden

# Lists of golang versions and OS releases names
#
# - tags are composed of golang-os
# - the last golang os also the os only tag
# - the last golang and os combo bcomes latest
golang_list="1.9.7 1.10.5 1.11.1 1.11.2"
os_list="stretch trusty"

# Iterate over lists
cwd="$PWD"
for os_ver in $os_list; do
    for golang_ver in $golang_list; do

        # Get major version
        golang_major=${golang_ver%.*}

        # Path to Dockerfile
        docker_path="$golang_major/$os_ver"

        # Tag
        docker_tag="${docker_user}/golang:${golang_ver}-${os_ver}"

        echo "--- Trying build at $docker_path"

        # Make sure there's a Dockerfile there
        if [ ! -f "$docker_path/Dockerfile" ]; then
            echo "No Dockerfile found"
            continue
        fi

        # Build the container
        docker build --build-arg golang_ver=$golang_ver -t "$docker_tag" "$docker_path"
        retval=$?
        if [ $retval -ne 0 ]; then
            echo "=== FAIL build of \"$docker_tag\""
            failed="$failed $docker_tag"
            continue
        fi

        # Push to docker hub
        docker push "$docker_tag"
        if [ $retval -ne 0 ]; then
            echo "failed pushing \"$docker_tag\" to Docker hub"
        fi

        # Tag major alias
        docker tag "$docker_tag" "${docker_user}/golang:${golang_major}-${os_ver}"
        docker push "${docker_user}/golang:${golang_major}-${os_ver}"
        echo "pushed alias \"${docker_user}/golang:${golang_major}-${os_ver}\""
        aliases="$aliases ${docker_tag}=${docker_user}/golang:${golang_major}-${os_ver}"

        # Save latest and OS
        tag_os="$docker_tag"
        tag_latest="$docker_tag"

        echo "=== PASS build of \"$docker_tag\""
        success="$success $docker_tag"
    done

    # Tag os alias
    if [ -n "$tag_os" ]; then
        # Push os alias
        docker tag "$tag_os" "${docker_user}/golang:${os_ver}"
        docker push "${docker_user}/golang:${os_ver}"
        echo "pushed alias \"${docker_user}/golang:${os_ver}\""
        aliases="$aliases ${tag_os}=${docker_user}/golang:${os_ver}"
    fi
done

# Tag latest alias
if [ -n "$tag_latest" ]; then
    docker tag "$tag_latest" "${docker_user}/golang:latest"
    docker push "${docker_user}/golang:latest"
    echo "pushed alias \"${docker_user}/golang:${os_ver}\""
    aliases="$aliases ${tag_latest}=${docker_user}/golang:latest"
fi

echo
echo "----------------------------------------------------------"
echo " Complete builds:"
for s in $success; do echo "    $s"; done
echo
echo " Pushed aliases:"
for s in $aliases; do echo "    $s"; done
echo
echo " Failed builds:"
for s in $failed; do echo "    $s"; done
echo "----------------------------------------------------------"
echo

# End