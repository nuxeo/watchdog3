.. include:: global.rst.inc

.. _hacking:

Contributing
============
Welcome hacker! So you have got something you would like to see in
|project_name|? Whee. This document will help you get started.

Important URLs
--------------
|project_name| uses git_ to track code history and hosts its `code repository`_
at github_. The `issue tracker`_ is where you can file bug reports and request
features or enhancements to |project_name|.

Before you start
----------------
Ensure your system has the following programs and libraries installed before
beginning to hack:

1. Python_
2. git_
3. ssh
4. XCode_ (on Mac OS X)

Enabling Continuous Integration
-------------------------------
The repository checkout contains a script called ``autobuild.sh``
which you must run prior to making changes. It will detect changes to
Python source code or restructuredText documentation files anywhere
in the directory tree and rebuild sphinx_ documentation, run all tests using pytest and generate coverage_ reports.

Start it by issuing this command in the ``watchdog`` directory
checked out earlier::

    $ tools/autobuild.sh
    ...

Happy hacking!
