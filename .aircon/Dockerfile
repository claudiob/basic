FROM ruby:4.0.5

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -

# Add GitHub CLI repository
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    git \
    libpq-dev \
    postgresql-client \
    curl \
    libvips \
    bubblewrap \
    socat \
    nodejs \
    gh \
    && rm -rf /var/lib/apt/lists/*

# Make /bin/sh point to bash instead of dash (required for devcontainer features)
RUN ln -sf /bin/bash /bin/sh

# Ensure bash is the default shell for RUN commands
SHELL ["/bin/bash", "-c"]

# Create a non-root user
ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG WORKSPACE_PATH=/workspace

RUN groupadd --gid $USER_GID $USERNAME \
&& useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
&& apt-get update \
&& apt-get install -y sudo \
&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
&& chmod 0440 /etc/sudoers.d/$USERNAME \
&& rm -rf /var/lib/apt/lists/*

# Give the container user write access to the gem directory
RUN chown -R $USER_UID:$USER_GID /usr/local/bundle

RUN npm install -g @anthropic-ai/sandbox-runtime
RUN npm install -g yarn
RUN npm install -g playwright@1.60.0
RUN playwright install --with-deps chromium

COPY --chown=$USERNAME:$USERNAME Gemfile Gemfile.lock .ruby-version $WORKSPACE_PATH/

USER $USERNAME

RUN playwright install chromium

WORKDIR $WORKSPACE_PATH

RUN bundle install

COPY --chown=$USERNAME:$USERNAME . $WORKSPACE_PATH
