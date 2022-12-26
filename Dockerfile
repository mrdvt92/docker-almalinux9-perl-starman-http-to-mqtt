FROM centos:7

ENV container docker

RUN echo "Install from CentOS and EPEL repos"
RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install perl-Plack perl-Net-MQTT-Simple perl-JSON-XS

RUN echo "Install Starman and Dependancies from OpenFusion RPM repo"
RUN yum -y install http://repo.openfusion.net/centos7-x86_64/openfusion-release-0.8-1.of.el7.noarch.rpm
RUN yum -y install perl-Starman --enablerepo=of

RUN echo "Install Plack Middleware from DavisNetworks RPM repo"
RUN yum -y install http://linux.davisnetworks.com/el7/updates/mrdvt92-release-8-2.el7.mrdvt92.noarch.rpm
RUN yum -y install 'perl(Plack::Middleware::Favicon_Simple)' 'perl(Plack::Middleware::Method_Allow)'
#RUN yum -y install perl-App-cpanminus
#RUN cpanm Plack::Middleware::Favicon_Simple Plack::Middleware::Method_Allow

#Install PSGI Application into /app/ folder
COPY ./app.psgi /app/

#Expose Starman web server on port 80
EXPOSE 80

#Command to start app
CMD ["/usr/bin/starman", "--workers", "2", "--port", "80", "/app/app.psgi"]
