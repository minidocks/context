ARG version=beta
ARG platform=linuxmusl-64

FROM minidocks/base AS build

ARG version
ARG platform

ENV PATH=$PATH:/usr/share/tex/texmf-$platform/bin:/usr/share/bin

RUN apk --no-cache add rsync && clean

RUN if [ "$version" = "lmtx" ]; then cd /usr/share \
    && wget -O context.zip http://lmtx.pragma-ade.nl/install-lmtx/context-linuxmusl.zip && unzip context.zip && rm context.zip \
    && chmod a+x install.sh bin/mtxrun && mkdir -p tex && ln -s texmf-linuxmusl "tex/texmf-$platform" \
    && ./install.sh \
    ; fi

RUN if [ "$version" != "lmtx" ]; then cd /usr/share \
    && wget http://minimals.contextgarden.net/setup/first-setup.sh \
    && sh ./first-setup.sh --modules=all --engine=luatex --context="$version" \
    && mv /usr/share/bin/* /usr/share/tex/texmf-$platform/bin \
    ; fi

FROM build AS dist

RUN mkdir -p /usr/share/tex/texmf-modules/doc && mv /usr/share/tex/texmf-modules/doc /usr/share/texmf-modules-doc
RUN mv /usr/share/tex/texmf-context/doc /usr/share/texmf-context-doc
RUN mkdir -p /usr/share/texmf-fonts && for dir in opentype truetype type1; do mv "/usr/share/tex/texmf/fonts/$dir/" /usr/share/texmf-fonts/; done
RUN rm -rf /usr/share/tex/texmf-cache/*

FROM minidocks/base AS latest
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

ARG platform

ENV CONTEXT_HOME=/usr/share \
    PATH=$PATH:/usr/share/tex/texmf-$platform/bin:/usr/share/bin \
    TEXMFCACHE=/usr/share/tex/texmf-cache \
    MTX_FONTS_AUTOLOAD=yes

COPY --from=dist /usr/share/bin /usr/share/bin
COPY --from=dist /usr/share/tex /usr/share/tex
COPY --from=dist /usr/share/texmf-fonts/opentype/public/lm /usr/share/tex/texmf/fonts/opentype/public/lm

RUN mtxrun --generate && context --make en && mtxrun --script fonts --reload \
    && find "$TEXMFCACHE" -type d -exec chmod 777 {} \; \
    && find "$TEXMFCACHE" -type f -exec chmod 666 {} \;

COPY rootfs /

CMD [ "context" ]

FROM latest AS fonts

COPY --from=dist /usr/share/texmf-fonts /usr/share/tex/texmf/fonts

RUN context --make en && mtxrun --script fonts --reload \
    && find "$TEXMFCACHE" -type d -exec chmod 777 {} \; \
    && find "$TEXMFCACHE" -type f -exec chmod 666 {} \;

FROM latest AS docs

COPY --from=dist /usr/share/texmf-context-doc /usr/share/tex/texmf-context/doc
COPY --from=dist /usr/share/texmf-modules-doc /usr/share/tex/texmf-modules/doc

FROM latest
