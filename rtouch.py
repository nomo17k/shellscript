#!/usr/bin/env python2.6
"""
Update the access time of the directory and the files and
subdirectories it contains using the Linux `touch` command.
"""
from glob import glob
from optparse import OptionParser
import os
import subprocess
import sys
import time


__version__ = '20100630'


def onerror(e):
    print >> sys.stderr, e
    return


def do_cmd(path):
    if len(glob(path)) == 0:
        onerror('nothing found with %s' % path)
        return
    # Really want to use '-h' option here as well, but older versions
    # of touch do not support it.
    #cmd = 'touch -a -c -h %s' % path
    cmd = 'touch -a -c %s' % path
    print cmd
    subprocess.Popen(cmd, shell=True, stdout=sys.stdout, stderr=sys.stderr)


def rtouch(paths):
    """
    paths -- list of paths to the top-most directories
    """

    print time.asctime(time.localtime())

    for path in paths:
        if not os.path.isdir(path):
            onerror('skip %s: not a directory' % path)
            continue

        for parent, subs, fs in os.walk(path, topdown=False, onerror=onerror):
            do_cmd('%s/*' % parent)

        # The top-most directory has not been included in touch-ing,
        # so do it here.
        do_cmd('%s' % path)

    return


if __name__ == '__main__':
    usage = 'usage: %prog [options] dir1 [dir2 ...]'
    p = OptionParser(usage=usage, description=__doc__.strip(),
                     version='%prog '+__version__)
    opts, args = p.parse_args()
    rtouch(args)
