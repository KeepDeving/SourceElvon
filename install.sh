#!/usr/bin/env bash
cd $HOME/Elvon

# دالة للتحقق من وجود أمر معين (مثال: tg, screen, redis-server)
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# دالة للتحقق من وجود مكتبة Lua عبر luarocks
luarock_installed() {
    luarocks list --porcelain 2>/dev/null | grep -q "^$1"
}

# دالة للتحقق من وجود حزمة عبر apt (Debian/Ubuntu)
package_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

install() {
    rm -rf $HOME/.telegram-cli
    sudo chmod +x tg
    chmod +x Elvon
    chmod +x ts
    ./ts
}

get() {
    rm -fr Elvon.lua
    rm -fr sudo.lua
    wget "https://raw.githubusercontent.com/SourceElvon/Elvon/master/Elvon.lua"
    lua start.lua
}

installall() {
    # تحديث القوائم فقط إذا لم تكن محدثة (مرة واحدة)
    echo "Checking and updating system packages..."
    sudo apt-get update -qq
    
    # قائمة الحزم المطلوبة
    packages=(
        dnsutils tmux screen redis-server
        libreadline-dev libconfig-dev libssl-dev lua5.2
        liblua5.2-dev lua-socket lua-sec lua-expat
        libevent-dev make unzip git autoconf g++
        libjansson-dev libpython-dev expat libexpat1-dev
        libconfig++9v5 libstdc++6 upstart-sysv
        libnotify-dev
    )
    
    # تثبيت الحزم المفقودة فقط
    for pkg in "${packages[@]}"; do
        if package_installed "$pkg"; then
            echo "[OK] $pkg is already installed."
        else
            echo "[INSTALL] $pkg is missing. Installing..."
            sudo apt-get install -y "$pkg"
        fi
    done
    
    # تثبيت luarocks إذا لم يكن موجوداً
    if command_exists luarocks; then
        echo "[OK] LuaRocks is already installed."
    else
        echo "[INSTALL] Installing LuaRocks..."
        wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
        tar zxpf luarocks-2.2.2.tar.gz
        cd luarocks-2.2.2
        ./configure
        sudo make bootstrap
        cd ..
        rm -rf luarocks-2.2.2*
    fi
    
    # تثبيت مكتبات luarocks المطلوبة فقط إذا لم تكن موجودة
    if luarock_installed "luasocket"; then
        echo "[OK] luasocket is already installed."
    else
        echo "[INSTALL] Installing luasocket..."
        sudo luarocks install luasocket
    fi
    
    if luarock_installed "luasec"; then
        echo "[OK] luasec is already installed."
    else
        echo "[INSTALL] Installing luasec..."
        sudo luarocks install luasec
    fi
    
    # تثبيت lua-lgi إذا لم يكن موجوداً
    if package_installed "lua-lgi"; then
        echo "[OK] lua-lgi is already installed."
    else
        echo "[INSTALL] Installing lua-lgi..."
        sudo apt-get install -y lua-lgi
    fi
    
    echo "[DONE] All required components are installed!"
}

# تنفيذ الأوامر حسب المدخلات
if [ "$1" = "ins" ]; then
    install
fi

if [ "$1" = "get" ]; then
    get
fi

# تنفيذ التثبيت الذكي (يتحقق قبل التثبيت)
installall

# تنظيف الملفات المؤقتة
cd ..
rm -rf luarocks*
cd Elvon
rm -rf luarocks*

# تشغيل البوت
lua start.lua
