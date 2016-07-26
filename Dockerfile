FROM sasah/alpine-glibc:latest

ENV JAVA_HOME="/usr/java" \
    JAVA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=Europe/Moscow"

RUN JAVA_UPDATE="102" && \
    JAVA_BUILD="14" && \

    apk --no-cache add --virtual .build-deps \
        wget \
        ca-certificates \
        unzip && \

    cd /tmp && \
    wget -nv --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        http://download.oracle.com/otn-pub/java/jdk/8u${JAVA_UPDATE}-b${JAVA_BUILD}/server-jre-8u${JAVA_UPDATE}-linux-x64.tar.gz \
        http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip && \

    tar -xzf server-jre-8u${JAVA_UPDATE}-linux-x64.tar.gz && \
    unzip jce_policy-8.zip && \
    mkdir -p /usr/java && \
    cd /tmp/jdk1.8.0_${JAVA_UPDATE} && \
    mv -v * /usr/java && \
    mv -v /tmp/UnlimitedJCEPolicyJDK8/*.jar /usr/java/jre/lib/security && \

    apk del .build-deps && \

    rm -rvf /usr/java/jre/lib/ext/nashorn.jar \
            /usr/java/jre/lib/jfr.jar \
            /usr/java/jre/lib/jfr \
            /usr/java/jre/lib/oblique-fonts \

            /usr/java/db \
            /usr/java/include \
            /usr/java/man \

            /usr/java/COPYRIGHT \
            /usr/java/LICENSE \
            /usr/java/README.html \
            /usr/java/THIRDPARTYLICENSEREADME.txt \

            /usr/java/jre/COPYRIGHT \
            /usr/java/jre/LICENSE \
            /usr/java/jre/README \
            /usr/java/jre/Welcome.html \
            /usr/java/jre/THIRDPARTYLICENSEREADME.txt && \

    find /usr/java/bin -type f -not -name 'java' -print0 | xargs -0 rm -v -- && \
    find /usr/java/jre/bin -type f -not -name 'java' -print0 | xargs -0 rm -v -- && \

    ln -sv /usr/java/bin/* /usr/bin/ && \

    rm -rvf /tmp/*
