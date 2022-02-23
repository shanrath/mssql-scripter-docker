FROM python:3

RUN \
  pip install --upgrade pip

RUN \
  pip install -q mssql-scripter
  
RUN \
  pip install -q mssql-cli

# apt-get and system utilities
RUN \
  apt-get update && apt-get install -y \
	curl apt-transport-https debconf-utils \
    && rm -rf /var/lib/apt/lists/*

# adding custom MS repository
RUN \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN \
  curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18
# optional: for bcp and sqlcmd
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"



RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8


CMD /bin/bash 
