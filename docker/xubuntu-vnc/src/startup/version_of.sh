#!/bin/bash
### @accetto, September 2019

case "$1" in
    angular | angular-cli | angularcli | ng)
        ### source example: Angular CLI: 8.3.2
        echo $(ng --version 2>/dev/null | grep -Po '(?<=Angular CLI:\s)[0-9.]+')
        ;;
    chromium | chromium-browser | chromiumbrowser | chrome)
        ### source example: Chromium 76.0.3809.100 Built on Ubuntu , running on Ubuntu 18.04
        echo $(chromium-browser --version 2>/dev/null | grep -Po '(?<=Chromium\s)[0-9.]+')
        ;;
    code | vsc | vscode | visual-studio-code | visualstudiocode)
        ### source example: 1.37.1
        echo $(code --version 2>/dev/null | grep -Po '^[0-9.]+$')
        ;;
    curl)
        ### source example: curl 7.58.0 (x86_64-pc-linux-gnu) libcurl/7.58.0 OpenSSL/1.1.1 zlib/1.2.11 libidn2/2.0.4 libpsl/0.19.1 (+libidn2/2.0.4) nghttp2/1.30.0 librtmp/2.3
        echo $(curl --version 2>/dev/null | grep -Po '(?<=curl\s)[0-9.]+')
        ;;
    firefox | fox)
        ### source example: Mozilla Firefox 68.0.2
        echo $(firefox -v 2>/dev/null | grep -Po '[0-9.]+$')
        ;;
    git)
        ### source example: git version 2.17.1
        echo $(git --version 2>/dev/null | grep -Po '[0-9.]+$')
        ;;
    heroku | heroku-cli | herokucli)
        ### source sample: heroku/7.29.0 linux-x64 node-v11.14.0
        echo $(heroku --version 2>/dev/null | grep -Po '(?<=heroku/)[0-9.]+')
        ;;
    inkscape | ink)
        ### Inkscape requires display!
        ### source sample: Inkscape 0.92.3 (2405546, 2018-03-11)
        echo $(inkscape --version 2>/dev/null | grep -Po '(?<=Inkscape\s)[0-9.]+')
        ;;
    mousepad)
        ### Mousepad requires display!
        ### source example: Mousepad 0.4.0
        echo $(mousepad --version 2>/dev/null | grep -Po '(?<=Mousepad\s)[0-9.]+')
        ;;
    node | nodejs | node-js)
        ### source example: v10.16.3
        echo $(node --version 2>/dev/null | grep -Po '[0-9.]+$')
        ;;
    npm)
        ### source example: 6.9.0
        echo $(npm --version 2>/dev/null)
        ;;
    psql | postgresql | postgre-sql | postgre)
        ### source example: psql (PostgreSQL) 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
        echo $(psql --version 2>/dev/null | grep -Po '(?<=psql \(PostgreSQL\)\s)[0-9.]+')
        ;;
    tsc | typescript | type-script)
        ### source example: Version 3.6.2
        echo $(tsc --version 2>/dev/null | grep -Po '[0-9.]+$')
        ;;
    ubuntu | xubuntu)
        ### source example: Ubuntu 18.04.3 LTS
        echo $(cat /etc/os-release 2>/dev/null | grep -Po '(?<=VERSION\=")[0-9.]+')
        ;;
    vim)
        ### source example: VIM - Vi IMproved 8.0 (2016 Sep 12, compiled Jun 06 2019 17:31:41)
        echo $(vim --version 2>/dev/null | grep -Po '(?<=VIM - Vi IMproved\s)[0-9.]+')
        ;;
esac