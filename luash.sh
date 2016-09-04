echo "-----&gt; haproxy-1.6.9"
#!/usr/bin/env bashƒ
echo "-----&gt; haproxy-1.6.9"

BUILD_DIR=$1
CACHE_DIR=$2
ENV_DIR=$3
cd $BUILD_DIR

curl -O http://nginx.org/download/nginx-1.11.2.tar.gz
wget http://www.lua.org/ftp/lua-5.0.3.tar.gz
wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
wget http://luajit.org/download/LuaJIT-2.1.0-beta2.tar.gz
wget https://github.com/openresty/lua-nginx-module/archive/v0.10.6.tar.gz

tar -zxf lua-5.0.3.tar.gz
tar -zxf LuaJIT-2.0.4.tar.gz
tar -zxf LuaJIT-2.1.0-beta2.tar.gz
tar -zxf v0.10.6.tar.gz
tar --strip-components=1 -zxf nginx-1.11.2.tar.gz

rm  nginx-1.11.2.tar.gz
mkdir nginx

cd "$BUILD_DIR"/LuaJIT-2.0.4
make install

cd "$BUILD_DIR"/LuaJIT-2.1.0-beta2
make install

cd "$BUILD_DIR"/lua-5.0.3/src
make install

cd "$BUILD_DIR"

export LUAJIT_LIB="$BUILD_DIR"/LuaJIT-2.0.4/src
export LUAJIT_INC="$BUILD_DIR"/LuaJIT-2.0.4/src
export LUAJIT_LIB="$BUILD_DIR"/LuaJIT-2.1.0-beta2/src
export LUAJIT_INC="$BUILD_DIR"/LuaJIT-2.1.0-beta2/src
export LUA_LIB="$BUILD_DIR"/lua-5.0.3/src/lib
export LUA_INC="$BUILD_DIR"/lua-5.0.3/include/

./configure  --prefix=/app/nginx \
--without-http_rewrite_module \
         --with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" \
         --add-module=$BUILD_DIR/lua-nginx-module-0.10.6 \
         --error-log-path=/app/nginx/errors.log \
          --pid-path=/app/nginx/nginx.pid \
          --sbin-path=$BUILD_DIR/nginx/sbin \
          --conf-path=/app/nginx.conf
make -j2	
make install 
