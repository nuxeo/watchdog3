Watchdog
========
Python API and shell utilities to monitor file system events.

This is a fork of http://github.com/gorakhargosh/watchdog for Python 3 and intended for `Nuxeo Drive`_.
This is not an official Watchdog nextgen repository but it will be kept alive by Nuxeo and PR are welcome.

This is a drop-in replacement of the original watchdog module. Only thee module name changes at installation time.


Example API Usage
-----------------
A simple program that uses watchdog to monitor directories specified
as command-line arguments and logs events generated:
    
.. code-block:: python

    import sys
    import time
    import logging
    from watchdog.observers import Observer
    from watchdog.events import LoggingEventHandler

    if __name__ == "__main__":
        logging.basicConfig(level=logging.INFO,
                            format='%(asctime)s - %(message)s',
                            datefmt='%Y-%m-%d %H:%M:%S')
        path = sys.argv[1] if len(sys.argv) > 1 else '.'
        event_handler = LoggingEventHandler()
        observer = Observer()
        observer.schedule(event_handler, path, recursive=True)
        observer.start()
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            observer.stop()
        observer.join()


Installation
------------
Installing from PyPI using ``pip``:
    
.. code-block:: bash

    $ pip install watchdog3

Installing from PyPI using ``easy_install``:
    
.. code-block:: bash

    $ easy_install watchdog3

Installing from source:
    
.. code-block:: bash

    $ python setup.py install


Documentation
-------------
You can browse the latest release documentation_ online.

Contribute
----------
Fork the `repository`_ on GitHub and send a pull request, or file an issue
ticket at the `issue tracker`_. For general help and questions use the official
`mailing list`_ or ask on `stackoverflow`_ with tag `python-watchdog`.

Create and activate your virtual environment, then::

    python -m pip install --user pytest
    python -m pip install -e .
    python -m pytest tests


Supported Platforms
-------------------
* Linux 2.6 (inotify)
* Mac OS X (FSEvents, kqueue)
* FreeBSD/BSD (kqueue)
* Windows (ReadDirectoryChangesW with I/O completion ports;
  ReadDirectoryChangesW worker threads)
* OS-independent (polling the disk for directory snapshots and comparing them
  periodically; slow and not recommended)

Note that when using watchdog with kqueue, you need the
number of file descriptors allowed to be opened by programs
running on your system to be increased to more than the
number of files that you will be monitoring. The easiest way
to do that is to edit your ``~/.profile`` file and add
a line similar to::

    ulimit -n 1024

This is an inherent problem with kqueue because it uses
file descriptors to monitor files. That plus the enormous
amount of bookkeeping that watchdog needs to do in order
to monitor file descriptors just makes this a painful way
to monitor files and directories. In essence, kqueue is
not a very scalable way to monitor a deeply nested
directory of files and directories with a large number of
files.

About using watchdog with editors like Vim
------------------------------------------
Vim does not modify files unless directed to do so.
It creates backup files and then swaps them in to replace
the files you are editing on the disk. This means that
if you use Vim to edit your files, the on-modified events
for those files will not be triggered by watchdog.
You may need to configure Vim to appropriately to disable
this feature.


Dependencies
------------
1. Python 2.6 or above.
2. pathtools_
3. XCode_ (only on Mac OS X)


Licensing
---------
Watchdog is licensed under the terms of the `Apache License, version 2.0`_.

Copyright 2011 `Yesudeep Mangalapilly`_.

Copyright 2012 Google, Inc.

Copyright 2018 Nuxeo.

Project `source code`_ is available at Github. Please report bugs and file
enhancement requests at the `issue tracker`_.

Why Watchdog?
-------------
Too many people tried to do the same thing and none did what I needed Python
to do:

* pnotify_
* `unison fsmonitor`_
* fsmonitor_
* guard_
* pyinotify_
* `inotify-tools`_
* jnotify_
* treewalker_
* `file.monitor`_
* pyfilesystem_

.. links:
.. _Nuxeo Drive: https://github.com/nuxeo/nuxeo-drive
.. _Yesudeep Mangalapilly: yesudeep@gmail.com
.. _source code: https://github.com/nuxeo/watchdog3
.. _issue tracker: https://github.com/nuxeo/watchdog3/issues
.. _Apache License, version 2.0: http://www.apache.org/licenses/LICENSE-2.0
.. _documentation: http://packages.python.org/watchdog/
.. _stackoverflow: http://stackoverflow.com/questions/tagged/python-watchdog
.. _mailing list: http://groups.google.com/group/watchdog-python
.. _repository: https://github.com/nuxeo/watchdog3

.. _homebrew: http://mxcl.github.com/homebrew/
.. _XCode: http://developer.apple.com/technologies/tools/xcode.html
.. _pathtools: http://github.com/gorakhargosh/pathtools

.. _pnotify: http://mark.heily.com/pnotify
.. _unison fsmonitor: https://webdav.seas.upenn.edu/viewvc/unison/trunk/src/fsmonitor.py?view=markup&pathrev=471
.. _fsmonitor: http://github.com/shaurz/fsmonitor
.. _guard: http://github.com/guard/guard
.. _pyinotify: http://github.com/seb-m/pyinotify
.. _inotify-tools: http://github.com/rvoicilas/inotify-tools
.. _jnotify: http://jnotify.sourceforge.net/
.. _treewalker: http://github.com/jbd/treewatcher
.. _file.monitor: http://github.com/pke/file.monitor
.. _pyfilesystem: http://code.google.com/p/pyfilesystem
