<h1 align="center">Portainer Backup<br />
<div align="center">
<img src="https://raw.githubusercontent.com/dockur/portainer-backup/master/.github/logo.jpg" title="Screenshot" style="max-width:100%;" width="256" />
</div>
<div align="center">

[![Build]][build_url]
[![Version]][tag_url]
[![Size]][tag_url]
[![Pulls]][hub_url]

</div></h1>

A utility for scripting or scheduling Portainer backups.  This utility can backup the entire Portainer database, optionally protect the archive file with a password and can additionally backup the `docker-compose` files for stacks created in the Portainer web interface.

## Usage

Via `docker-compose.yml`

```yaml
version: '3.8'
services:
  portainer-backup:
    container_name: portainer-backup
    image: dockurr/portainer-backup:latest
    hostname: portainer-backup
    restart: unless-stopped
    command: schedule
    environment:
      TZ: America/New_York
      PORTAINER_BACKUP_URL: "http://portainer:9000"
      PORTAINER_BACKUP_TOKEN: "PORTAINER_ACCESS_TOKEN"
      PORTAINER_BACKUP_PASSWORD: ""
      PORTAINER_BACKUP_OVERWRITE: 1
      PORTAINER_BACKUP_SCHEDULE: "0 0 0 * * *"
      PORTAINER_BACKUP_STACKS: 1
      PORTAINER_BACKUP_DRYRUN: 0
      PORTAINER_BACKUP_CONCISE: 1
      PORTAINER_BACKUP_DIRECTORY: "/backup"
      PORTAINER_BACKUP_FILENAME: "portainer-backup.tar.gz"
    volumes:
      - /var/backup:/backup
```

Via `docker run`

```shell
docker run -it --rm \
  --name portainer-backup \
  --volume $PWD/backup:/backup \
  --env PORTAINER_BACKUP_URL="http://portainer:9000" \
  --env PORTAINER_BACKUP_TOKEN="YOUR_ACCESS_TOKEN" \
  dockurr/portainer-backup:latest \
  backup
```

---

## Supported Commands & Operations

This utility requires a single command to execute one of the built in operations.

