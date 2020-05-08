# Setup Graph environment

## Disclaimer
The following is intended to outline our general product direction. It is intended for information purposes only, and may not be incorporated into any contract. It is not a commitment to deliver any material, code, or functionality, and should not be relied upon in making purchasing decisions. The development, release, and timing of any features or functionality described for Oracle’s products remains at the sole discretion of Oracle.

## Overview

Let's load graph data from files before setting up database.

![](./images/load_data.jpg)

## Step 1: Launch Graph Server

### Clone this Repository
    $ <copy>git clone https://github.com/ryotayamanaka/oracle-pg.git</copy>

### Download and Extract Packages
Go to the following pages and download the packages.

- [Oracle Graph Server and Client 20.1](https://www.oracle.com/database/technologies/spatialandgraph/property-graph-features/graph-server-and-client/graph-server-and-client-downloads.html)
- [Apache Groovy 2.4.18](https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.18.zip)

Put the following files to `oracle-pg/docker/tmp/`

- oracle-graph-20.1.0.x86_64.rpm
- oracle-graph-zeppelin-interpreter-20.1.0.zip
- apache-groovy-binary-2.4.18.zip
 
Run the following script to extract packages:

```
$ <copy>cd oracle-pg/docker/tmp/</copy>
$ <copy>sh extract.sh</copy>
```

### Start Containers
Build and pull images, create containers, and start them.

```
$ <copy>cd oracle-pg/docker/</copy>
$ <copy>docker-compose up -d</copy>
```

It takes some time. To check the progress, see **Appendix 1**.

Access Graph Visualization.

 - [http://localhost:7007/ui/](http://localhost:7007/ui/)

Access to Zeppelin and start graph analytics, e.g. [Customer 360 Analysis](../customer_360_analysis/customer_360_analysis.md).

- [http://localhost:8080/#/](http://localhost:8080/#/)

To stop, restart, or remove the containers, see **Appendix 2**.

### Appendix 1
To check the progress, see logs.

```
$ <copy>cd oracle-pg/docker/ ;</copy>
$ <copy>docker-compose logs -f</copy>
```

`Ctl+C` to quit.

### Appendix 2
To start, stop, or restart the containers.

```
$ <copy>cd oracle-pg/docker/ ;</copy>
$ <copy>docker-compose start|stop|restart</copy>
```

To remove the docker containers.

```
$ <copy>cd oracle-pg/docker/ ;</copy>
$ <copy>docker-compose down</copy>
```

## Step 2: Configure database on Docker

In this tutorial, we will create a docker container for Oracle Database as a backend storage of graphs.
![](./images/build_docker.jpg)

### Build Docker Image
Clone `docker-images` repository.

```
$ <copy>git clone https://github.com/oracle/docker-images.git</copy>
```

Download Oracle Database.

[Oracle Database 19.3.0 for Linux x86-64 (ZIP)](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)

Put `LINUX.X64_193000_db_home.zip` under:

- `docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0/`

Build the image.

```
$ <copy>cd docker-images/OracleDatabase/SingleInstance/dockerfiles/ ;</copy>
$ <copy>bash buildDockerImage.sh -v 19.3.0 -e </copy>
```

### Start Containers

Start the containers for **Oracle Database** only.

```
$ <copy>cd oracle-pg/docker/ ;</copy>
$ <copy>docker-compose -f docker-compose-rdbms.yml up -d oracle-db </copy>
```

This step takes time. Please have a coffee break. See also **Appendix 1**.

### Configure Oracle Database

Connect to the Oracle Database server.

```    
$ <copy>docker exec -it oracle-db sqlplus sys/Welcome1@localhost:1521/orclpdb1 as sysdba</copy>
```

Set max\_string\_size running max\_string\_size.sql.

```
SQL> <copy>@/home/oracle/scripts/max_string_size.sql</copy>

...

NAME              TYPE        VALUE
----------------- ----------- ---------
max_string_size   string      EXTENDED
```

Next step is Create Graph on Database.

### Load Table Data

Connect the database as "sys" user, and create a user, "customer_360".

```
$ <copy> docker exec -it oracle-db sqlplus sys/Welcome1@localhost:1521/orclpdb1 as sysdba</copy>
```

```
SQL> <copy>@/graphs/customer_360/create_user.sql<copy>
SQL> EXIT
```

Connect the database as "customer_360" user, and create tables.

```
$ <copy>docker exec -it oracle-db sqlplus customer_360/Welcome1@localhost:1521/orclpdb1</copy>
```

```
SQL> <copy>@/graphs/customer_360/create_tables.sql</copy>
SQL> EXIT
```

### Create Property Graph

The following DDL creates a property graph (= node table and edge table) from the table data.

![](./images/create_graph.jpg)

[create_pg.pgql](./files/graphs/customer_360/create_pg.pgql)

```
CREATE PROPERTY GRAPH customer_360
  VERTEX TABLES (
    customer PROPERTIES ALL COLUMNS EXCEPT(id),
    account PROPERTIES ALL COLUMNS EXCEPT(id)
  )
  EDGE TABLES (
    owned_by
      SOURCE KEY(from_id) REFERENCES account
      DESTINATION KEY(to_id) REFERENCES customer
  )
```

Using Graph Client, connect to Oracle Database and run the DDL above.

```
$ <copy>docker exec -it graph-client opg-rdbms-jshell</copy>

> var jdbcUrl = "jdbc:oracle:thin:@oracle-db:1521/orclpdb1"
> var conn = DriverManager.getConnection(jdbcUrl, "customer_360", "Welcome1")
> conn.setAutoCommit(false)
> var pgql = PgqlConnection.getConnection(conn)
> pgql.prepareStatement(Files.readString(Paths.get("/graphs/customer_360/create_pg.pgql"))).execute() $xx ==> false
```

Exit Graph Client. See also **Appendix 2**.

    > \exit

### Loading Configuration

Set the new loading configuration into the list of preload graphs.

![](./images/load_conf.jpg)

`pgx-rdbms.conf`

```
$ oracle-pg/docker/conf/pgx-rdbms.conf
"preload_graphs": [
  {"path": "/graphs/customer_360/rdbms.json", "name": "Customer 360"},
```

`rdbms.json`

```
{
  "format":"pg",
  "db_engine":"rdbms",
  "jdbc_url":"jdbc:oracle:thin:@oracle-db:1521/orclpdb1",
  "username":"customer_360",
  "keystore_alias":"database1",
  "max_num_connections":8,
  "name":"customer_360",
  "vertex_props": [
    {"name":"type", "type":"string"},
    {"name":"name", "type":"string"},
    {"name":"age", "type":"integer"},
    {"name":"location", "type":"string"},
    {"name":"gender", "type":"string"},
    {"name":"student", "type":"string"},
    {"name":"account_no", "type":"string"},
    {"name":"balance", "type":"integer"}
  ],
  "edge_props": [
    {"name":"since", "type":"string"},
    {"name":"amount", "type":"integer"},
    {"name":"date", "type":"string"}
  ],
  "loading":{
    "load_edge_label":true
  }
}
```

Note that vertex labels are also loaded and the graph is partitioned by the labels.

See also **Appendix 3**.

Start Graph Server
Run Docker containers for Graph Server, Graph Client, and Zeppelin.

    $ <copy>cd oracle-pg/docker/ ;</copy>
    $ <copy>docker-compose -f docker-compose-rdbms.yml restart</copy>

See also **Appendix 4**.

Open Graph Visualization and check if this graph is successfully loaded.

[http://localhost:7007/ui/](http://localhost:7007/ui/)

Open Zeppelin and try running "Customer 360" analytics example.

[http://localhost:8080/](http://localhost:8080/)

### Appendix 1

You will get this error when you try to connect before the database is created.

```
$ <copy>docker exec -it oracle-db sqlplus sys/Welcome1@localhost:1521/orclpdb1 as sysdba</copy>
...
ORA-12514: TNS:listener does not currently know of service requested in connect
```

To check the progress, see logs.

```
$ cd oracle-pg/docker/
$ <copy>docker-compose -f docker-compose-rdbms.yml logs -f oracle-db</copy>
```

`Ctl+C` to quit.

### Appendix 2

You can check the graph by query (= PGQL on RDBMS), e.g. how many nodes are in the new property graph.

```
> Consumer<String> query = q -> {
    try(var s = pgql.prepareStatement(q)) {
      s.execute();
      s.getResultSet().print();
    } catch(Exception e) {
      throw new RuntimeException(e);
    }
  }
> query.accept("select count(v) from customer_360 match (v)")
+----------+
| count(v) |
+----------+
| 8        |
+----------+
```

### Appendix 3

To test loading configuration, you can access to Graph Server and try loading.

```
$ <copy>docker exec -it graph-client opg-jshell -b http://graph-server:7007</copy>
> var graph = session.readGraphWithProperties("/graphs/customer_360/rdbms.json")
```

You can also load the graph to "Graph Client", only because it uses the server package this time.

```
$ <copy>docker exec -it graph-client opg-rdbms-jshell --secret_store /opt/oracle/keystore.p12</copy>
> var graph = session.readGraphWithProperties("/graphs/customer_360/rdbms.json")
```


### Appendix 4

Start, stop, or restart the containers.

```
$ cd oracle-pg/docker/
$ docker-compose -f docker-compose-rdbms.yml start|stop|restart
```

Stop the containers and remove them.

```
$ cd oracle-pg/docker/
$ <copy>docker-compose -f docker-compose-rdbms.yml down</copy>
```


## Acknowledgements ##

- **Author** - Ryota Yamanaka - Product Manager in Asia-Pacific for geospatial and graph technologies