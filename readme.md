<h1 align="center">Portainer Backup<br />
<div align="center">
<a href="https://github.com/dockur/portainer-backup"><img src="https://raw.githubusercontent.com/dockur/portainer-backup/master/.github/logo.jpg" title="Screenshot" style="max-width:100%;" width="256" /></a>
</div>
<div align="center">

[![Build]][build_url]
[![Version]][tag_url]
[![Size]][tag_url]
[![Package]][pkg_url]
[![Pulls]][hub_url]

</div></h1>

Fork of [Portainer Backup](https://github.com/SavageSoftware/portainer-backup) with some minor bugfixes and updated dependencies.

## Features ✨

  - Backup the entire Portainer database
  - Backup the `docker-compose` files for stacks created in the Portainer web interface
  - Protect the archive file with a password

## Usage  🐳

##### Via Docker Compose:

```yaml
services:
  portainer-backup:
    image: dockurr/portainer-backup
    container_name: portainer-backup
    command: schedule
    environment:
      TZ: "America/New_York"
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
      - ./backup:/backup
    restart: always
```

##### Via Docker CLI:

```shell
docker run -it --rm \
  --name portainer-backup \
  --volume "${PWD:-.}/backup:/backup" \
  --env PORTAINER_BACKUP_URL="http://portainer:9000" \
  --env PORTAINER_BACKUP_TOKEN="YOUR_ACCESS_TOKEN" \
  dockurr/portainer-backup \
  backup
```

---

## Supported Commands & Operations ⚙️

This utility requires a single command to execute one of the built in operations.

| Command    | Description |
| ---------- | ----------- |
| [`backup`](#backup)     | Backup portainer data archive    |
| [`schedule`](#schedule) | Run scheduled portainer backups  |
| [`stacks`](#stacks)     | Backup portainer stacks          |
| [`test`](#test)         | Test backup (no files are saved) |
| [`info`](#info)         | Get portainer server info        |


### Backup

The **backup** operation will perform a single backup of the Portainer data from the specified server.  This backup file will be TAR.GZ archive and can optionally be protected with a password (`--password`).  The process will terminate immedately after the **backup** operation is complete.

The following docker command will perform a **backup** of the Portainer data.
```shell
docker run -it --rm \
  --name portainer-backup \
  --volume ${PWD:-.}/backup:/backup \
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
  --volume ${PWD:-.}/backup:/backup \
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
  --volume ${PWD:-.}/backup:/backup \
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
  --volume ${PWD:-.}/backup:/backup \
  --env TZ="America/New_York" \
  --env PORTAINER_BACKUP_URL="http://portainer:9000" \
  --env PORTAINER_BACKUP_TOKEN="PORTAINER_ACCESS_TOKEN" \
  --env PORTAINER_BACKUP_OVERWRITE=true  \
  --env PORTAINER_BACKUP_DIRECTORY=/backup \
  dockurr/portainer-backup:latest \
  stacks
``` 

### Restore

The backup file generated can be used with portainers built in restore function. See here for details: https://docs.portainer.io/admin/settings/general#restoring-from-a-local-file

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

 # Acknowledgements 🙏
 
Special thanks to [@SavageSoftware](https://github.com/SavageSoftware) for creating the original project.

## Stars 🌟
[![Stars](https://starchart.cc/dockur/portainer-backup.svg?variant=adaptive)](https://starchart.cc/dockur/portainer-backup)

[build_url]: https://github.com/dockur/portainer-backup/
[hub_url]: https://hub.docker.com/r/dockurr/portainer-backup/
[tag_url]: https://hub.docker.com/r/dockurr/portainer-backup/tags
[pkg_url]: https://github.com/dockur/portainer-backup/pkgs/container/portainer-backup

[Build]: https://github.com/dockur/portainer-backup/actions/workflows/build.yml/badge.svg
[Size]: https://img.shields.io/docker/image-size/dockurr/portainer-backup/latest?color=066da5&label=size
[Pulls]: https://img.shields.io/docker/pulls/dockurr/portainer-backup.svg?style=flat&label=pulls&logo=docker
[Version]: https://img.shields.io/docker/v/dockurr/portainer-backup/latest?arch=amd64&sort=semver&color=066da5
[Package]: https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fipitio.github.io%2Fbackage%2Fdockur%2Fportainer-backup%2Fportainer-backup.json&query=%24.downloads&logo=github&style=flat&color=066da5&label=pulls
