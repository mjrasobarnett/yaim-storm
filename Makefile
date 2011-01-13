NAME := ig-yaim-storm
prefix=$(PREFIX)
PACKAGE=ig-yaim-storm
VERSION=4.0.9
VERSION_=`echo $(VERSION) | tr '.' '_'`
RELEASE=10
FULLNAME := $(NAME)-$(VERSION)

REMOTE_USER=`whoami`
SEP=------------------------------------------
LOG=${HOME}/build_$(PACKAGE).log

SL4_PUB_PATH_32=/rep/repo/ig_sl4-i386/3_1_0/
SL4_PUB_PATH_64=/rep/repo/ig_sl4-x86_64/3_1_0/
#SL5_PUB_PATH_32=/rep/repo/ig_sl5-i386/3_2_0/
SL5_PUB_PATH_64=/rep/repo/ig_sl5-x86_64/3_2_0/
SL4_TEST_PATH_32=/rep/repo/ig-cert_sl4-i386/3_1_0/
SL4_TEST_PATH_64=/rep/repo/ig-cert_sl4-x86_64/3_1_0/
#SL5_TEST_PATH_32=/rep/repo/ig-cert_sl5-i386/3_2_0/
SL5_TEST_PATH_64=/rep/repo/ig-cert_sl5-x86_64/3_2_0/
SVN_URL=https://svn.forge.cnaf.infn.it/svn/igrelease
SVN_TAG=$(NAME)-$(VERSION_)-$(RELEASE)

FILES := defaults/ examples/ functions/ node-info.d/ Makefile

# commented out for ETICS 
_builddir  := $(shell rpm --eval %_builddir)
_specdir   := $(shell rpm --eval %_specdir)
_sourcedir := $(shell rpm --eval %_sourcedir)
_rpmdir    := $(shell rpm --eval %_rpmdir)

#_builddir  := rpmbuild/BUILD/
#_specdir   := rpmbuild/SPECS/
#_sourcedir := rpmbuild/SOURCES/
#_rpmdir    := rpmbuild/RPMS/

install:
	@echo $(SEP)
	@echo "> Installing rpm..."
	@mkdir -p $(prefix)/yaim/defaults
	@mkdir -p $(prefix)/yaim/etc
	@mkdir -p $(prefix)/yaim/etc/versions
	@mkdir -p $(prefix)/yaim/examples/siteinfo/services
	@mkdir -p $(prefix)/yaim/examples/siteinfo/vo.d
	@mkdir -p $(prefix)/yaim/functions/local
	@mkdir -p $(prefix)/yaim/node-info.d
	@mkdir -p $(prefix)/yaim/libexec
	@echo "$(PACKAGE) $(VERSION)-$(RELEASE)" > $(prefix)/yaim/etc/versions/$(PACKAGE)
	@install -m 0644 defaults/*                           $(prefix)/yaim/defaults
	@install -m 0644 examples/siteinfo/services/*         $(prefix)/yaim/examples/siteinfo/services
	@install -m 0755 functions/config*                    $(prefix)/yaim/functions/local
	@install -m 0644 node-info.d/*                        $(prefix)/yaim/node-info.d

tar:
	@echo $(SEP)
	@echo "> Updating from SVN..."
	@svn update
	@echo $(SEP)
	@echo "> Packing..."
	@rm -rf $(FULLNAME)/
	@mkdir $(FULLNAME)
	@cp -r $(FILES) $(FULLNAME)
	@tar czvf $(FULLNAME).tar.gz $(FULLNAME)/ > $(LOG)
	@rm -rf $(FULLNAME)/

rpm_local: tar
	@echo $(SEP)
	@echo "> Creating rpm..."
	@mv $(FULLNAME).tar.gz $(_sourcedir)
	@echo "> Source DIR ... $(_sourcedir)"
	@sed -e s/VV/$(VERSION)/ -e s/NNAME/$(NAME)/ -e s/RR/$(RELEASE)/ specfile.spec > specfile_tmp.spec
	@rpmbuild -ba specfile_tmp.spec > $(LOG)
	@rm -f specfile_tmp.spec

rpm:
	@echo "> Creating rpm..."
	@mkdir -p  rpmbuild/RPMS/noarch
	@mkdir -p  rpmbuild/SRPMS/
	@mkdir -p  rpmbuild/SPECS/
	@mkdir -p  rpmbuild/SOURCES/
	@mkdir -p  rpmbuild/BUILD/
	@tar --gzip --exclude='*svn*' -cf rpmbuild/SOURCES/${PACKAGE}.src.tgz *
	@sed -e s/VV/$(VERSION)/ -e s/NNAME/$(NAME)/ -e s/RR/$(RELEASE)/ specfile.spec > specfile_tmp.spec
	@rpmbuild -ba specfile_tmp.spec > $(LOG)
	@rm -f specfile_tmp.spec

clean:
	@echo $(SEP)
	@echo "> Cleaning..."
	@rm -rf rpmbuild
#	@rm -rf $(FULLNAME).tar.gz $(FULLNAME)/ specfile_tmp.spec

commit:
	@echo $(SEP)
	@echo "> Committing changes..."
	@svn commit

test: rpm_local
	@echo $(SEP)
	@echo "> Copying..."
	@chmod 0664 $(_rpmdir)/noarch/$(FULLNAME)-$(RELEASE).noarch.rpm
	@sudo cp -p $(_rpmdir)/noarch/$(FULLNAME)-$(RELEASE).noarch.rpm $(SL4_TEST_PATH_32)
	@sudo cp -p $(_rpmdir)/noarch/$(FULLNAME)-$(RELEASE).noarch.rpm $(SL4_TEST_PATH_64)
	@sudo cp -p $(_rpmdir)/noarch/$(FULLNAME)-$(RELEASE).noarch.rpm $(SL5_TEST_PATH_64)
	@echo $(SEP)
	@echo "> Updating **CERTIFICATION** repositories (SL4/SL5)..."
	@sudo mrepo_wrapped -gufv ig-cert_sl4 ig-cert_sl5

pub: rpm_local
        # Commented out to avoid unwanted commit
	#@echo $(SEP)
	#@echo "> Committing changes..."
	#@svn commit -m "New Version"
	@echo $(SEP)
	@echo "> Copying..."
	@chmod 0664 $(_rpmdir)/noarch/$(FULLNAME)-$(RELEASE).noarch.rpm
	@sudo cp -p $(_rpmdir)/noarch/$(FULLNAME)-$(RELEASE).noarch.rpm $(SL4_PUB_PATH_32)
	@sudo cp -p $(_rpmdir)/noarch/$(FULLNAME)-$(RELEASE).noarch.rpm $(SL4_PUB_PATH_64)
	@sudo cp -p $(_rpmdir)/noarch/$(FULLNAME)-$(RELEASE).noarch.rpm $(SL5_PUB_PATH_64)
	@echo $(SEP)
	@echo "> Updating **PRODUCTION** repositories (SL4)..."
	@sudo mrepo_wrapped -gufv ig_sl4 ig_sl5
	@echo $(SEP)
	@echo "> Tagging ($(SVN_TAG))..."
	@svn copy . $(SVN_URL)/tags/$(SVN_TAG) -m "Tag $(SVN_TAG)"
