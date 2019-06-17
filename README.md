# pyinstaller-many-linux
Docker image for pyinstaller, a static binary packager for python scripts 
(more informations on [pyinstaller official website](http://www.pyinstaller.org/))

You should use this image, if you want to make your linux apps backward-compatible.

Regarding [official documentation](https://pyinstaller.readthedocs.io/en/stable/usage.html):
> Under Linux, PyInstaller does not bundle libc (the C standard library, usually glibc, 
the Gnu version) with the app. Instead, the app expects to link dynamically to the 
libc from the local OS where it runs. The interface between any app and libc is 
forward compatible to newer releases, but it is not backward compatible to older releases.

>For this reason, if you bundle your app on the current version of Linux, it may 
fail to execute (typically with a runtime dynamic link error) if it is executed on 
an older version of Linux.

> The solution is to always build your app on the oldest version of Linux you 
mean to support. It should continue to work with the libc found on newer versions.

This Docker image provides a clean way to build PyInstaller apps in
an isolated environment using **old glibc v2.5** 
(so your script will be able to execute on many-many linux machines).

## Basic Usage
* Build the Docker image (it will take some time):
    ```bash
    docker build -t pyinstaller-many-linux .
    ```
    or
    ```bash
    make docker-build
    ```
* Run the docker image, binding the data dir to the container's `/code` directory. 
This will compile your script (you can use any pyinstaller args here):
    ```bash
    docker run --rm -v "${PWD}:/code" pyinstaller-many-linux --onefile example.py
    ```
* You can now run the result from the `./dist` directory:
    ```bash
    ./dist/example
    ```

## Customizing the build
The image is based on python 3.6, for now. But you can customize it.
1) Download needed python version to the `python-for-docker` directory from 
[here](https://www.python.org/ftp/python/), before building a Docker image.
1) Change the `Dockerfile`:
    * Change `ARG PYTHON_VERSION=3.6` to the downloaded python version
    * Change `COPY ./python-for-docker/Python-3.6.8.tgz /tmp/` to 
    `COPY ./python-for-docker/YOUR_FILE /tmp/`
    * Change `RUN tar xzvf /tmp/Python-3.6.8.tgz && cd Python-3.6.8 \` to 
    `RUN tar xzvf /tmp/YOUR_FILE && cd YOUR_FILE \`
2) Change `PYTHON_VERSION=3.6` to the downloaded python version in the `entrypoint.sh` file.
3) Build your image or you can use `make docker-rebuild` command.