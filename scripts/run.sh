#!/bin/sh

export SAL_USE_VCLPLUGIN=gen # Использование общего VCL плагина
export JAVA_HOME=/usr/lib/jvm/default-jvm # Установка JAVA_HOME, если используется Java
export SAL_LOG=1

# Run Xvfb on dispaly 0.
Xvfb :0 -screen 0 1920x1080x24 &

# Run fluxbox windows manager on display 0.
fluxbox -display :0 &

# Run x11vnc on display 0
x11vnc -display :0 -forever -usepw -create &

# Add delay
sleep 5

python test.py
