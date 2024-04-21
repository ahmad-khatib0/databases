tar zxf apache-shardingsphere-5.0.0-shardingsphere-proxy-bin.tar.gz
cd apache-shardingsphere-5.0.0-shardingsphere-proxy-bin

bin/start.sh;
 
psql -h 127.0.0.1 -p 3307 -U proxy_user -d proxy_db;

# proxy_db=> 
show schema resources;
#    name   |    type    |   host    | port |    db    |                                                                          attribute   
                                                                       
# ----------+------------+-----------+------+----------+--------------------------------------------------------------------------------------
# -----------------------------------------------------------------------
#  postgres | PostgreSQL | 127.0.0.1 | 5432 | postgres | 
#  {"maxLifetimeMilliseconds":1800000,"readOnly":false,"minPoolSize":1,
#  "idleTimeoutMilliseconds":60000,"maxPoolSize":50,"connectionTimeoutMilliseconds":30000}
# (1 row)

git clone --depth=1 https://github.com/apache/shardingsphere.git;

./mvnw clean install -Prelease -T1C -DskipTests -Djacoco.skip=true -Dcheckstyle.skip=true -Drat.skip=true -Dmaven.javadoc.skip=true -B;

docker pull apache/shardingsphere-proxy:latest;

mkdir -p $HOME/shardingsphere-proxy/conf;

docker run --name shardingsphere-proxy -i -t -p3307:3307 \ 
    -v $HOME/shardingsphere-proxy/conf:/opt/shardingsphere-proxy/conf apache/shardingsphere-proxy:latest;


# spring.shardingsphere.mode.type=Cluster
# spring.shardingsphere.mode.repository.type=ZooKeeper
# spring.shardingsphere.mode.repository.props.namespace= governance_ds
# spring.shardingsphere.mode.repository.props.server-lists=localhost:2181
# spring.shardingsphere.mode.overwrite=false