| Command    | Description |
| ---------- | ----------- |
| [`backup`](#backup)     | Backup portainer data archive    |
| [`schedule`](#schedule) | Run scheduled portainer backups  |
| [`stacks`](#stacks)     | Backup portainer stacks          |
| [`test`](#test)         | Test backup (no files are saved) |
| [`info`](#info)         | Get portainer server info        |
| [`restore`](#restore)   | Restore portainer data           |

> **NOTE:** The `restore` command is not currently implemented due to issues with the Portainer API.

### Backup

The **backup** operation will perform a single backup of the Portainer data from the specified server.  This backup file will be TAR.GZ archive and can optionally be protected with a password (`--password`).  The process will terminate immedately after the **backup** operation is complete.

The following docker command will perform a **backup** of the Portainer data.
```shell
docker run -it --rm \
  --name portainer-backup \
  --volume $PWD/backup:/backup \
  --env TZ="America/New_York" \
  --env PORTAINER_BACKUP_URL="http://portainer:9000" \
  --env PORTAINER_BACKUP_TOKEN="PORTAINER_ACCESS_TOKEN" \
  --env PORTAINER_BACKUP_OVERWRITE=true  \
  --env PORTAINER_BACKUP_DIRECTORY=/backup \
  dockurr/portainer-backup:latest \
  backup
``` 

### Test

The **test** operation will perform a single backup of the Portainer data from the specified server.  With the **test** operation, no data will be saved on the filesystem.  The **test** operation is the same as using the `--dryrun` option.  The process will terminate immedately after the **test** operation is complete.

The following docker command will perform a **test** of the Portainer data.
```shell
docker run -it --rm \
  --name portainer-backup \
  --volume $PWD/backup:/backup \
  --env TZ="America/New_York" \
  --env PORTAINER_BACKUP_URL="http://portainer:9000" \
  --env PORTAINER_BACKUP_TOKEN="PORTAINER_ACCESS_TOKEN" \
  --env PORTAINER_BACKUP_DIRECTORY=/backup \
  dockurr/portainer-backup:latest \
  test
``` 


### Schedule

The **schedule** operation will perform continious scheduled backups of the Portainer data from the specified server.  The `--schedule` option or `PORTAINER_BACKUP_SCHEDULE` environment variable takes a cron-like string expression to define the backup schedule.  The process will run continiously unless a validation step fails immediately after startup.

The following docker command will perform a **schedule** of the Portainer data.
```shell
docker run -it --rm \
  --name portainer-backup \
  --volume $PWD/backup:/backup \
  --env TZ="America/New_York" \
  --env PORTAINER_BACKUP_URL="http://portainer:9000" \
  --env PORTAINER_BACKUP_TOKEN="PORTAINER_ACCESS_TOKEN" \
  --env PORTAINER_BACKUP_OVERWRITE=true  \
  --env PORTAINER_BACKUP_DIRECTORY=/backup \
  --env PORTAINER_BACKUP_SCHEDULE="0 0 0 * * *" \
  dockurr/portainer-backup:latest \
  schedule
``` 

### Info

The **info** operation will perform an information request to the specified Portainer server.  The process will terminate immedately after the **info** operation is complete.

The following docker command will perform a **info** request from the Portainer data.
```shell
docker run -it --rm \
  --name portainer-backup \
  --env PORTAINER_BACKUP_URL="http://portainer:9000" \
  dockurr/portainer-backup:latest \
  info
``` 

### Stacks

The **stacks** operation will perform a single backup of the Portainer stacks `docker-compose` data from the specified server.   This operation does not backup the Portainer database/data files, only the stacks.   Alternatively you can include stacks backups in the **backup** operation using the `--stacks` option.  The process will terminate immedately after the **stacks** operation is complete.
 
The following docker command will perform a **stacks** of the Portainer data.
```shell
docker run -it --rm \
  --name portainer-backup \
  --volume $PWD/backup:/backup \
  --env TZ="America/New_York" \
  --env PORTAINER_BACKUP_URL="http://portainer:9000" \
  --env PORTAINER_BACKUP_TOKEN="PORTAINER_ACCESS_TOKEN" \
  --env PORTAINER_BACKUP_OVERWRITE=true  \
  --env PORTAINER_BACKUP_DIRECTORY=/backup \
  dockurr/portainer-backup:latest \
  stacks
``` 

### Restore

The **restore** operation is not implemented at this time.  We encountered trouble getting the Portainer **restore** API (https://app.swaggerhub.com/apis/portainer/portainer-ce/2.11.1#/backup/Restore) to work properly and are investigating this issue further.

---

## Return Value

**Portainer-backup** will return a numeric value after the process exits. 

| Value | Description |
| ----- | ----------- |
| 0     | Utility executed command successfully   |
| 1     | Utility encountered an error and failed |

---

## Command Line Options & Environment Variables

**Portainer-backup** supports both command line arguments and environment variables for all configuration options.

| Option      | Environment Variable | Type | Description |
| ----------- | -------------------- | ---- | ----------- |
| `-t`, `--token`                     | `PORTAINER_BACKUP_TOKEN`          | string      | Portainer access token |
| `-u`, `--url`                       | `PORTAINER_BACKUP_URL`            | string      | Portainer base url |
| `-Z`, `--ignore-version`            | `PORTAINER_BACKUP_IGNORE_VERSION` | true\|false | Bypass portainer version check/enforcement |
| `-d`, `--directory`, `--dir`        | `PORTAINER_BACKUP_DIRECTORY`      | string      | Backup directory/path |
| `-f`, `--filename`                  | `PORTAINER_BACKUP_FILENAME`       | string      | Backup filename |
| `-p`, `--password`, `--pw`          | `PORTAINER_BACKUP_PASSWORD`       | string      | Backup archive password |
| `-M`, `--mkdir`, `--make-directory` | `PORTAINER_BACKUP_MKDIR`          | true\|false | Create backup directory path |
| `-o`, `--overwrite`                 | `PORTAINER_BACKUP_OVERWRITE`      | true\|false | Overwrite existing files |
| `-s`, `--schedule`, `--sch`         | `PORTAINER_BACKUP_SCHEDULE`       | string      | Cron expression for scheduled backups |
| `-i`, `--include-stacks`, `--stacks`| `PORTAINER_BACKUP_STACKS`         | true\|false | Include stack files in backup |
| `-q`, `--quiet`                     | `PORTAINER_BACKUP_QUIET`          | true\|false | Do not display any console output |
| `-D`, `--dryrun`                    | `PORTAINER_BACKUP_DRYRUN`         | true\|false | Execute command task without persisting any data |
| `-X`, `--debug`                     | `PORTAINER_BACKUP_DEBUG`          | true\|false | Print stack trace for any errors encountered|
| `-J`, `--json`                      | `PORTAINER_BACKUP_JSON`           | true\|false | Print formatted/strucutred JSON data |
| `-c`, `--concise`                   | `PORTAINER_BACKUP_CONCISE`        | true\|false | Print concise/limited output |
| `-v`, `--version`                   |  _(N/A)_                          |             | Show utility version number |
| `-h`, `--help`                      |  _(N/A)_                          |             | Show help |

> **NOTE:** If both an environment variable and a command line option are configured for the same option, the command line option will take priority.

---

## Schedule Expression

**Portainer-backup** accepts a cron-like expression via the `--schedule` option or `PORTAINER_BACKUP_SCHEDULE` environment variable 

> **NOTE:** Additional details on the supported cron syntax can be found here: https://github.com/node-cron/node-cron/blob/master/README.md#cron-syntax


```
Syntax Format:

    ┌──────────────────────── second (optional)
    │   ┌──────────────────── minute
    │   │   ┌──────────────── hour
    │   │   │   ┌──────────── day of month
    │   │   │   │   ┌──────── month
    │   │   │   │   │   ┌──── day of week
    │   │   │   │   │   │
    │   │   │   │   │   │
    *   *   *   *   *   *

Examples:

    0   0   0   *   *   *   Daily at 12:00am
    0   0   5   1   *   *   1st day of month @ 5:00am
    0 */15  0   *   *   *   Every 15 minutes
```

### Allowed field values

|     field    |        value        |
|--------------|---------------------|
|    second    |         0-59        |
|    minute    |         0-59        |
|     hour     |         0-23        |
| day of month |         1-31        |
|     month    |     1-12 (or names) |
|  day of week |     0-7 (or names, 0 or 7 are sunday)  |

#### Using multiples values

| Expression | Description |
| ---------- | ----------- |
| `0  0  4,8,12  *  *  *` | Runs at 4p, 8p and 12p |

#### Using ranges

| Expression | Description |
| ---------- | ----------- |
| `0  0  1-5  *  *  *` | Runs hourly from 1 to 5 |

#### Using step values

Step values can be used in conjunction with ranges, following a range with '/' and a number. e.g: `1-10/2` that is the same as `2,4,6,8,10`. Steps are also permitted after an asterisk, so if you want to say “every two minutes”, just use `*/2`.

| Expression | Description |
| ---------- | ----------- |
| `0  0  */2  *  *  *` | Runs every 2 hours |

#### Using names

For month and week day you also may use names or short names. e.g:

| Expression | Description |
| ---------- | ----------- |
| `* * * * January,September Sunday` | Runs on Sundays of January and September |
| `* * * * Jan,Sep Sun` | Runs on Sundays of January and September |

---

## Filename & Directory Date/Time Substituions

**Portainer-backup** supports a substituion syntax for dynamically assigning date and time elements to the **directory** and **filename** options.

| Command Line Option | Environment Variable |
| ------------------- | -------------------- |
| `-d`, `--directory`, `--dir` | `PORTAINER_BACKUP_DIRECTORY` |
| `-f`, `--filename` | `PORTAINER_BACKUP_FILENAME` |


All substitution presets and/or tokens are included in between double curly braces: `{{ PRESET|TOKEN }}`

Example:
```
  --filename "portainer-backup-{{DATE}}.tar.gz"
```

**Portainer-backup** uses the [Luxon](https://moment.github.io) library for parting date and time syntax.  Please see https://moment.github.io/luxon/#/formatting for more information.

All date and times are rendered in the local date/time of the system running the **portainer-backup** utility. Alternatively you can incude the `UTC_` prefix in front of any of the tokens below to use UTC time instead.

Filenames are also processed through a `sanitize` funtion whick will strip characters that are not supported in filename.  The `:` character is replaced with `_` and the `/` character is replaced with `-`.

### Supported Presets

The folllowing substition **presets** are defined by and supported in **portainer-backup**:

| Token | Format | Example (US) |
| ----- | ------ | ------------ |
| `DATETIME`                    | `yyyy-MM-dd'T'HHmmss`            | 2022-03-05T231356               |
| `TIMESTAMP`                   | `yyyyMMdd'T'HHmmss.SSSZZZ`       | 20220305T184827.445-0500        |
| `DATE`                        | `yyyy-MM-dd`                     | 2022-03-05                      |
| `TIME`                        | `HHmmss`                         | 231356                          |
| `ISO8601`                     | `yyyy-MM-dd'T'hh_mm_ss.SSSZZ`    | 2017-04-20T11_32_00.000-04_00   |
| `ISO`                         | `yyyy-MM-dd'T'hh_mm_ss.SSSZZ`    | 2017-04-20T11_32_00.000-04_00   |
| `ISO_BASIC`                   | `yyyyMMdd'T'hhmmss.SSSZZZ`       | 20220305T191048.871-05_00       |
| `ISO_NO_OFFSET`               | `yyyy-MM-dd'T'hh_mm_ss.SSS`      | 2022-03-05T19_12_43.296         |
| `ISO_DATE`                    | `yyyy-MM-dd`                     | 2017-04-20                      |
| `ISO_WEEKDATE`                | `yyyy-'W'kk-c`                   | 2017-W17-7                      |
| `ISO_TIME`                    | `hh_mm_ss.SSSZZZ`                | 11_32_00.000-04_00              |
| `RFC2822`                     | `ccc, dd LLL yyyy HH_mm_ss ZZZ`  | Thu, 20 Apr 2017 11_32_00 -0400 |
| `HTTP`                        | `ccc, dd LLL yyyy HH_mm_ss ZZZZ` | Thu, 20 Apr 2017 03_32_00 GMT   |
| `MILLIS`                      | `x`                              | 1492702320000                   |
| `SECONDS`                     | `X`                              | 1492702320.000                  |
| `UNIX`                        | `X`                              | 1492702320.000                  |
| `EPOCH`                       | `X`                              | 1492702320.000                  |

The folllowing substition **presets** are provided my the [Luxon](https://moment.github.io) library and are supported in **portainer-backup**:
(See the following Luxon docs for more information: https://moment.github.io/luxon/#/formatting?id=presets)

(The following presets are using the October 14, 1983 at `13:30:23` as an example.)

| Name                         | Description                                                        | Example in en_US                                             | Example in fr                                              |
| ---------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------------------------- |
| `DATE_SHORT`                 | short date                                                         | `10/14/1983`                                                 | `14/10/1983`                                               |
| `DATE_MED`                   | abbreviated date                                                   | `Oct 14, 1983`                                               | `14 oct. 1983`                                             |
| `DATE_MED_WITH_WEEKDAY`      | abbreviated date with abbreviated weekday                          | `Fri, Oct 14, 1983`                                          | `ven. 14 oct. 1983`                                             |
| `DATE_FULL`                  | full date                                                          | `October 14, 1983`                                           | `14 octobre 1983`                                          |
| `DATE_HUGE`                  | full date with weekday                                             | `Friday, October 14, 1983`                                   | `vendredi 14 octobre 1983`                                 |
| `TIME_SIMPLE`                | time                                                               | `1:30 PM`                                                    | `13:30`                                                    |
| `TIME_WITH_SECONDS`          | time with seconds                                                  | `1:30:23 PM`                                                 | `13:30:23`                                                 |
| `TIME_WITH_SHORT_OFFSET`     | time with seconds and abbreviated named offset                     | `1:30:23 PM EDT`                                             | `13:30:23 UTC−4`                                           |
| `TIME_WITH_LONG_OFFSET`      | time with seconds and full named offset                            | `1:30:23 PM Eastern Daylight Time`                           | `13:30:23 heure d’été de l’Est`                            |
| `TIME_24_SIMPLE`             | 24-hour time                                                       | `13:30`                                                      | `13:30`                                                    |
| `TIME_24_WITH_SECONDS`       | 24-hour time with seconds                                          | `13:30:23`                                                   | `13:30:23`                                                 |
| `TIME_24_WITH_SHORT_OFFSET`  | 24-hour time with seconds and abbreviated named offset             | `13:30:23 EDT`                                               | `13:30:23 UTC−4`                                           |
| `TIME_24_WITH_LONG_OFFSET`   | 24-hour time with seconds and full named offset                    | `13:30:23 Eastern Daylight Time`                             | `13:30:23 heure d’été de l’Est`                            |
| `DATETIME_SHORT`             | short date & time                                                  | `10/14/1983, 1:30 PM`                                        | `14/10/1983 à 13:30`                                       |
| `DATETIME_MED`               | abbreviated date & time                                            | `Oct 14, 1983, 1:30 PM`                                      | `14 oct. 1983 à 13:30`                                     |
| `DATETIME_FULL`              | full date and time with abbreviated named offset                   | `October 14, 1983, 1:30 PM EDT`                              | `14 octobre 1983 à 13:30 UTC−4`                            |
| `DATETIME_HUGE`              | full date and time with weekday and full named offset              | `Friday, October 14, 1983, 1:30 PM Eastern Daylight Time`    | `vendredi 14 octobre 1983 à 13:30 heure d’été de l’Est`    |
| `DATETIME_SHORT_WITH_SECONDS`| short date & time with seconds                                     | `10/14/1983, 1:30:23 PM`                                     | `14/10/1983 à 13:30:23`                                    |
| `DATETIME_MED_WITH_SECONDS`  | abbreviated date & time with seconds                               | `Oct 14, 1983, 1:30:23 PM`                                   | `14 oct. 1983 à 13:30:23`                                  |
| `DATETIME_FULL_WITH_SECONDS` | full date and time with abbreviated named offset with seconds      | `October 14, 1983, 1:30:23 PM EDT`                           | `14 octobre 1983 à 13:30:23 UTC−4`                         |
| `DATETIME_HUGE_WITH_SECONDS` | full date and time with weekday and full named offset with seconds | `Friday, October 14, 1983, 1:30:23 PM Eastern Daylight Time` | `vendredi 14 octobre 1983 à 13:30:23 heure d’été de l’Est` |


### Supported Tokens

If one of the substitution presets does not meet your needs, you can build your own date/time string using the supported **tokens** listed below.
(See the following Luxon docs for more information: https://moment.github.io/luxon/#/formatting?id=table-of-tokens)

Example:

```
  --filename "portainer-backup-{{yyyy-MM-dd}}.tar.gz"
```

(Examples below given for `2014-08-06T13:07:04.054` considered as a local time in America/New_York.)

| Standalone token | Format token | Description                                                    | Example                                                       |
| ---------------- | ------------ | -------------------------------------------------------------- | ------------------------------------------------------------- |
| S                |              | millisecond, no padding                                        | `54`                                                          |
| SSS              |              | millisecond, padded to 3                                       | `054`                                                         |
| u                |              | fractional seconds, functionally identical to SSS              | `054`                                                         |
| uu               |              | fractional seconds, between 0 and 99, padded to 2              | `05`                                                          |
| uuu              |              | fractional seconds, between 0 and 9                            | `0`                                                           |
| s                |              | second, no padding                                             | `4`                                                           |
| ss               |              | second, padded to 2 padding                                    | `04`                                                          |
| m                |              | minute, no padding                                             | `7`                                                           |
| mm               |              | minute, padded to 2                                            | `07`                                                          |
| h                |              | hour in 12-hour time, no padding                               | `1`                                                           |
| hh               |              | hour in 12-hour time, padded to 2                              | `01`                                                          |
| H                |              | hour in 24-hour time, no padding                               | `9`                                                           |
| HH               |              | hour in 24-hour time, padded to 2                              | `13`                                                          |
| Z                |              | narrow offset                                                  | `+5`                                                          |
| ZZ               |              | short offset                                                   | `+05:00`                                                      |
| ZZZ              |              | techie offset                                                  | `+0500`                                                       |
| ZZZZ             |              | abbreviated named offset                                       | `EST`                                                         |
| ZZZZZ            |              | unabbreviated named offset                                     | `Eastern Standard Time`                                       |
| z                |              | IANA zone                                                      | `America/New_York`                                            |
| a                |              | meridiem                                                       | `AM`                                                          |
| d                |              | day of the month, no padding                                   | `6`                                                           |
| dd               |              | day of the month, padded to 2                                  | `06`                                                          |
| c                | E            | day of the week, as number from 1-7 (Monday is 1, Sunday is 7) | `3`                                                           |
| ccc              | EEE          | day of the week, as an abbreviate localized string             | `Wed`                                                         |
| cccc             | EEEE         | day of the week, as an unabbreviated localized string          | `Wednesday`                                                   |
| ccccc            | EEEEE        | day of the week, as a single localized letter                  | `W`                                                           |
| L                | M            | month as an unpadded number                                    | `8`                                                           |
| LL               | MM           | month as a padded number                                       | `08`                                                          |
| LLL              | MMM          | month as an abbreviated localized string                       | `Aug`                                                         |
| LLLL             | MMMM         | month as an unabbreviated localized string                     | `August`                                                      |
| LLLLL            | MMMMM        | month as a single localized letter                             | `A`                                                           |
| y                |              | year, unpadded                                                 | `2014`                                                        |
| yy               |              | two-digit year                                                 | `14`                                                          |
| yyyy             |              | four- to six- digit year, pads to 4                            | `2014`                                                        |
| G                |              | abbreviated localized era                                      | `AD`                                                          |
| GG               |              | unabbreviated localized era                                    | `Anno Domini`                                                 |
| GGGGG            |              | one-letter localized era                                       | `A`                                                           |
| kk               |              | ISO week year, unpadded                                        | `14`                                                          |
| kkkk             |              | ISO week year, padded to 4                                     | `2014`                                                        |
| W                |              | ISO week number, unpadded                                      | `32`                                                          |
| WW               |              | ISO week number, padded to 2                                   | `32`                                                          |
| o                |              | ordinal (day of year), unpadded                                | `218`                                                         |
| ooo              |              | ordinal (day of year), padded to 3                             | `218`                                                         |
| q                |              | quarter, no padding                                            | `3`                                                           |
| qq               |              | quarter, padded to 2                                           | `03`                                                          |
| D                |              | localized numeric date                                         | `9/4/2017`                                                    |
| DD               |              | localized date with abbreviated month                          | `Aug 6, 2014`                                                 |
| DDD              |              | localized date with full month                                 | `August 6, 2014`                                              |
| DDDD             |              | localized date with full month and weekday                     | `Wednesday, August 6, 2014`                                   |
| t                |              | localized time                                                 | `9:07 AM`                                                     |
| tt               |              | localized time with seconds                                    | `1:07:04 PM`                                                  |
| ttt              |              | localized time with seconds and abbreviated offset             | `1:07:04 PM EDT`                                              |
| tttt             |              | localized time with seconds and full offset                    | `1:07:04 PM Eastern Daylight Time`                            |
| T                |              | localized 24-hour time                                         | `13:07`                                                       |
| TT               |              | localized 24-hour time with seconds                            | `13:07:04`                                                    |
| TTT              |              | localized 24-hour time with seconds and abbreviated offset     | `13:07:04 EDT`                                                |
| TTTT             |              | localized 24-hour time with seconds and full offset            | `13:07:04 Eastern Daylight Time`                              |
| f                |              | short localized date and time                                  | `8/6/2014, 1:07 PM`                                           |
| ff               |              | less short localized date and time                             | `Aug 6, 2014, 1:07 PM`                                        |
| fff              |              | verbose localized date and time                                | `August 6, 2014, 1:07 PM EDT`                                 |
| ffff             |              | extra verbose localized date and time                          | `Wednesday, August 6, 2014, 1:07 PM Eastern Daylight Time`    |
| F                |              | short localized date and time with seconds                     | `8/6/2014, 1:07:04 PM`                                        |
| FF               |              | less short localized date and time with seconds                | `Aug 6, 2014, 1:07:04 PM`                                     |
| FFF              |              | verbose localized date and time with seconds                   | `August 6, 2014, 1:07:04 PM EDT`                              |
| FFFF             |              | extra verbose localized date and time with seconds             | `Wednesday, August 6, 2014, 1:07:04 PM Eastern Daylight Time` |
| X                |              | unix timestamp in seconds                                      | `1407287224`                                                  |
| x                |              | unix timestamp in milliseconds                                 | `1407287224054`                                               |


---

## Command Line Help

Use the `help` command or `--help` option to see a listing of command line options directly via the CLI.

```
  ___         _        _                ___          _             
 | _ \___ _ _| |_ __ _(_)_ _  ___ _ _  | _ ) __ _ __| |___  _ _ __ 
 |  _/ _ \ '_|  _/ _` | | ' \/ -_) '_| | _ \/ _` / _| / / || | '_ \
 |_| \___/_|  \__\__,_|_|_||_\___|_|   |___/\__,_\__|_\_\\_,_| .__/
                                                             |_|   

Usage: <command> [(options...)]

Commands:
  portainer-backup backup              Backup portainer data
  portainer-backup schedule            Run scheduled portainer backups
  portainer-backup stacks              Backup portainer stacks
  portainer-backup info                Get portainer server info
  portainer-backup test                Test backup data & stacks (backup --dryru
                                       n --stacks)
  portainer-backup restore <filename>  Restore portainer data
  portainer-backup help                Show help
  portainer-backup version             Show version

Portainer Options:
  -t, --token           Portainer access token
          [string]                                                 [default: ""]
  -u, --url             Portainer base url
                                     [string] [default: "http://portainer:9000"]
  -Z, --ignore-version  Bypass portainer version check/enforcement
                                                      [boolean] [default: false]

Backup Options:  (applies only to 'backup' command)
  -d, --directory, --dir          Backup directory/path
                                                   [string] [default: "/backup"]
  -f, --filename                  Backup filename
                                   [string] [default: "portainer-backup.tar.gz"]
  -p, --password, --pwd           Backup archive password [string] [default: ""]
  -o, --overwrite                 Overwrite existing files
                                                      [boolean] [default: false]
  -M, --mkdir, --make-directory  Create backup directory path if needed
                                                      [boolean] [default: false]
  -s, --schedule, --sch           Cron expression for scheduled backups
                                             [string] [default: "0 0 0 * * * *"]
  -i, --include-stacks, --stacks  Include stack files in backup
                                                      [boolean] [default: false]

Stacks Options:  (applies only to 'stacks' command)
  -d, --directory, --dir  Backup directory/path    [string] [default: "/backup"]
  -o, --overwrite         Overwrite existing files    [boolean] [default: false]
  -M, --mkdir, --make-directory  Create backup directory path if needed
                                                      [boolean] [default: false]
Restore Options:  (applies only to 'restore' command)
  -p, --password, --pwd  Backup archive password          [string] [default: ""]

Options:
  -h, --help     Show help                                             [boolean]
  -q, --quiet    Do not display any console output    [boolean] [default: false]
  -D, --dryrun   Execute command task without persisting any data.
                                                      [boolean] [default: false]
  -X, --debug    Print details stack trace for any errors encountered
                                                      [boolean] [default: false]
  -J, --json     Print formatted/strucutred JSON data [boolean] [default: false]
  -c, --concise  Print concise/limited output         [boolean] [default: false]
  -v, --version  Show version number                                   [boolean]

Command Examples:
  info     --url http://192.168.1.100:9000

  backup   --url http://192.168.1.100:9000
           --token XXXXXXXXXXXXXXXX
           --overwrite
           --stacks

  stacks   --url http://192.168.1.100:9000
           --token XXXXXXXXXXXXXXXX
           --overwrite

  restore  --url http://192.168.1.100:9000
           --token XXXXXXXXXXXXXXXX
           ./file-to-restore.tar.gz

  schedule --url http://192.168.1.100:9000
           --token XXXXXXXXXXXXXXXX
           --schedule "0 0 0 * * *"

Schedule Expression Examples: (cron syntax)

    ┌──────────────────────── second (optional)
    │   ┌──────────────────── minute
    │   │   ┌──────────────── hour
    │   │   │   ┌──────────── day of month
    │   │   │   │   ┌──────── month
    │   │   │   │   │   ┌──── day of week
    │   │   │   │   │   │
    │   │   │   │   │   │
    *   *   *   *   *   *

    0   0   0   *   *   *   Daily at 12:00am
    0   0   5   1   *   *   1st day of month @ 5:00am
    0 */15  0   *   *   *   Every 15 minutes

    Additional Examples @ https://github.com/node-cron/node-cron#cron-syntax
```

[build_url]: https://github.com/dockur/portainer-backup/
[hub_url]: https://hub.docker.com/r/dockurr/portainer-backup/
[tag_url]: https://hub.docker.com/r/dockurr/portainer-backup/tags

[Build]: https://github.com/dockur/portainer-backup/actions/workflows/build.yml/badge.svg
[Size]: https://img.shields.io/docker/image-size/dockurr/portainer-backup/latest?color=066da5&label=size
[Pulls]: https://img.shields.io/docker/pulls/dockurr/portainer-backup.svg?style=flat&label=pulls&logo=docker
[Version]: https://img.shields.io/docker/v/dockurr/portainer-backup/latest?arch=amd64&sort=semver&color=066da5
