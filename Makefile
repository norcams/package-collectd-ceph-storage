NAME=python-collectd-ceph-storage
VERSION=0.0.2
PACKAGE_VERSION=2
DESCRIPTION=package.description
URL=package.url
MAINTAINER="https://github.com/norcams"
RELVERSION=7

.PHONY: default
default: deps build rpm
package: rpm

.PHONY: clean
clean:
	rm -fr /installdir
	rm -f $(NAME)-$(VERSION)-*.rpm
	rm -Rf vendor/

.PHONY: deps
deps:
	yum install -y gcc ruby-devel rpm-build
	gem install -N fpm
	yum install -y python-devel python-virtualenv git libyaml-devel

.PHONY: build
build:
	mkdir vendor/
	mkdir -p /installdir/usr/lib/python2.7/site-packages/
	pip install --ignore-installed --prefix=/installdir/usr/ git+git://github.com/norcams/collectd-ceph-storage.git#egg=collectd_ceph_storage

.PHONY: rpm
rpm:
	/usr/local/bin/fpm -s dir -t rpm \
		-n $(NAME) \
		-v $(VERSION) \
		--iteration "$(PACKAGE_VERSION).el$(RELVERSION)" \
		--description "$(shell cat $(DESCRIPTION))" \
		--url "$(shelpl cat $(URL))" \
		--maintainer "$(MAINTAINER)" \
		-C /installdir/ \
		.
