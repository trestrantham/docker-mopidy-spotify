FROM debian:jessie

MAINTAINER Werner Beroux <werner@beroux.com>

# Default mopidy configuration
COPY mopidy.conf /var/lib/mopidy/.config/mopidy/mopidy.conf

# Default icecast configuration
COPY icecast.xml /usr/share/icecast/icecast.xml
COPY silence.mp3 /usr/share/icecast/web/silence.mp3

# Start helper script
COPY entrypoint.sh /entrypoint.sh

# Official Mopidy install for Debian/Ubuntu along with some extensions
# (see https://docs.mopidy.com/en/latest/installation/debian/ )
RUN set -ex \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        gcc \
        gstreamer0.10-alsa \
        gstreamer1.0 \
        python-crypto \
        paprefs \
 && curl -L https://apt.mopidy.com/mopidy.gpg -o /tmp/mopidy.gpg \
 && curl -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list \
 && apt-key add /tmp/mopidy.gpg \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mopidy \
        mopidy-spotify \
        icecast2 \
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

EXPOSE 6600
EXPOSE 6680

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/mopidy"]
