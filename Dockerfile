FROM ubuntu:20.04 #network

RUN apt-get update && apt-get install -y openssh-server #network
RUN apt-get install -y mesa-va-drivers
RUN apt-get install -y libdrm-dev
RUN apt-get install -y ninja-build
#RUN apt-get install -y dpkg-dev flex bison autotools-dev automake
#RUN apt-get install -y liborc-dev autopoint libtool gtk-doc-tools yasm libgstreamer1.0-dev
#RUN apt-get install -y libxv-dev libasound2-dev libtheora-dev libogg-dev libvorbis-dev
#RUN apt-get install -y libbz2-dev libv4l-dev libvpx-dev libjack-jackd2-dev libsoup2.4-dev libpulse-dev
#RUN apt-get install -y faad libfaad-dev libfaac-dev libgl1-mesa-dev libgles2-mesa-dev
RUN apt-get install -y libx264-dev libmad0-dev
RUN apt-get install -y python3-pip python3-setuptools 
RUN apt-get install -y python3-wheel ninja-build
RUN apt-get install -y vainfo
RUN apt-get install -y git build-essential gcc make yasm autoconf automake cmake libtool checkinstall wget software-properties-common pkg-config libmp3lame-dev libunwind-dev zlib1g-dev libssl-dev
RUN apt-get update \
    && apt-get clean \
    && apt-get install -y --no-install-recommends libc6-dev libgdiplus wget software-properties-common
RUN mkdir /var/run/sshd #network
RUN pwd #network
RUN echo 'root:Intel123!' | chpasswd #network
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

RUN cd
RUN pwd && ls
RUN mkdir gstreamer
RUN cd gstreamer
RUN wget https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.17.90.tar.xz
RUN tar -xf gstreamer-1.17.90
WORKDIR gstreamer-1.17.90
RUN meson build
RUN ninja -C build

ADD head-pose-face-detection-female-and-male.mp4 /gstreamer
RUN gst-launch-1.0 filesrc location=head-pose-face-detection-female-and-male.mp4 ! decodebin ! videoconvert ! ximagesink sync=false
RUN ls

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

#https://gist.github.com/alasin/0be40411eea149343a296c85e0407bd7
#https://gstreamer.freedesktop.org/documentation/tools/gst-launch.html?gi-language=c
