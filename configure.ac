# Copyright (c) Istituto Nazionale di Fisica Nucleare (INFN). 2006-2010.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Authors: Alberto Forti <alberto.forti@cnaf.infn.it>
#

AC_PREREQ([2.59])
AC_INIT([yaim storm], [4.1.7])
AC_CONFIG_AUX_DIR([./project])
AC_CONFIG_SRCDIR([defaults/se_storm_backend.pre])
AM_INIT_AUTOMAKE
AC_CONFIG_MACRO_DIR([m4])

# Release number
osdist=`cat /etc/redhat-release | awk 'BEGIN {FS="release "} {print $2}'| awk 'BEGIN {FS="."} {print $1}'`
AC_SUBST([YAIM_STORM], [sl$osdist])
AC_SUBST([YAIM_STORM_AGE_NUMBER], [1])

# Notices.
AC_COPYRIGHT([See LICENCE file for details])
AC_REVISION([$Revision: $])

#Environment.
WORKDIR=`pwd`
AC_SUBST(WORKDIR)

DEFAULT_RPM_DIR=`pwd`

AC_PROG_CC
AC_PROG_CXX
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_LIBTOOL
AM_PROG_CC_C_O
AC_PROG_INSTALL

AC_STORM([])

# Installation prefix
#AC_PREFIX_DEFAULT([/etc])

# Configuration items
AM_CONFIG_HEADER([etc/autogen/config.h])

AC_CONFIG_FILES([Makefile])

AC_CONFIG_FILES([defaults/Makefile])
AC_CONFIG_FILES([examples/Makefile])
AC_CONFIG_FILES([examples/siteinfo/Makefile])
AC_CONFIG_FILES([examples/siteinfo/services/Makefile])
AC_CONFIG_FILES([functions/Makefile])
AC_CONFIG_FILES([functions/utils/Makefile])
AC_CONFIG_FILES([node-info.d/Makefile])
AC_CONFIG_FILES([yaim-storm.spec])

AC_OUTPUT

