FROM ubuntu:18.04

LABEL com.github.actions.name="Aws image checker"
LABEL com.github.actions.description="Returns de name of the image currently working in the desired machine"

ENV GITHUB_WORKSPACE=/github/workspace
RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN apt-get update && apt-get install -y jq awscli


ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR ${GITHUB_WORKSPACE}
RUN apt-get clean