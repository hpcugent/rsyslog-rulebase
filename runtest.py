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

import glob
import json
import os
import pprint
import re
import shutil
import sys
from unittest.case import TestCase
from vsc.utils.run import run_asyncloop
from vsc.utils.generaloption import simple_option

"""
Test the mmnormalize rules for rsyslog usage.

To test a new expression, add a new entry with
{ "raw": "actual raw message" }
to the begin of the 00_first data file, and run with -F option
(or to the zz_last data file and use -L option).
The test will fail and dump the results as seen by logstash.
Then you can construct the expected output and create
the "expected" dictionary.

The raw message is what is being sent to rsyslog

@author: Stijn De Weirdt (Ghent University)
@author: Andy Georges (Ghent University)
"""

# liblognorm 2.0.3 (or later)
# clone and install
# PREFIX=$HOME/rsyslog-test/
#    - git clone git@github.com:rsyslog/libfastjson.git and build it
#    - git clone git@github.com:rsyslog/libestr.git and build it
#    - git clone git@github.com:rsyslog/liblognorm.git and build it
# run tests with
# PATH=$PREFIX/bin:$PATH ./runtest.py


_log = None

RULEBASE_DIR = '/tmp/rsyslog-rulebase'

DEFAULT_LIBLOGNORM_VERSION = '2.0.3'

# missing configfile value to -f
LIBLOGNORM_COMMAND = [
    'lognormalizer',
    '-r', os.path.join(RULEBASE_DIR, 'mmnormalize_rules.rb'),
]

def prep_liblognorm():
    """Prepare the environment"""
    try:
        shutil.rmtree(RULEBASE_DIR)
    except:
        pass
    shutil.copytree(os.path.join(os.getcwd(), 'files'), RULEBASE_DIR)


def get_data(directory='data', globpattern='*'):
    """Read the input data"""
    datafiles = glob.glob("%s/%s" % (directory, globpattern))
    datafiles.sort()
    input = []
    results = []
    for fn in datafiles:
        execfile(fn)
        if 'data' in locals():
            _log.debug('Data found in datafile %s' % fn)
            for test in locals().pop('data'):
                input.append(test['raw'])
                results.append(test.get('expected', None))
        else:
            _log.debug('No data found in datafile %s' % fn)
    return input, results


def process(stdout, expected_size):
    """Take in stdout, return list of dicts that are created via loading the json output"""
    ignore = re.compile(r'(:message=>)')
    output = []
    lines = []
    warning = re.compile("warning:")
    for line in stdout.split("\n"):
        if not line.strip():
            continue
        if ignore.search(line):
            continue
        try:
            res = json.loads(line)
        except:
            if not warning.search(line):
                _log.error("Can't load line as json: %s." % line)
                sys.exit(1)
        else:
            output.append((res, line))

    if len(output) != expected_size:
        _log.error("outputs size %s not expected size %s: (%s)" % (len(output), expected_size, output))
        sys.exit(1)

    _log.debug("Returning processed output list %s" % output)
    return output


def test(output, input, results):
    """Perform the tests"""
    # zip(output, input, results), but need to check if output is in same order as input/results
    sorted_zip = []
    for idx, out_line in enumerate(output):
        out = out_line[0]
        line = out_line[1]
        if out is {}:
            _log.error("no viable output retrieved for idx %s: %s" % (idx, out))
            sys.exit(1)
        sorted_zip.append((out, line, input.pop(), results.pop()))

    counter = [0, 0]
    for out, line, inp, res in sorted_zip:
        if res is None:
            _log.error("Input %s converted in out %s" % (inp, pprint.pformat(output)))
            sys.exit(2)

        _log.debug("Input: %s" % inp)
        _log.debug("Expected Results: %s" % res)
        _log.debug("Output: %s" % out)

        counter[0] += 1
        t = TestCase('assertEqual')

        for k, v in res.items():
            counter[1] += 1

            if not unicode(k) in out:
                _log.error("key %s missing from output \n%s\n for inp \n%s" % (k, pprint.pformat(out), inp))
                sys.exit(1)

            res_out = out[unicode(k)]
            try:
                t.assertEqual(res_out, v)
            except AssertionError:
                tmpl = "key %s value %s (type %s), expected %s (type %s)"
                _log.error(tmpl % (k, res_out, type(res_out), v, type(v)))
                _log.debug("Full out %s from line %s" % (pprint.pformat(out), line))
                sys.exit(1)

    _log.info("Verified %s lines with %s subtests. All OK" % (counter[0], counter[1]))


def main(indices):
    """The main, only test the indices passed"""
    prep_liblognorm()
    input, results = get_data()
    if indices:
        for indx in indices:
            _log.debug("Test index %d => input: %s" % (indx, input[indx]))
            _log.debug("Test index %d => results: %s" % (indx, results[indx]))

        try:
            input = [input[idx] for idx in indices]
            results = [results[idx] for idx in indices]
        except IndexError, e:
            _log.error('Provided indices %s exceed avail data items %s' % (indices, len(input)))
            sys.exit(1)

    ec, stdout = run_asyncloop(cmd=LIBLOGNORM_COMMAND, input="\n".join(input + ['']))

    output = process(stdout, len(input))
    print "output: %s" % output
    test(output, input, results)


if __name__ == '__main__':
    opts = {
        "last": ("Only test last data entry", None, "store_true", False, 'L'),
        "first": ("Only test first data entry", None, "store_true", False, 'F'),
        "entries": ("Indices of data entries to test", "strlist", "store", None, 'E'),
    }
    go = simple_option(opts)
    indices = None
    if go.options.first:
        indices = [0]
    elif go.options.last:
        indices = [-1]
    elif go.options.entries:
        indices = [int(x) for x in go.options.entries]

    _log = go.log

    main(indices)
