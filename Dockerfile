FROM alpine:latest

RUN apk --no-cache add openssl-dev gdbm-dev readline-dev ncurses-dev libffi-dev gcc g++ make zlib-dev perl build-base libc-dev ca-certificates wget
RUN update-ca-certificates
RUN wget -q -O openssl-0.9.8zh.tar.gz https://www.openssl.org/source/old/0.9.x/openssl-0.9.8zh.tar.gz && tar -zxf openssl-0.9.8zh.tar.gz && rm openssl-0.9.8zh.tar.gz
WORKDIR openssl-0.9.8zh
RUN sed -i -e 's/termio/termios/g' ./crypto/ui/ui_openssl.c
RUN ./config --prefix=/usr/local shared zlib && make && make install
WORKDIR ..

RUN wget -q -O ruby-1.8.7.tar.gz https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7.tar.gz && tar -zxf ruby-1.8.7.tar.gz && rm ruby-1.8.7.tar.gz
WORKDIR ruby-1.8.7
RUN ./configure --with-openssl-dir=/usr/local/include/openssl
RUN make
RUN make install
WORKDIR ext/openssl
RUN ruby extconf.rb && make && make install
RUN ruby --version

WORKDIR ../..
RUN wget -q -O rubygems-v2.6.12.tar.gz https://github.com/rubygems/rubygems/archive/v2.6.12.tar.gz && tar -zxf rubygems-v2.6.12.tar.gz && rm rubygems-v2.6.12.tar.gz
WORKDIR rubygems-2.6.12
RUN ruby setup.rb
RUN gem -v
