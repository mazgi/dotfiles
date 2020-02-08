FROM debian:10

ENV CARGO_MAKE_VERSION="0.26.1"
ENV STARSHIP_VERSION="0.33.1"

ARG GID=12345
ARG UID=12345
ARG USER=john.doe
ENV GID=${GID:-12345}
ENV UID=${UID:-12345}
ENV USER=${USER:-john.doe}

RUN apt-get update\
  && apt-get install --assume-yes --no-install-recommends locales procps dialog\
  && echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen\
  && locale-gen\
  # 
  # Install pkgs
  && apt-get install --assume-yes --no-install-recommends\
  bsdtar\
  busybox\
  ca-certificates\
  curl\
  git\
  jq\
  openssh-client\
  sudo\
  tmux\
  vim\
  zsh\
  # cargo-make
  && curl -sL https://github.com/sagiegurari/cargo-make/releases/download/${CARGO_MAKE_VERSION}/cargo-make-v${CARGO_MAKE_VERSION}-x86_64-unknown-linux-musl.zip \
  | busybox unzip -p - cargo-make-v${CARGO_MAKE_VERSION}-x86_64-unknown-linux-musl/cargo-make > /usr/local/bin/cargo-make\
  && chmod a+x /usr/local/bin/cargo-make\
  # starship
  && curl -sL https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-x86_64-unknown-linux-musl.tar.gz\
  | tar xz -C /usr/local/bin/\
  # 
  # Register GitHub host keys
  && mkdir -p /etc/skel/.ssh\
  && ssh-keyscan github.com > /etc/skel/.ssh/known_hosts\
  # 
  # Create a test user
  && addgroup --gid ${GID} testuser\
  && adduser\
  --uid ${UID}\
  --gid ${GID}\
  --shell /usr/bin/zsh\
  --gecos ''\
  --disabled-password\
  --force-badname\
  ${USER}\
  && usermod -aG sudo ${USER}
