# Copyright (C) 2017  Gradiant <https://www.gradiant.org/> 
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

############################################################
# Dockerfile to build Rush container for Wirecloud
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu

# File Author/Maintainer
MAINTAINER Lorenzo García Cortiñas <lgcortinas@gradiant.org>

# Update sources
RUN apt-get update

# Install Python and its dependencies
RUN apt-get update
RUN apt-get install -y nodejs nodejs-legacy npm
RUN mkdir /usr/rush
ADD https://github.com/telefonicaid/Rush/archive/1.8.3.tar.gz /usr/rush
WORKDIR /usr/rush
RUN tar -xvf 1.8.3.tar.gz
WORKDIR /usr/rush/Rush-1.8.3
RUN npm install --production
RUN sed -i 's/localhost/redis/g' /usr/rush/Rush-1.8.3/lib/configBase.js
RUN apt-get remove -y npm
RUN apt-get autoremove -y

# Entrypoint
RUN echo "/usr/rush/Rush-1.8.3/bin/consumer & /usr/rush/Rush-1.8.3/bin/listener" >> /usr/rush/Rush-1.8.3/docker_entrypoint
RUN chmod a+x /usr/rush/Rush-1.8.3/docker_entrypoint
EXPOSE 5001
ENTRYPOINT /usr/rush/Rush-1.8.3/docker_entrypoint
