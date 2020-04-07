FROM paas-docker-artifactory.gannettdigital.com/paas-centos7-base:latest
MAINTAINER PaaS-Delivery <paas-delivery@gannett.com>

ENV NGINX_VERSION 1.11.3-1.el7.centos.ngx


RUN curl -s https://packagecloud.io/install/repositories/adilnaimi/nginx-vts-rpm/script.rpm.sh | bash
RUN yum update -y
RUN yum install -y https://extras.getpagespeed.com/release-el7-latest.rpm nginx-module-vts-v0.1.15-1.el7.wso.x86_64


#RUN git clone git://github.com/vozlt/nginx-module-vts.git
RUN yum install -y nginx-${NGINX_VERSION} nginx-module-vts nginx-module-nbr 

# manage nginx directory
RUN mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled

# create base configuration
COPY nginx_status /etc/nginx/sites-available/nginx_status
COPY nginx.conf /etc/nginx/

RUN ln -s /etc/nginx/sites-available/nginx_status /etc/nginx/sites-enabled/nginx_status

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /opt/nginx
COPY config/* /opt/nginx/
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/

EXPOSE 80 443 8140

CMD ["nginx", "-g", "daemon off;"]
