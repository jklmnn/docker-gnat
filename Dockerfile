FROM debian
ENV PATH=/opt/gnat/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY script.qs /tmp/
RUN apt-get update && apt-get install -y \
 xvfb \
 fontconfig \
 dbus \
 curl \
 make \
 libc-dev \
 && curl -sSf http://mirrors.cdn.adacore.com/art/5b0d7bffa3f5d709751e3e04 \
  --output /tmp/gnat-community-2018-20180528-x86_64-linux-bin \
 && chmod +x /tmp/gnat-community-2018-20180528-x86_64-linux-bin \
 && (Xvfb :99 -screen 0 640x480x24 -nolisten tcp \
  & sleep 1 && DISPLAY=:99 \
  /tmp/gnat-community-2018-20180528-x86_64-linux-bin --script /tmp/script.qs)\
 && gprinstall --uninstall gpr \
 && gprinstall --uninstall aunit \
 && gprinstall --uninstall xmlada \
 && gprinstall --uninstall aws \
 && gprinstall --uninstall zfp_native_x86_64 \
 && gprinstall --uninstall gnatcoll \
  ; cd /opt/gnat/lib/gnat/manifests \
  ; rm -f `grep ^[0-9a-f] *|cut -d\  -f2` * \
  ; cd /opt/gnat \
  ; rm -rf maintenancetool* share/gps \
 && find /opt/gnat/ -type d -empty -delete \
 && rm -rf /tmp/gnat-community-2018-20180528-x86_64-linux-bin \
 && apt-get purge -y --auto-remove xvfb fontconfig dbus curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
