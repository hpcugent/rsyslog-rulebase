#!/usr/bin/env python
# -*- coding: latin-1 -*-
#
# Copyright 2017-2017 Ghent University
#
# This file is part of rsyslog-rulebase
# originally created by the HPC team of Ghent University (http://ugent.be/hpc/en),
# with support of Ghent University (http://ugent.be/hpc),
# the Flemish Supercomputer Centre (VSC) (https://vscentrum.be/nl/en),
# the Hercules foundation (http://www.herculesstichting.be/in_English)
# and the Department of Economy, Science and Innovation (EWI) (http://www.ewi-vlaanderen.be/en).
#
# http://github.com/hpcugent/rsyslog-rulebase
#
# rsyslog-rulebase is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation v2.
#
# rsyslog-rulebase is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with rsyslog-rulebase. If not, see <http://www.gnu.org/licenses/>.
#
"""Basic setup.py for building the rsyslog-rulebase"""

import sys
import os
from distutils.core import setup
import glob

setup(name="rsyslog-rulebase",
      version="0.1",
      description="Rules for rsyslog-mmnormalize",
      long_description="""Rulebase that allows the rsyslog mmnormalize plugin to 
      transform log lines into structured data.

      See also http://www.liblognorm.com/files/manual/.
""",
      license="LGPL",
      author="HPC UGent",
      author_email="hpc-admin@lists.ugent.be",
      # keep MANIFEST.in in sync (EL6 packaging issue)
      data_files=[("/var/lib/rsyslog", glob.glob("files/*")),
                  ],
      url="http://www.ugent.be/hpc")
