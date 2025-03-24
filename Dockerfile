FROM almalinux:9

RUN echo "Install from CentOS and EPEL repos"
RUN yum -y install epel-release
RUN yum -y update

RUN echo "Install Starman and Dependancies from DavisNetworks RPM repo"
RUN yum -y install https://linux.davisnetworks.com/el9/updates/mrdvt92-release-8-3.el9.mrdvt92.noarch.rpm
RUN yum -y install perl-Starman perl-Plack perl-Net-MQTT-Simple perl-JSON-XS \
           'perl(Plack::Middleware::Favicon_Simple)' 'perl(Plack::Middleware::Method_Allow)'

#Install PSGI Application into /app/ folder
COPY ./app.psgi /app/

#Expose Starman web server on port 80
EXPOSE 80

#Command to start app
CMD ["/usr/bin/starman", "--workers", "2", "--port", "80", "/app/app.psgi"]
