# SQLite3MultipleCiphers

The project **SQLite3 Multiple Ciphers** implements an encryption extension for [SQLite](https://www.sqlite.org) with support for multiple ciphers. In the past the encryption extension was bundled with the project [wxSQLite3](https://github.com/utelle/wxsqlite3), which provides a thin SQLite3 database wrapper for [wxWidgets](https://www.wxwidgets.org/).

In the course of time several developers had asked for a stand-alone version of the _wxSQLite3 encryption extension_. Originally it was planned to undertake the separation process already in 2019, but due to personal matters it had to be postponed for several months. However, maybe that wasn't that bad after all, because there were changes to the public SQLite code on Feb 7, 2020: [“Simplify the code by removing the unsupported and undocumented SQLITE_HAS_CODEC compile-time option”](https://www.sqlite.org/src/timeline?c=5a877221ce90e752). These changes took effect with the release of SQLite version 3.32.0 on May 22, 2020. As a consequence, all SQLite encryption extensions out there will not be able to easily support SQLite version 3.32.0 and later.

In late February 2020 work started on a new implementation of a SQLite encryption extension that will be able to support SQLite 3.32.0 and later. The new approach is based on [SQLite's VFS feature](https://www.sqlite.org/vfs.html). This approach has its pros and cons. On the one hand, the code is less closely coupled with SQLite itself; on the other hand, access to SQLite's internal data structures is more complex.

This project is _Work In Progress_. As of December 2020, the code base is now rather stable, however, further major code modifications and/or reorganizations may still occur.

The code was mainly developed under Windows, but was tested under Linux as well. At the moment no major issues are known.

## Version history

* 1.1.4 - *January 2021*
  - Based on SQLite version 3.34.1
* 1.1.3 - *December 2020*
  - Added code for AES hardware support on ARM platforms
  - Added GitHub Actions for CI
* 1.1.2 - *December 2020*
  - Fixed a bug on cipher configuration via PRAGMA commands or URI parameters
  - Added SQLite3 Multple Ciphers version info to shell application
* 1.1.1 - *December 2020*
  - Fixed a bug on removing encryption from an encrypted database
* 1.1.0 - *December 2020*
  - Based on SQLite version 3.34.0
  - Added code for AES hardware support on x86 platforms
  - Fixed issues with sqlite3_key / sqlite3_rekey
* 1.0.1 - *October 2020*
  - Added VSV extension (_V_ariably _S_eparated _V_alues)
* 1.0.0 - *August 2020*
  - First public release, based on SQLite version 3.33.0

## How to participate

**Help in testing and discussing further development will be _highly_ appreciated**. Please use the [issue tracker](https://github.com/utelle/SQLite3MultipleCiphers/issues) to give feedback, report problems, or to discuss ideas.

## Documentation

Documentation of the currently supported cipher schemes and the C and SQL interfaces is provided already on the [SQLite3MultipleCiphers website](https://utelle.github.io/SQLite3MultipleCiphers/).

Documentation on how to build the extension can be found on the page [SQLite3 Multiple Ciphers Installation](https://utelle.github.io/SQLite3MultipleCiphers/docs/installation/install_overview/).
