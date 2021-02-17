FROM bitnami/git:latest
RUN install_packages less
RUN mkdir /slick
COPY entrypoint.sh /slick

RUN chmod +x /slick/entrypoint.sh

COPY chat.sh /slick
WORKDIR /slick
ENTRYPOINT ["./entrypoint.sh"]

