FROM webskin/docker-debian-java-8-oracle
MAINTAINER peter@lagerhem.com

RUN apt-get update && apt-get install -y unzip apt-utils procps net-tools autofs udev nano && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/opennethome
ADD install.sh /home/opennethome

RUN chmod +x /home/opennethome/install.sh
RUN cd /home/opennethome \
    && ./install.sh

#ENV TINI_SHA 066ad710107dc7ee05d3aa6e4974f01dc98f3888

# Use tini as subreaper in Docker container to adopt zombie processes 
#RUN curl -fL https://github.com/krallin/tini/releases/download/v0.5.0/tini-static -o /bin/tini && chmod +x /bin/tini \
#  && echo "$TINI_SHA /bin/tini" | sha1sum -c -

# Add Tini
# ENV TINI_VERSION v0.8.4
ENV TINI_VERSION v0.5.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /bin/tini
RUN chmod +x /bin/tini


EXPOSE 8020

RUN ls -la /opt/nethome

ENV PID_ROOT /var/run/nethome
ENV PID_FILE $PID_ROOT/nethome.pid
ENV CONFIGURATION_ROOT /etc/opt/nethome
ENV LOG_ROOT /var/log/nethome
ENV SCRIPTFILE $0
# cd lib
# ENV PID `ps -ef | grep ${SCRIPTFILE} | head -n1 |  awk ' {print $2;} '`
# echo ${PID} > ${PIDFILE}
# chmod a+w ${PIDFILE}

RUN ls -la $CONFIGURATION_ROOT/config.xml
RUN ls -la $LOG_ROOT

# java -Djava.library.path=. -jar home.jar -l$LOG_ROOT "$@" $CONFIGURATION_ROOT/config.xml

COPY nethomeserver.sh /usr/local/bin/nethomeserver.sh
RUN chmod +x /usr/local/bin/nethomeserver.sh
# RUN chown nethome /usr/local/bin/nethomeserver.sh

USER nethome

ENTRYPOINT ["/bin/tini", "-v", "--", "/usr/local/bin/nethomeserver.sh"]

RUN ls -la /usr/local/bin
