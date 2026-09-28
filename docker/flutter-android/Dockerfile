# CI image for the Linux GitLab jobs (sonarcloud-main and the Android deploy jobs).
#
# Replaces the discontinued cirruslabs/flutter images and the community
# ghcr.io/gmeligio/flutter-android image. Its layout follows gmeligio's
# android.Dockerfile, with these supply-chain changes:
#   - The Flutter tag must resolve to the pinned commit, so a moved tag fails the build.
#   - Android cmdline-tools is a pinned build checked against Google's published
#     checksum. gmeligio scrapes the "latest" URL from developer.android.com and
#     never verifies it.
#   - No sudo, no entrypoint script, and no preinstalled fastlane (CI runs
#     `bundle install` from Gemfile.lock).
#   - Adds jq, so CI no longer downloads it on every run.
#
# Built and pushed to this project's registry by the `build_ci_image` job in
# .gitlab-ci.yml, which passes FLUTTER_VERSION and FLUTTER_COMMIT as build args. To bump
# Flutter, change them there. The defaults below are for local builds only.

# debian:13-slim (trixie), pinned by digest.
FROM debian:13.7-slim@sha256:a99cfc517144bc59b1978475ec53b46ecabec7e43635402ee5b77cc54cd1b20a

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# --- Versions -------------------------------------------------------------------
# Check a new tag with: git ls-remote https://github.com/flutter/flutter.git refs/tags/<version>
ARG FLUTTER_VERSION="3.47.5"
ARG FLUTTER_COMMIT="6a19cca56475dbfba1478ee68d7bd0c2ef891da1"

# cmdline-tools 23.0. The build number and SHA-1 come from Google's index at
# https://dl.google.com/android/repository/repository2-3.xml (package "cmdline-tools;latest").
# Google publishes only SHA-1 for SDK packages, and sdkmanager checks every other package with it.
ARG ANDROID_CMDLINE_TOOLS_BUILD="16111833"
ARG ANDROID_CMDLINE_TOOLS_SHA1="e025545c62a8e64c7559119566a569fb1dec5f60"

# Must match android/app/build.gradle (compileSdk, ndkVersion) and AGP's default build-tools.
# 34-36 are what the Flutter plugins compile against (Gradle would otherwise download them
# on every build). android/build.gradle raises anything below 34 to 36.
ARG ANDROID_PLATFORMS="platforms;android-37.0 platforms;android-36 platforms;android-35 platforms;android-34"
ARG ANDROID_BUILD_TOOLS="36.0.0"
ARG ANDROID_NDK="28.2.13676358"
ARG ANDROID_CMAKE="3.22.1"

# Matches the Java/Kotlin 17 target forced in android/build.gradle.
ARG JAVA_VERSION="17"

# --- System packages ------------------------------------------------------------
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

# Trixie has no openjdk-17, so the bookworm suites are added just for this install
# and removed afterwards. Both suites are signed by the Debian archive keyring.
COPY bookworm.sources /etc/apt/sources.list.d/bookworm.sources
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates curl git unzip xz-utils zip \
       jq lcov \
       ruby-full build-essential \
    # Not "-t bookworm": apt takes the JDK from bookworm (the only suite that has it)
    # and every dependency trixie also ships from trixie.
    && apt-get install -y --no-install-recommends "openjdk-${JAVA_VERSION}-jdk-headless" \
    && rm /etc/apt/sources.list.d/bookworm.sources \
    && rm -rf /var/lib/apt/lists/*

# --- Non-root user --------------------------------------------------------------
# uid/gid 1001 match GitHub runners, and FF_DISABLE_UMASK_FOR_DOCKER_EXECUTOR handles
# GitLab. Jobs cannot apt-get install anything, so every tool they need is added above.
RUN groupadd --gid 1001 flutter \
    && useradd --create-home --shell /bin/bash --uid 1001 --gid flutter flutter
USER flutter:flutter

ENV HOME=/home/flutter
ENV SDK_ROOT="$HOME/sdks"
ENV FLUTTER_ROOT="$SDK_ROOT/flutter" \
    ANDROID_HOME="$SDK_ROOT/android-sdk" \
    JAVA_HOME="/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64" \
    GEM_HOME="$SDK_ROOT/gems" \
    FASTLANE_OPT_OUT_USAGE="YES" \
    FASTLANE_SKIP_UPDATE_CHECK="YES" \
    FASTLANE_HIDE_CHANGELOG="YES"
ENV PATH="$FLUTTER_ROOT/bin:$FLUTTER_ROOT/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$GEM_HOME/bin:$PATH"
WORKDIR $HOME

# --- Flutter SDK ----------------------------------------------------------------
RUN git clone --depth 1 --branch "$FLUTTER_VERSION" \
       https://github.com/flutter/flutter.git "$FLUTTER_ROOT" \
    && test "$(git -C "$FLUTTER_ROOT" rev-parse HEAD)" = "$FLUTTER_COMMIT" \
    && flutter config --no-analytics --no-cli-animations \
    && dart --disable-analytics \
    && flutter --version

# --- Android SDK ----------------------------------------------------------------
RUN mkdir -p "$ANDROID_HOME/cmdline-tools" "$HOME/.android" \
    && touch "$HOME/.android/repositories.cfg" \
    # Retries resume a dropped download (-C -) rather than starting over.
    && curl -fsSL --retry 5 --retry-all-errors --retry-delay 5 -C - -o /tmp/cmdline-tools.zip \
       "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_BUILD}_latest.zip" \
    && echo "${ANDROID_CMDLINE_TOOLS_SHA1}  /tmp/cmdline-tools.zip" | sha1sum -c - \
    && unzip -q /tmp/cmdline-tools.zip -d "$ANDROID_HOME/cmdline-tools" \
    && mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest" \
    && rm /tmp/cmdline-tools.zip \
    && (yes || true) | sdkmanager --licenses > /dev/null \
    # sdkmanager checks each package against the SHA-1 in Google's repository index.
    # ANDROID_PLATFORMS is unquoted on purpose so it splits into one argument per platform.
    && sdkmanager --install \
       "platform-tools" \
       $ANDROID_PLATFORMS \
       "build-tools;$ANDROID_BUILD_TOOLS" \
       "ndk;$ANDROID_NDK" \
       "cmake;$ANDROID_CMAKE" \
    && (yes || true) | flutter doctor --android-licenses > /dev/null \
    && flutter precache --android \
    && flutter doctor -v
