# -*- coding: utf-8 -*-
# mapproxy + mapserver

FROM centos:7
MAINTAINER JIIN System <jiinwoojin@gmail.com>

ENV ROOTDIR=/app/jiserver \
    PROJ_VERSION="6.1.1" \
    GEOS_VERSION="3.8.0" \
    GDAL_VERSION="2.4.4" \
    CMAKE_VERSION="3.9.6" \
    POSTGRESQL_VERSION="12.1" \
    POSTGIS_VERSION="3.0.0" \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib:/usr/lib64

ENV PROJ_PATH=${ROOTDIR}/proj-${PROJ_VERSION} \
    GEOS_PATH=${ROOTDIR}/geos-${GEOS_VERSION} \
    GDAL_PATH=${ROOTDIR}/gdal-${GDAL_VERSION} \
    CMAKE_PATH=${ROOTDIR}/cmake-${CMAKE_VERSION} \
    POSTGRESQL_PATH=${ROOTDIR}/postgresql-${POSTGRESQL_VERSION}

RUN mkdir -p ${ROOTDIR}/source && mkdir -p ${ROOTDIR}/rpm

WORKDIR ${ROOTDIR}/rpm

ADD ./rpm/* ./

WORKDIR ${ROOTDIR}/source

RUN yum -y update && yum -y install scl-utils centos-release-scl git wget bzip2 zip unzip make && \
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh epel-release-latest-7.noarch.rpm && \
    yum -y install devtoolset-7

SHELL [ "/usr/bin/scl", "enable", "devtoolset-7" ]

RUN git clone https://github.com/jiinwoojin/mapproxy.git && \
    git clone https://github.com/jiinwoojin/mapserver.git && \
    wget https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz && \
    wget https://download.osgeo.org/proj/proj-datumgrid-1.8.zip && \
    wget https://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 && \
    wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    wget http://www.cmake.org/files/v3.9/cmake-${CMAKE_VERSION}.tar.gz && \
    wget https://ftp.postgresql.org/pub/source/v${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.tar.gz && \
    wget http://postgis.net/stuff/postgis-${POSTGIS_VERSION}.tar.gz && \
    tar -xf geos-${GEOS_VERSION}.tar.bz2 && \
    tar -zxf gdal-${GDAL_VERSION}.tar.gz && \
    tar -zxf cmake-${CMAKE_VERSION}.tar.gz && \
    tar -zxf postgresql-${POSTGRESQL_VERSION}.tar.gz && \
    tar -zxf postgis-${POSTGIS_VERSION}.tar.gz && \
    tar -zxf proj-${PROJ_VERSION}.tar.gz && \
    mv proj-${PROJ_VERSION} proj && \
    unzip -o -q proj-datumgrid-1.8.zip -d ${ROOTDIR}/source/proj/data/

WORKDIR ${ROOTDIR}/source/cmake-${CMAKE_VERSION}

RUN ./bootstrap && \
    make -j8 && \
    make -j8 install && \
    cmake --version

RUN yum -y install sqlite sqlite-devel autoconf perl-Test-Harness perl-Thread-Queue \
                    automake autogen-libopts libtool ncurses-devel readline readline-devel zlib zlib-devel \
                    openssl openssl-devel keyutils-libs-devel krb5-libs krb5-devel \
                    libcom_err-devel libkadm5 libselinux-devel libsepol-devel libverto-devel pcre-devel \
                    gettext gettext-common-devel gettext-devel python python-rpm-macros python-srpm-macros \
                    python-setuptools python-nose python-backports python-ipaddress python-backports-ssl_match_hostname \
                    python2-rpm-macros python-devel bison bison-devel flex flex-devel tcl tcl-devel libxml2 \
                    xz-devel libxml2-devel libxslt libgcrypt-devel libgpg-error-devel libxslt-devel openldap \
                    openldap-devel cyrus-sasl-devel pam pam-devel libicu libicu-devel gdbm gdbm-devel libdb \
                    libdb-devel pyparsing systemtap-sdt-devel perl-ExtUtils-Install perl-ExtUtils-Embed \
                    perl-ExtUtils-MakeMaker perl-ExtUtils-Manifest perl-ExtUtils-ParseXS perl-devel \
                    uuid uuid-devel libblkid libblkid-devel libmount libmount-devel libsmartcols libsmartcols-devel \
                    util-linux libuuid-devel libuuid libgudev1 systemd systemd-libs systemd-python systemd-sysv systemd-devel \
                    pam_krb5 krb5-workstation curl libcurl libcurl-devel cyrus-sasl cyrus-sasl-devel cyrus-sasl-gssapi \
                    llvm-libs llvm llvm-devel libffi-devel poppler-devel \
                    java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel libwebp libwebp-devel \
                    swig libtiff libtiff-devel libjpeg-turbo libjpeg-turbo-devel json-c json-c-devel \
                    protobuf protobuf-c protobuf-compiler protobuf-devel protobuf-lite protobuf-c-compiler protobuf-c-devel \
                    protobuf-java protobuf-python atlas atlas-devel blas blas-devel lapack lapack-devel \
                    libgfortran libquadmath numpy xml-commons-apis xml-commons-resolver xerces-j2 xalan-j2 ant lcms2 lcms2-devel \
                    libpng libpng-devel freetype freetype-devel expat expat-devel fontconfig fontconfig-devel \
                    libXpm libXpm-devel gd gd-devel giflib giflib-devel SDL agg agg-devel apr apr-util apr-devel apr-util-devel \
                    httpd-tools mailcap httpd httpd-devel gl-manpages glib2-devel libXdamage-devel libXext-devel libXfixes-devel \
                    libXrender-devel libXxf86vm-devel libdrm-devel libglvnd-core-devel libglvnd-devel libglvnd-opengl \
                    mesa-khr-devel mesa-libEGL-devel mesa-libGL-devel pixman-devel cairo cairo-devel fribidi fribidi-devel \
                    harfbuzz harfbuzz-devel graphite2-devel ruby-irb ruby-libs rubygem-bigdecimal \
                    rubygem-io-console rubygem-json rubygem-psych rubygem-rdoc rubygems ruby ruby-devel \
                    pycairo-devel libzip php-cli php-common php php-devel php-fpm librsvg2 gdk-pixbuf2-devel \
                    librsvg2-devel librsvg2-tools python-yaml python-lxml proj proj-devel proj-epsg proj-nad geos-devel

WORKDIR ${ROOTDIR}/rpm

RUN yum -y localinstall agg-devel-2.5-18.el7.x86_64.rpm arpack-3.1.3-2.el7.x86_64.rpm arpack-devel-3.1.3-2.el7.x86_64.rpm bison-devel-3.0.4-2.el7.x86_64.rpm \
            cfitsio-3.370-10.el7.x86_64.rpm cfitsio-devel-3.370-10.el7.x86_64.rpm CharLS-1.0-5.el7.x86_64.rpm CharLS-devel-1.0-5.el7.x86_64.rpm \
            cryptopp-5.6.2-10.el7.x86_64.rpm cryptopp-devel-5.6.2-10.el7.x86_64.rpm fcgi-2.4.0-25.el7.x86_64.rpm fcgi-devel-2.4.0-25.el7.x86_64.rpm \
            flex-devel-2.5.37-6.el7.x86_64.rpm freexl-1.0.5-1.el7.x86_64.rpm freexl-devel-1.0.5-1.el7.x86_64.rpm python2-pip-8.1.2-10.el7.noarch.rpm \
            libdap-3.13.1-2.el7.x86_64.rpm libdap-devel-3.13.1-2.el7.x86_64.rpm spawn-fcgi-1.6.3-5.el7.x86_64.rpm python-shapely-1.5.2-2.el7.x86_64.rpm \
            libmemcached-devel-1.0.16-5.el7.x86_64.rpm libzstd-1.4.4-1.el7.x86_64.rpm libzstd-devel-1.4.4-1.el7.x86_64.rpm pyproj-1.9.2-6.20120712svn300.el7.x86_64.rpm

WORKDIR ${ROOTDIR}/source/proj

RUN ./configure CC=gcc --disable-static && \
    make -j8 && make -j8 install && proj

WORKDIR ${ROOTDIR}/source/geos-${GEOS_VERSION}

RUN ./configure --enable-python --disable-static && make -j8 && make -j8 install && geos-config --version

WORKDIR ${ROOTDIR}/source/postgresql-${POSTGRESQL_VERSION}

RUN ./configure --enable-depend --enable-nls=ko --with-openssl \
                --with-tcl --with-python --with-gssapi --with-ldap \
                --with-pam --with-libxml --with-selinux --with-systemd \
                --with-libxslt --with-zlib --with-ossp-uuid && \
    make all -j8 && make -j8 install && cd contrib && make all -j8 && make -j8 install

ENV LD_LIBRARY_PATH=/usr/local/pgsql/lib:${LD_LIBRARY_PATH} \
    PKG_CONFIG_PATH=/usr/local/pgsql/lib/pkgconfig \
    PATH=/usr/local/pgsql/bin:${PATH}

WORKDIR ${ROOTDIR}/source/gdal-${GDAL_VERSION}

RUN ./configure --with-libtiff --with-geotiff=internal \
                --with-jpeg --with-png --with-libz \
                --with-threads --with-python --with-geos \
                --with-pg --with-java --with-poppler \
                --with-expat --with-sqlite3 --with-proj --enable-shared && \
    make -j8 && make -j8 install && gdal-config --version

WORKDIR ${ROOTDIR}/source/postgis-${POSTGIS_VERSION}

RUN ./configure --with-pgconfig=/usr/local/pgsql/bin/pg_config --with-gdalconfig=/usr/local/bin/gdal-config \
                --with-geosconfig=/usr/local/bin/geos-config && \
    make -j8 && make -j8 install

WORKDIR ${ROOTDIR}/source/mapserver

RUN mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DHARFBUZZ_INCLUDE_DIR=/usr/include/harfbuzz \
          -DWITH_CLIENT_WFS=ON \
          -DWITH_CLIENT_WMS=ON \
          -DWITH_CURL=ON \
          -DWITH_GDAL=ON \
          -DWITH_GIF=ON \
          -DWITH_ICONV=ON \
          -DWITH_KML=ON \
          -DWITH_LIBXML2=ON \
          -DWITH_OGR=ON \
          -DWITH_PROJ=ON \
          -DWITH_SOS=ON \
          -DWITH_THREAD_SAFETY=ON \
          -DWITH_WCS=ON \
          -DWITH_WFS=ON \
          -DWITH_WMS=ON \
          -DWITH_FCGI=ON \
          -DWITH_FRIBIDI=ON \
          -DWITH_CAIRO=ON \
          -DWITH_HARFBUZZ=ON \
          -DWITH_JAVA=ON \
          -DWITH_PHP=ON \
          -DWITH_PERL=ON \
          -DWITH_PROTOBUF=ON \
          -DWITH_POSTGIS=ON \
          .. && \
    make -j8 && make -j8 install && ldconfig && mapserv -v

WORKDIR ${ROOTDIR}/source/mapproxy

RUN pip install --upgrade pip && pip install Pillow && pip freeze && \
    python setup.py build && python setup.py install

WORKDIR ${ROOTDIR}

RUN rm -rf ./source ./rpm

EXPOSE 8080