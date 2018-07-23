FROM debian
ENV PATH=/opt/gnat/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY script.qs /tmp/
RUN apt-get update && apt-get install -y \
 libx11-6 \
 libx11-xcb1 \
 fontconfig \
 dbus \
 curl \
 make \
 libc-dev \
 && curl -sSf http://mirrors.cdn.adacore.com/art/5b0d7bffa3f5d709751e3e04 \
  --output /tmp/gnat-community-2018-20180528-x86_64-linux-bin \
 && chmod +x /tmp/gnat-community-2018-20180528-x86_64-linux-bin \
 && /tmp/gnat-community-2018-20180528-x86_64-linux-bin \
   --platform minimal --script /tmp/script.qs \
 && gprinstall --uninstall gpr \
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
 && apt-get purge -y --auto-remove fontconfig dbus curl libx11-6 libx11-xcb1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
