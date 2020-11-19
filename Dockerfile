FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y software-properties-common
RUN apt-get install -y mesa-va-drivers
RUN apt-get install -y libdrm-dev
RUN apt-get install -y vainfo
RUN apt-get install -y git build-essential gcc make yasm autoconf automake cmake libtool checkinstall wget software-properties-common pkg-config libmp3lame-dev libunwind-dev zlib1g-dev libssl-dev
RUN apt-get install -y libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
RUN apt-get update \
    && apt-get clean \
    && apt-get install -y --no-install-recommends libc6-dev libgdiplus wget software-properties-common
RUN mkdir /var/run/sshd
RUN echo 'root:Intel123!' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN which gst-launch-1.0
RUN which gst-play-1.0

RUN gst-launch-1.0 filesrc location=head-pose-face-detection-female-and-male.mp4 ! decodebin ! videoconvert ! ximagesink sync=false
RUN ls

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
