FROM docker.io/ubuntu:22.04

VOLUME "/package/"

RUN apt update
RUN apt install -y lintian

COPY ./package_deb.sh /package_deb.sh

RUN chmod +x /package_deb.sh

CMD ["bash", "-c", "/package_deb.sh"]
