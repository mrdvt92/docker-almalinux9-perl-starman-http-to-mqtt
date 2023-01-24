Name:		perl-starman-http-to-mqtt
Version:	0.01
Release:	2%{?dist}
Summary:	Perl Starman HTTP to MQTT Service
Group:		System Environment/Daemons
License:	MIT
URL:		https://github.com/mrdvt92/docker-centos7-perl-starman-http-to-mqtt
Source0:	https://github.com/mrdvt92/docker-centos7-perl-starman-http-to-mqtt/perl-starman-http-to-mqtt-%{version}.tar.gz
Requires:	perl(Plack)
Requires:	perl(Net::MQTT::Simple)
Requires:	perl(JSON::XS)
Requires:	perl(Starman)
Requires:	perl(Plack::Middleware::Favicon_Simple)
Requires:	perl(Plack::Middleware::Method_Allow)
Requires:	systemd
Requires:	firewalld

%description
Starman PSGI server which publishes HTTP GET URLs to MQTT

%prep
%setup -q

%build

%post
echo "open port 81 for http"
firewall-cmd --permanent --add-port=81/tcp
firewall-cmd --reload
echo "enable %{name}.service"
systemctl enable %{name}.service
echo "restart %{name}.service"
systemctl restart %{name}.service
true

%install
mkdir -p    $RPM_BUILD_ROOT/%{_datadir}/%{name}/
cp app.psgi $RPM_BUILD_ROOT/%{_datadir}/%{name}/
cp LICENSE  $RPM_BUILD_ROOT/%{_datadir}/%{name}/
mkdir -p    $RPM_BUILD_ROOT/%{_unitdir}/
cp %{name}.service $RPM_BUILD_ROOT/%{_unitdir}/

%files
%defattr(-,root,root,-)
%doc %{_datadir}/%{name}/LICENSE
%{_datadir}/%{name}/app.psgi
%{_unitdir}/%{name}.service

%changelog
