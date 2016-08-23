FROM shoifele/bone-centos

MAINTAINER Christoph Wiechert <wio@psitrax.de>

ENV REFRESHED_AT="2016-04-25" \
    DB_HOST="postgres" \
    DB_NAME="bareos" \
    DB_USER="bareos" \
    DB_PASS="bareos" \
    BAREOS_DB_VERSION="2004"

RUN curl -Ls http://download.bareos.org/bareos/release/latest/CentOS_7/bareos.repo \
    > /etc/yum.repos.d/bareos.repo \
  && yum -y install \
    bareos-director \
    bareos-database-tools \
    bareos-database-common \
    bareos-common \
    bareos-bconsole \
    bareos-tools \
    bareos-database-postgresql \
    jansson \
    libfastlz \
    lzo \
    postgresql-libs \
    postgresql \
    MySQL-python \
    python-psycopg2 \
  && yum clean all

ADD rootfs /
#Icinga plugin for monitoring 
RUN git clone https://github.com/widhalmt/check_bareos.git /scripts/check_bareo

EXPOSE 9101
VOLUME /etc/bareos

CMD ["/init"]
