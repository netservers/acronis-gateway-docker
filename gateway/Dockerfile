FROM centos:7

MAINTAINER John McEleney

RUN rpm -i http://dl.managed-protection.com/u/storage/repos/1.6/CentOS/7/x86_64/acronis-storage-repo-1.6.noarch.rpm && \
    yum install -y acronis-storage-gateway acronis-storage-backend-local cronie python-setuptools epel-release && \
    yum install -y xmlstarlet && \
    easy_install supervisor && \
    mkdir -p /var/log/supervisor /etc/supervisor/conf.d
ADD supervisord.conf /etc/supervisor/
ADD acronis.conf /etc/supervisor/conf.d/
VOLUME ["/var/lib/Acronis/storage", "/etc/Acronis", "/etc/pki/tls/certs/Acronis/storage/" ]
ADD entrypoint.sh /
CMD /entrypoint.sh
