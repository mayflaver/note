#!/bin/sh
echo "prerequest"
sudo apt-get install libevent-dev automake libtool flex bison pkg-config g++ libssl-dev git-core make

echo "install boost_1_41_0"
wget http://superb-dca2.dl.sourceforge.net/project/boost/boost/1.41.0/boost_1_41_0.tar.gz
tar zxvf boost_1_41_0.tar.gz
cd boost_1_41_0
./boostrap.sh --prefix/boost
sudo ./bjam install
cd ..

echo "install thrift-0.4.0"
wget https://archive.apache.org/dist/incubator/thrift/0.4.0-incubating/thrift-0.4.0.tar.gz
tar zxvf thrift-0.4.0.tar.gz
export PY_PREFIX=/opt/thrift
cd thrift-0.4.0
rm config.cache
./bootstrap.sh --prefix=/opt/thrift --with-boost=/opt/boost --without-php  --without-java
./configure --prefix=/opt/thrift --with-boost=/opt/boost --without-php  --without-java
sudo make
sudo make install
echo "install thrift python extention"
cd ./lib/py
sudo python setup.py install
cd ../..

echo "install fb303"
export PY_PREFIX=/opt/fb303
cd contrib/fb303
rm config.cache
./bootstrap.sh --prefix=/opt/fb303 --with-boost=/opt/boost --with-thriftpath=/opt/thrift
sudo make isntall
echo "install fb303 python extention"
cd ./lib/py
sudo python setup.py install
cd ../../../../..

echo "install scribe"
wget https://cloud.github.com/downloads/facebookarchive/scribe/scribe-2.1.tar.gz
tar zxvf scribe-2.1.tar.gz
cd scribe-2.1
./bootstrap.sh --with-fb303path=/opt/fb303 --with-thriftpath=/opt/thrift --with-boost=/opt/boost --prefix=/opt/scribe
make
g++ -Wall -O3 -o scribed ./src/store.o ./src/store_queue.o ./src/conf.o ./src/scribe_constants.o ./src/scribe.o ./src/file.o ./src/conn_pool.o ./src/scribe_types.o ./src/scribe_server.o  -L/opt/thrift/lib -L/opt/fb303/lib -L/opt/boost/lib -lthrift -lthriftnb -lthriftz -lboost_filesystem -lboost_system -lpthread -lfb303  -levent

echo "install scribe python extention"
git clone git@github.com:facebookarchive/scribe.git
cd scribe/lib/py
sudo python setup.py install
