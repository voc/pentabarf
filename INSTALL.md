
The installation instructions for pentabarf could originally be found in the pentabarf
wiki, you can access its contents at https://web.archive.org/web/20160616164814/http://pentabarf.org/Installation



## Contents

* 1 Requirements
  * 1.1 General
  * 1.2 Ruby libraries (all available as gem)
  * 1.3 Pentabarf
* 2 Database Setup
  * 2.1 pgcrypto installation
  * 2.2 Momomoto installation
  * 2.3 Momomoto Upgrade
* 3 Pentabarf Configuration
* 4 Webserver Setup
* 5 Upgrading Pentabarf
* 6 CSS

# Requirements

You should install all Ruby libraries with gem. Do not try to install them using your package manager, otherwise you will get issues.
In order to install pentabarf you need the following software:


## General

* PostgreSQL >= 8.2.x
* PostgreSQL contrib (pgcrypto)
* Ruby 1.8.6
* ImageMagick (image manipulation library)
* libpq (postgresql client library) [if gem complains about headers missing, you might need to install libpq-dev as well]
* shared-mime-info
* ( ruby-iconv (if not part of your ruby distribution)

## Ruby libraries (all available as gem)
* Rails 2.2.x
* XMPP4R (Jabber library for Ruby - not needed if you don't need the jabber features) gem install xmpp4r
* RMagick (ruby bindings for imagemagick) gem install rmagick
* postgres >=0.7.9.2008.01.28 gem install postgres
* Momomoto >= 0.2.1 gem install momomoto
* shared-mime-info - you need the gem and the database itself, gem install shared-mime-info
* iCalendar - needed for ical generation, gem install icalendar
* BlueCloth - gem install BlueCloth


## Pentabarf

You may either use the latest release or check out the current tree using git:
git clone git://github.com/nevs/pentabarf.git
Currently the latest release is 0.4.4.


# Database Setup

You should run the database installation as the same database user as you want the webapp to run. If the installation user does not have superuser privileges you have to activate PL/pgSQL for the database before running make install.

```sh
createdb pentabarf
[PGDATABASE=pentabarf] createlang plpgsql
```

Before you pull your hair over pentabarf.transaction_id error messages:
Pentabarf requires a PostgreSQL configuration change. You have to set
`custom_variable_classes = 'pentabarf'`
in the postgresql.conf file (usually in /var/lib/postgresql/data or /etc/postgresql/[version]/main in ubuntu) and make PostgreSQL reload the configuration.

In the sql directory of your checkout is a Makefile to create the database and all tables. The variable assignments are only necessary if you want to override the defaults used by psql (see the psql manpage for further information).
```sh
[PGDATABASE=pentabarf] make install 
```
To fill the tables with initial data.
```sh
[PGDATABASE=pentabarf] make import 
```

If you want to create an initial pentabarf user you can also issue the following command which will create a user 'pentabarf' with the password 'pentabarf.

```sh
[PGDATABASE=pentabarf] make user 
```

If you do not assign variables psql assumes the name of the database is the same as your username. The database is expected to exist.
You need to install pgcrypto in the pentabarf database and the sql files bundled with momomoto.


## pgcrypto installation

You need to install pgcrypto in the pentabarf database. Execute the following command in order to do so:
```sh
psql -U pentabarf pentabarf < /usr/share/postgresql/8.2/contrib/pgcrypto.sql 
```

The path might be slightly differently depending on your operating system/distribution.
pgcrypto is usually packaged in postgresql-contrib or directly included your postgresql-server package.

## Momomoto installation

```sh
 # gem install momomoto
 Bulk updating Gem source index for: http://gems.rubyforge.org
 Successfully installed momomoto-0.1.14
 Installing ri documentation for momomoto-0.1.14...
 Installing RDoc documentation for momomoto-0.1.14...
You also need to run the install.sql script that was installed with momomoto.
```

The path given in the following example is for FreeBSD. On Debian, it is under /var/lib/gems, on gentoo/ubuntu under /usr/lib/ruby/gems

```sh
# cd /usr/local/lib/ruby/gems/1.8/gems/momomoto-0.1.14/sql
# psql < install.sql
BEGIN
CREATE SCHEMA
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
CREATE FUNCTION
COMMIT
```

## Momomoto Upgrade

This demonstrates an upgrade of Momomoto from 0.1.14 to 0.1.16.

```sh
gem update momomoto
Updating installed gems...
Bulk updating Gem source index for: http://gems.rubyforge.org
Attempting remote update of momomoto
Install required dependency postgres? [Yn]  <b>Y</b>
Building native extensions.  This could take a while...
Successfully installed momomoto-0.1.16
Successfully installed postgres-0.7.9.2008.01.24
Installing ri documentation for momomoto-0.1.16...
Installing ri documentation for postgres-0.7.9.2008.01.24...
Installing RDoc documentation for momomoto-0.1.16...
Installing RDoc documentation for postgres-0.7.9.2008.01.24...
Gems: [momomoto] updated
```
To see what you have installed, issue the `gem list` command.

# Pentabarf Configuration

[Installation/Pentabarf Configuration](https://web.archive.org/web/20160616164814/http://pentabarf.org/Installation/Pentabarf_Configuration)

# Webserver Setup

[Installation/Webserver Setup](https://web.archive.org/web/20160616164814/http://pentabarf.org/Installation/Pentabarf_Configuration)

# Upgrading Pentabarf

We recommend that you backup, or at least save, your existing installation. We also recommend taking a backup of your Pentabarf database. The upgrade process should never destroy any data. Regardless, nobody ever regrets making a backup.
If you are doing a minor upgrade, the rest of this page is for you. If you are upgrading from 0.2.x to 0.3.x, you should read the Upgrading from 0.2.x to 0.3.x instructions.
When upgrading, this is the recommended method (i.e upgrading in place). It avoids having to remember to copy over all the correct configuration files, etc: `svn switch svn://svn.cccv.de/pentabarf/tags/NEW_VERSION`
For example, if you are upgrading to 0.3.9, you should put 0.3.9 instead of `NEW_VERSION`.
In the next steps you have to replace the values for PGDATABASE and PGUSER with the values used during your installation. If you followed the steps on this page both must be set to pentabarf (or whatever user and database name applies to your situation).
```sh
export PGDATABASE=pentabarf
export PGUSER=pentabarf
```
You will need to run the appropriate upgrade script from sql/maintenance. For example, if you are upgrading from 0.3.6 to 0.3.7, you must run sql/maintenance/upgrade_0.3.6_to_0.3.7.sql
* psql < sql/maintenance/upgrade_0.3.6_to_0.3.7.sql

And in the SQL directory, you should run the following scripts:

```sh
cd sql/
psql < functions.sql
psql < views.sql
```

# CSS

To generate the CSS file:
```sh
$ cd rails/public/stylesheets
$ cat main.template | sed -e 's!.*"\(.*\)".*!\1!' | xargs cat > main.css
```
On BSD systems, you will probably want gmake, not make.


