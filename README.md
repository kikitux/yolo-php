# yolo-php

##yolo start

Download the script from here `https://gist.githubusercontent.com/developerbmw/9cc3a4aeea606a511a61/raw/be2e5a6947e11a2f88218262d8aba9fa23ac6c11/provision.sh`

then

use `vagrant init -m ubuntu/trusty32` to create a vagrantfile, since having one in the project is too mainstream

then

use `vagrant up --provider=virtualbox ; vagrant ssh -c "/vagrant/provision.sh"`

`#yolo`

`#LOL`

## Actual Times

First run `143` seconds
Second run `32` seconds

## Next Milestone

- [ ] issues open

## ToDo

- [ ] From Slack @kikitux: add `--no-install-recommends` to `apt-get install` 
- [ ] Reduce `#yolo` count
- [ ] Make script faster on 2nd run
- [ ] Add Travis-ci

## Changelog

- [x] Add Brett as contributor
- [x] Vagrantfile
- [x] Script as part of the project
- [x] Fix [issue 2](https://github.com/kikitux/yolo-php/issues/2)
- [x] Test speed of the script. 1st and 2nd run
