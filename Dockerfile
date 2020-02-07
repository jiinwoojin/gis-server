# -*- coding: utf-8 -*-

FROM centos:7
MAINTAINER JIIN System <jiinwoojin@gmail.com>

RUN mkdir -p /app/jiserver/source

WORKDIR /app/jiserver/source

RUN git clone https://github.com/jiinwoojin/mapproxy.git && \
    git clone https://github.com/jiinwoojin/mapserver.git && \
    git clone https://github.com/jiinwoojin/tegola.git && \
    git clone https://github.com/jiinwoojin/mapnik.git && \
    git clone https://github.com/jiinwoojin/node-mapnik && \
    git clone https://github.com/jiinwoojin/python-mapnik && \
    yum install -y wget && \
    wget http://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-7.5.0/gcc-7.5.0.tar.gz && \
    wget https://download.osgeo.org/proj/proj-6.1.1.tar.gz && \
    wget https://download.osgeo.org/proj/proj-datumgrid-1.8.zip && \
    wget https://download.osgeo.org/geos/geos-3.8.0.tar.bz2 && \
    wget http://download.osgeo.org/gdal/2.4.4/gdal-2.4.4.tar.gz

RUN ls -all