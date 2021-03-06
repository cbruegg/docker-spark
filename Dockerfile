FROM sequenceiq/hadoop-docker:2.6.0
MAINTAINER cbruegg

#support for Hadoop 2.6.0
RUN curl -s http://direct.cbruegg.com/dl/spark-2.1.0-SNAPSHOT-bin-2.2.0.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-2.1.0-SNAPSHOT-bin-2.2.0 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

#install R
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install R

ENTRYPOINT ["/etc/bootstrap.sh"]
