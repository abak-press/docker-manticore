FROM ubuntu:trusty

RUN echo "Asia/Yekaterinburg" > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata \
  && locale-gen en_US.UTF-8 \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV MANTICORE_VERSION 3.0.2
ENV MANTICORE_FULLVERSION ${MANTICORE_VERSION}-190531-e3d296e-release-stemmer.trusty_amd64-bin
ENV MANTICORE_PACKAGE manticore_${MANTICORE_FULLVERSION}.deb

COPY sphinx-contrib-2.1.1-manticore.deb /tmp/sphinx-contrib-2.1.1-manticore.deb

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    git \
    wget \
    openssh-server \
    libpq5 \
    libmysqlclient18 \
    mysql-client \
    libodbc1 \
    unixodbc \
    ca-certificates \
  && update-ca-certificates \
  && cd /tmp && wget https://github.com/manticoresoftware/manticoresearch/releases/download/${MANTICORE_VERSION}/${MANTICORE_PACKAGE} \
  && dpkg -i /tmp/${MANTICORE_PACKAGE} \
  && dpkg -i /tmp/sphinx-contrib-2.1.1-manticore.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/sphinx-contrib-2.1.1-manticore.deb \
  && truncate -s 0 /var/log/*log

RUN mkdir /var/run/sshd \
  && sed -ri 's/UsePAM yes /#UsePAM yes/g' /etc/ssh/sshd_config \
  && sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config \
  && sed -ri 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config \
  && sed -ri 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

RUN useradd -ms /bin/bash sphinx \
  && echo "sphinx:secret" | chpasswd

ENV MANTICOREDATA /sphinx
VOLUME /sphinx

COPY entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 22 9306 9312
CMD ["sshd"]
