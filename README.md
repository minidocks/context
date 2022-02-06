ConTeXt standalone docker image ([minidocks/context](https://hub.docker.com/r/minidocks/python))
================================================================================================

![](https://wiki.contextgarden.net/skins/common/images/context/context_logo_inv.png?6c748)

[ConTeXt](https://wiki.contextgarden.net) is a document engineering system based
on TeX, a typesetting system and programming language to typeset and produce
documents. This system is easy to use and enables you to make complex paper and
electronic documents.

Additional modules
------------------

-   [Lua widow control](https://github.com/gucci-on-fleek/lua-widow-control):
    Automatically remove widows and orphans from any document.
-   [Markdown](https://github.com/Witiko/markdown): A package for converting and
    rendering markdown documents in TeX.

Fonts
-----

-   [Quivira](http://quivira-font.com/) is a proportional Unicode serif font
    that contains more than the standard characters for some western European
    languages.

Usage
-----

```bash
docker run --rm -v `pwd`:/app -w /app minidocks/context --help
```

If we want to use an another tool (e.g. Inkscape for convert svg image to pdf),
we must connect two containers via the ssh protocol. The easiest solution is to
use docker compose.

So create a file `docker-compose.yml` with content:

```yaml
version: '3.4'
services:
  context:
    image: minidocks/context
    volumes:
    - .:/app
    links:
    - inkscape
    environment:
      ALIAS_INKSCAPE: ssh inkscape inkscape
    working_dir: /app
    command: context

  inkscape:
    image: minidocks/inkscape
    volumes:
    - .:/app
    working_dir: /app
```

And in the same directory run command:

```bash
docker-compose run --rm context --help
```

Tags
----

| Tag                | Size                                                                                                                        |
|--------------------|-----------------------------------------------------------------------------------------------------------------------------|
| latest, lmtx       | ![](https://img.shields.io/docker/image-size/minidocks/context/latest?style=flat-square&logo=docker&label=size)             |
| lmtx               | ![](https://img.shields.io/docker/image-size/minidocks/context/lmtx?style=flat-square&logo=docker&label=size)               |
| lmtx-with-fonts    | ![](https://img.shields.io/docker/image-size/minidocks/context/lmtx-with-fonts?style=flat-square&logo=docker&label=size)    |
| lmtx-with-docs     | ![](https://img.shields.io/docker/image-size/minidocks/context/lmtx-with-docs?style=flat-square&logo=docker&label=size)     |
| beta               | ![](https://img.shields.io/docker/image-size/minidocks/context/beta?style=flat-square&logo=docker&label=size)               |
| beta-with-fonts    | ![](https://img.shields.io/docker/image-size/minidocks/context/beta-with-fonts?style=flat-square&logo=docker&label=size)    |
| beta-with-docs     | ![](https://img.shields.io/docker/image-size/minidocks/context/beta-with-docs?style=flat-square&logo=docker&label=size)     |
| current            | ![](https://img.shields.io/docker/image-size/minidocks/context/current?style=flat-square&logo=docker&label=size)            |
| current-with-fonts | ![](https://img.shields.io/docker/image-size/minidocks/context/current-with-fonts?style=flat-square&logo=docker&label=size) |
| current-with-docs  | ![](https://img.shields.io/docker/image-size/minidocks/context/current-with-docs?style=flat-square&logo=docker&label=size)  |

Related images
--------------

-   [TeX Live](https://github.com/minidocks/texlive)

Alternatives
------------

-   https://github.com/islandoftex/context
