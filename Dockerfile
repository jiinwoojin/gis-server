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
    POSTGIS_VERSION="3.0.0" \
    GCC_PATH=${ROOTDIR}/gcc-${GCC_VERSION} \
    PROJ_PATH=${ROOTDIR}/proj-${PROJ_VERSION} \
    GEOS_PATH=${ROOTDIR}/geos-${GEOS_VERSION} \
    GDAL_PATH=${ROOTDIR}/gdal-${GDAL_VERSION} \
    CMAKE_PATH=${ROOTDIR}/cmake-${CMAKE_VERSION} \
    POSTGRESQL_PATH=${ROOTDIR}/postgresql-${POSTGRESQL_VERSION}

RUN mkdir -p ${ROOTDIR}/source

WORKDIR ${ROOTDIR}/source

RUN yum install -y git bzip2 gcc-c++ wget unzip && \
    git clone https://github.com/jiinwoojin/mapproxy.git && \
    git clone https://github.com/jiinwoojin/mapserver.git && \
    yum install -y wget && \
    wget http://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz && \
    wget https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz && \
    wget https://download.osgeo.org/proj/proj-datumgrid-1.8.zip && \
    wget https://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 && \
    wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    wget http://www.cmake.org/files/v3.9/cmake-${CMAKE_VERSION}.tar.gz && \
    wget https://ftp.postgresql.org/pub/source/v${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.tar.gz && \
    wget http://postgis.net/stuff/postgis-${POSTGIS_VERSION}.tar.gz

RUN tar -zxvf gcc-${GCC_VERSION}.tar.gz && \
    tar -xvf geos-${GEOS_VERSION}.tar.bz2 && \
    tar -zxvf gdal-${GDAL_VERSION}.tar.gz && \
    tar -zxvf cmake-${CMAKE_VERSION}.tar.gz && \
    tar -zxvf postgresql-${POSTGRESQL_VERSION}.tar.gz && \
    tar -zxvf postgis-${POSTGIS_VERSION}.tar.gz && \
    tar -zxvf proj-${PROJ_VERSION}.tar.gz && \
    unzip proj-datumgrid-1.8.zip -d ${ROOTDIR}/source/proj-datumgrid-1.8 && \
    ls -all

WORKDIR ${ROOTDIR}/source/gcc-${GCC_VERSION}

RUN yum -y install texinfo perl-Text-Unidecode perl-libintl expect libgnat libgnat-devel gcc-gnat binutils-devel && \
    ./contrib/download_prerequisites
    ./configure --disable-shared --enable-static --disable-multilib --enable-languages=c,c++ && \
    make -j8
    make -j8 install
    gcc --version