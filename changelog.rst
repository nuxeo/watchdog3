.. :changelog:

API changes
-----------

0.8.5
~~~~~

- `WATCHDOG-19 <https://jira.nuxeo.com/browse/WATCHDOG-19>`__: Removed ``utils.compat.queue`` and ``utils.compat.Event``,
   added ``utils.compat.Queue`` and ``utils.compat.Empty``.


0.8.4
~~~~~

- `WATCHDOG-1 <https://jira.nuxeo.com/browse/WATCHDOG-1>`__: Ensure ``InotifyEvent.name`` is decoded.
- `WATCHDOG-11 <https://jira.nuxeo.com/browse/WATCHDOG-11>`__: Removed the ``watchemdo`` utility.


0.8.2
~~~~~

- Event emitters are no longer started on schedule if ``Observer`` is not
  already running.


0.8.0
~~~~~

- ``DirectorySnapshot``: methods returning internal stat info replaced by
  ``mtime``, ``inode`` and ``path`` methods.
- ``DirectorySnapshot``: ``walker_callback`` parameter deprecated.
