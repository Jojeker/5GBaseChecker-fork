FROM eclipse-temurin:11-jdk AS builder

WORKDIR /app

RUN apt-get update && \
    apt-get install -y maven git \
    xdg-user-dirs \
    libssl-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxrandr-dev \
    libxi-dev \
    wget \
    curl \
    python3 \
    python3-pip \
    ninja-build \
    clang-18 \
    clang++-18 \
    libclang-18-dev \
    python3-clang-18 \
    build-essential \
    git \
    cmake \
    libfftw3-dev \
    llvm \
    llvm-runtime \
    pkg-config \
    libboost-all-dev \
    libsctp-dev \
    gdb \
    libc++abi-dev \
    libmbedtls-dev \
    libconfig++-dev \
    libsctp-dev \
    libgnutls28-dev \
    libgcrypt-dev \
    libssl-dev \
    libidn11-dev \
    libmongoc-dev \
    libbson-dev \
    libyaml-dev \
    libnghttp2-dev \
    libmicrohttpd-dev \
    libcurl4-gnutls-dev \
    libnghttp2-dev \
    libtins-dev \
    libtalloc-dev \
    meson \
    iproute2 \
    iptables \
    libmongoc-dev \
    libbson-dev \
    libyaml-dev \
    libnghttp2-dev \
    libmicrohttpd-dev \
    libcurl4-gnutls-dev \
    liblapacke-dev \
    libnghttp2-dev \
    libtins-dev \
    libtalloc-dev \
    flex \
    bison \
    iputils-ping \
    libzmq3-dev \
    sudo \
    python3-setproctitle \
    graphviz \
    graphviz-dev \
    && rm -rf /var/lib/apt/lists/*

# Install mongodb
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb \
    && dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb \
    && wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-4.4.25.tgz \
    && tar -xvzf mongodb-linux-x86_64-ubuntu2004-4.4.25.tgz \
    && mv mongodb-linux-x86_64-ubuntu2004-4.4.25 /mongodb \
    && rm mongodb-linux-x86_64-ubuntu2004-4.4.25.tgz \
    && mkdir -p /data/db

# Set environment variables
ENV CC=/usr/bin/clang-18
ENV CXX=/usr/bin/clang++-18
ENV PATH="/mongodb/bin:${PATH}"

# Build srsRAN
WORKDIR /SRS
COPY StateSynth/modified_cellular_stack/5GBaseChecker_srs_gnb .
RUN rm -rf build \
    && mkdir build-ue \
    && cd build-ue \
    && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_COMPILER=clang++-18 -DCMAKE_C_COMPILER=clang-18 -DENABLE_SRSUE=ON -DENABLE_ASAN=ON .. \
    && make -j $(nproc) \
    && cp ./srsue/src/srsue /usr/local/bin/srsue \
    && cd .. \
    && mkdir build-gnb \
    && cd build-gnb \
    && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_COMPILER=clang++-18 -DCMAKE_C_COMPILER=clang-18 -DENABLE_SRSENB=ON -DENABLE_SRSUE=OFF -DENABLE_ASAN=OFF .. \
    && make -j $(nproc) \
    && cp ./srsenb/src/srsenb /usr/local/bin/srsenb


# Build open5gs
WORKDIR /OPEN5GS
COPY StateSynth/modified_cellular_stack/5GBaseChecker_Core .
RUN CFLAGS="-Wno-compound-token-split-by-macro -Wno-incompatible-pointer-types-discards-qualifiers -Wno-int-conversion -Wno-missing-prototypes" \
    meson build --prefix=`pwd`/install && ninja -C build \
    && ln -s /OPEN5GS/build/tests/app/5gc /usr/local/bin/5gc

# Build the learner
WORKDIR /app
COPY ./StateSynth/5GBaseChecker_Statelearner .
RUN mvn install -DskipTests

# Build OAI
# WORKDIR /OAI
# COPY StateSynth/modified_cellular_stack/5GBaseChecker_OAI_gnb .
# RUN CC=/usr/bin/clang-18 CXX=/usr/bin/clang++-18 ./cmake_targets/build_oai -w None -C --gNB --ninja --nrUE -I \
#     --disable-hardware-dependency --disable-T-Tracer --noavx2  --noavx512 \
#     && cp ./cmake_targets/ran_build/build/nr-uesoftmodem /usr/local/bin/nr-uesoftmodem \
#     && cp ./cmake_targets/ran_build/build/nr-softmodem /usr/local/bin/nr-softmodem 

# Copy over the config files and set docker mode
COPY StateSynth/modified_cellular_stack/conf /conf

