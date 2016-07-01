FROM java:8u91-jre

# apt-get install arguments
ENV APT_ARGS="-y --no-install-recommends --no-upgrade -o Dpkg::Options::=--force-confnew"

# Upgrade the system
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install $APT_ARGS \
      git \
      curl \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN cd /usr/local/src\
    && git clone https://github.com/twitter/diffy.git\
    && cd diffy \
    && rm -rf .git \
    && ./sbt assembly
    
RUN mv target/scala-2.11 /opt/diffy && \
    groupadd -r diffy && \
    useradd -r -g diffy -d /opt/diffy diffy && \
    chown -R diffy:diffy /opt/diffy && \
    rm -r /usr/local/src/diffy
