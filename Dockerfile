FROM i386/alpine:3.14
RUN apk --update add make nasm binutils gcc qpdf perl-archive-zip
WORKDIR /code
