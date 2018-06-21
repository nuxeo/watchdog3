.. :changelog:

API changes
-----------

0.8.4
~~~~~

- `WATCHDOG-1 <https://jira.nuxeo.com/browse/WATCHDOG-1>`__: Ensure ``InotifyEvent.name`` is decoded.


0.8.2
~~~~~

- Event emitters are no longer started on schedule if ``Observer`` is not
  already running.


0.8.0
~~~~~

- ``DirectorySnapshot``: methods returning internal stat info replaced by
  ``mtime``, ``inode`` and ``path`` methods.
- ``DirectorySnapshot``: ``walker_callback`` parameter deprecated.
