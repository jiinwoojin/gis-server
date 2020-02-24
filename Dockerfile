# -*- coding: utf-8 -*-
# mapproxy + mapserver

FROM centos:7
MAINTAINER JIIN System <jiinwoojin@gmail.com>

ENV ROOTDIR=/app/jiserver \
    GCC_VERSION="7.5.0" \
    PROJ_VERSION="6.1.1" \
    GEOS_VERSION="3.8.0" \
    GDAL_VERSION="2.4.4" \
    CMAKE_VERSION="3.9.6" \
    POSTGRESQL_VERSION="12.1" \
    POSTGIS_VERSION="3.0.0"

ENV GCC_PATH=${ROOTDIR}/gcc-${GCC_VERSION} \
    PROJ_PATH=${ROOTDIR}/proj-${PROJ_VERSION} \
    GEOS_PATH=${ROOTDIR}/geos-${GEOS_VERSION} \
    GDAL_PATH=${ROOTDIR}/gdal-${GDAL_VERSION} \
    CMAKE_PATH=${ROOTDIR}/cmake-${CMAKE_VERSION} \
    POSTGRESQL_PATH=${ROOTDIR}/postgresql-${POSTGRESQL_VERSION}

RUN mkdir -p ${ROOTDIR}/source

WORKDIR ${ROOTDIR}/source

RUN yum update -y && yum install -y git bzip2 gcc-c++ wget unzip make sqlite3 sqlite3-devel openssl openssl-devel  \
        autoconf perl-Test-Harness perl-Thread-Queue automake autogen-libopts libtool \
        keyutils-libs-devel krb5-devel libcom_err-devel libkadm5 libselinux-devel libsepol-devel \
        libverto-devel pcre-devel zlib-devel krb5-libs rhash rhash-devel jsoncpp jsoncpp-devel libuv libuv-devel && \
    git clone https://github.com/jiinwoojin/mapproxy.git && \
    git clone https://github.com/jiinwoojin/mapserver.git && \
    wget http://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz && \
    wget https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz && \
    wget https://download.osgeo.org/proj/proj-datumgrid-1.8.zip && \
    wget https://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 && \
    wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    wget http://www.cmake.org/files/v3.9/cmake-${CMAKE_VERSION}.tar.gz && \
    wget https://ftp.postgresql.org/pub/source/v${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.tar.gz && \
    wget http://postgis.net/stuff/postgis-${POSTGIS_VERSION}.tar.gz

RUN tar -zxf gcc-${GCC_VERSION}.tar.gz && \
    tar -xf geos-${GEOS_VERSION}.tar.bz2 && \
    tar -zxf gdal-${GDAL_VERSION}.tar.gz && \
    tar -zxf cmake-${CMAKE_VERSION}.tar.gz && \
    tar -zxf postgresql-${POSTGRESQL_VERSION}.tar.gz && \
    tar -zxf postgis-${POSTGIS_VERSION}.tar.gz && \
    tar -zxf proj-${PROJ_VERSION}.tar.gz && \
    unzip proj-datumgrid-1.8.zip -d ${ROOTDIR}/source/proj-datumgrid-1.8 && \
    ls -all

WORKDIR ${ROOTDIR}/source/gcc-${GCC_VERSION}

RUN yum -y install texinfo perl-Text-Unidecode perl-libintl expect libgnat libgnat-devel gcc-gnat binutils-devel && \
    ./contrib/download_prerequisites && \
    ./configure --disable-shared --enable-static --disable-multilib --enable-languages=c,c++ && \
    make -j4 && \
    make -j4 install && \
    gcc --version