# Base image can be overridden at build time.
ARG BASE_IMAGE=rockylinux:8
FROM ${BASE_IMAGE}

COPY ../common/system_update.sh /tmp/system_update.sh
COPY ../common/user_setup.sh /tmp/user_setup.sh
COPY ../common/lua_lmod_easybuild.sh /tmp/lua_lmod_easybuild.sh
RUN sed -i 's/\r$//' /tmp/system_update.sh /tmp/user_setup.sh /tmp/lua_lmod_easybuild.sh \
	&& bash /tmp/system_update.sh \
	&& bash /tmp/user_setup.sh \
	&& bash /tmp/lua_lmod_easybuild.sh \
	&& rm -f /tmp/system_update.sh /tmp/user_setup.sh /tmp/lua_lmod_easybuild.sh

EXPOSE 22
WORKDIR /home/pipeline
