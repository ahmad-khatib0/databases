FROM postgres
ENV POSTGRES_PASSWORD=mysecretpassword
COPY init.sql /docker-entrypoint-initdb.d
# ENV POSTGRES_HOST_AUTH_METHOD=trust
