# Thanks https://blog.xmatthias.com/compiling-python-3-6-for-centos-5-11-with-openssl/
# for the major part of this Dockerfile
FROM centos:5

ARG PYINSTALLER_VERSION=3.4
ARG PYTHON_VERSION=3.6

# As centos5 has reached end of life, some manipulation are needed
# to get "yum" behave as expected in the container
RUN mkdir /var/cache/yum/base/ \
    && mkdir /var/cache/yum/extras/ \
    && mkdir /var/cache/yum/updates/ \
    && mkdir /var/cache/yum/libselinux/ \
    && echo "http://vault.centos.org/5.11/os/x86_64/" > /var/cache/yum/base/mirrorlist.txt \
    && echo "http://vault.centos.org/5.11/extras/x86_64/" > /var/cache/yum/extras/mirrorlist.txt \
    && echo "http://vault.centos.org/5.11/updates/x86_64/" > /var/cache/yum/updates/mirrorlist.txt \
    && echo "http://vault.centos.org/5.11/centosplus/x86_64/" > /var/cache/yum/libselinux/mirrorlist.txt

# Installing dependencies
RUN yum install -y gcc gcc44 zlib-devel python-setuptools readline-devel wget make perl

# build and install openssl
RUN cd /tmp && wget https://www.openssl.org/source/openssl-1.0.2l.tar.gz \
    && tar xzvpf openssl-1.0.2l.tar.gz && cd openssl-1.0.2l \
    && ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl \
    && sed -i.orig '/^CFLAG/s/$/ -fPIC/' Makefile \
    && make && make test && make install

# or you can use "wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz" here
# but it didnt work for me, so we need to use already downloaded one
COPY ./python-for-docker/Python-3.6.8.tgz /tmp/
COPY entrypoint.sh /entrypoint.sh

# build and install python${PYTHON_VERSION}
RUN tar xzvf /tmp/Python-3.6.8.tgz && cd Python-3.6.8 \
    && ./configure --prefix=/opt/python${PYTHON_VERSION} --enable-shared --with-threads && make altinstall \
    && ln -s /opt/python${PYTHON_VERSION}/bin/python${PYTHON_VERSION} /usr/local/bin/python${PYTHON_VERSION} \
    && ln -s /opt/python${PYTHON_VERSION}/bin/pip${PYTHON_VERSION} /usr/local/bin/pip${PYTHON_VERSION}

ENV LD_LIBRARY_PATH=/opt/python${PYTHON_VERSION}/lib

RUN pip${PYTHON_VERSION} install pyinstaller==$PYINSTALLER_VERSION \
    && rm -rf /tmp/ && chmod +x /entrypoint.sh

RUN mkdir /code
WORKDIR /code

ENTRYPOINT [ "/entrypoint.sh" ]