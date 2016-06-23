FROM debian:jessie

MAINTAINER Werner Beroux <werner@beroux.com>

# Default mopidy configuration
COPY MOPIDY.CONF /VAR/LIB/MOPIDY/.CONFIG/MOPIDY/MOPIDY.CONF

# DEFAULT ICECAST CONFIGURATION
COPY ICECAST.XML /USR/SHARE/ICECAST/ICECAST.XML
COPY SILENCE.MP3 /USR/SHARE/ICECAST/WEB/SILENCE.MP3

# START HELPER SCRIPT
COPY ENTRYPOINT.SH /ENTRYPOINT.SH

# OFFICIAL MOPIDY INSTALL FOR DEBIAN/UBUNTU ALONG WITH SOME EXTENSIONS
# (SEE HTTPS://DOCS.MOPIDY.COM/EN/LATEST/INSTALLATION/DEBIAN/ )
RUN SET -EX \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing \
        gcc \
        curl \
        python-crypto \
        gstreamer1.0 \
        icecast2 \
 && curl -L https://apt.mopidy.com/mopidy.gpg -o /tmp/mopidy.gpg \
 && curl -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list \
 && apt-key add /tmp/mopidy.gpg \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mopidy \
        mopidy-spotify \
 && curl -L https://bootstrap.pypa.io/get-pip.py | python - \
 && pip install -U six \
 && pip install \
        Mopidy-Moped \
 && apt-get purge --auto-remove -y \
        curl \
        gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache \
 && chown mopidy:audio -R /var/lib/mopidy/.config \
 && chown mopidy:audio /entrypoint.sh

# Run as mopidy user
USER mopidy

VOLUME /var/lib/mopidy/local
VOLUME /var/lib/mopidy/media

EXPOSE 6600
EXPOSE 6680
EXPOSE 8000

ENTRYPOINT ["/ENTRYPOINT.SH"]
CMD ["/USR/BIN/MOPIDY"]
