# Watchtower option

If you use rolling image tags and feel lucky watchtower can automatically pull new images and
instantiate containers from it. https://containrrr.dev/watchtower/
Please keep in mind watchtower will have access on the docker socket. This can be a security risk.
 watchtower:
   container_name: watchtower
   image: containrrr/watchtower:latest
   restart: unless-stopped
   volumes:
     - /var/run/docker.sock:/var/run/docker.soc