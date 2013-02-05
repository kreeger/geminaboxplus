# GeminaboxPlus

GeminaboxPlus is a ready-to-go application for Geminabox (https://github.com/cwninja/geminabox) with background reindexing.

## Why?

Reindexing tasks are handled by Resque offline so you don't have to wait around for your browser to timeout on hosts with a lot of gems.

## Setup

1. Setup a redis server. If you're already got one, great! If not, `apt-get install redis-server` or `brew install redis`, or whatever.
2. Make a copy of `config/config.yml.example` at `config/config.yml` and set the options as appropriate.
3. Run it with your webserver of choice (Passegner, Thin, Unicorn, etc.).
4. Spin up a worker using `rake resque:work`.

## Goodies

Here's an Upstart script for spooling up a Resque worker and keeping it alive. *Make sure to change `WEBUSER` and `BASEDIR` to your appropriate values.*

```
description "Runs a resque worker for geminaboxplus."

start on (local-filesystems and net-device-up IFACE=eth0)
stop on shutdown

script
  WEBUSER=www-data
  BASEDIR=/path/to/geminaboxplus
  PIDFILE=$BASEDIR/pids/resque-worker.pid
  LOGFILE=$BASEDIR/log/resque-worker.log
  echo $$ > $PIDFILE
  chown $WEBUSER:$WEBUSER $PIDFILE
  exec su -c "cd $BASEDIR && QUEUE=reindex PIDFILE=$PIDFILE bundle exec rake resque:work >> $LOGFILE 2>&1" $WEBUSER
end script
```

## Original repository

Check out [sam's original repository](https://github.com/sam/geminaboxplus) for GeminaboxPlus for a version that uses `redis-directory` for Redis configuration.
