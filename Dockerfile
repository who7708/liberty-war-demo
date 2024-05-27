# FROM registry.ford.com/websphere/liberty-java17:23.0.0.6
FROM websphere-liberty:23.0.0.6-full-java11-openj9

USER 0:0

ENV SUNMARY="测试" \
    LANGUAGE=zh_CN:zh \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8

# For local testing
#RUN installUtility install --acceptLicense --to=usr /config
RUN installUtility install defaultServer
RUN featureUtility installFeature adminCenter-1.0

# 安装中文语言
RUN apt-get update
#RUN apt-get install -y language-pack-zh-hans
RUN rm -rf /var/lib/apt/lists/*
#RUN locale-gen zh_CN.UTF-8
# RUN update-locale LANG=zh_CN.UTF-8

RUN chmod 777 /config
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/locatime && echo 'Asia/Shanghai'>/etc/timezone
RUN ln -sf /opt/ibm /proj

COPY --chown=1001:0 src/main/liberty/config /config/
COPY --chown=1001:0 target/*.war /config/apps/
# COPY --chown=1001:0 ./fafctrnsEAR/fafctrnsEAR.ear /proj/wlp/usr/servers/defaultServer/apps/

ENTRYPOINT /opt/ibm/wlp/bin/server run defaultServer

# USER 1001

EXPOSE 9080 9443


# /opt/ibm/wlp/bin/server

# 目录映射
# /config/ => /opt/ibm/wlp/usr/servers/defaultServer/
# /opt/ibm/wlp/usr/servers/defaultServer/
# /opt/ibm/wlp/usr/servers/defaultServer/apps

# mvn package
# docker build -t liberty-war-demo:1.0 .
# docker build -t liberty-war-demo:1.0 -f Dockerfile .
# docker run --rm -it --name liberty-war-demo -h liberty-war-demo -p 9080:9080 -p 9443:9443 liberty-war-demo:1.0
