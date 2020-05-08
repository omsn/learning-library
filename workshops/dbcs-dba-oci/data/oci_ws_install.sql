create tablespace alpha datafile '+data';
-- defaults 100mb, unlimited

create user alpha identified by ALpha2018__ default tablespace alpha;

grant dba to alpha;

create directory tmp as '/tmp/ws';

grant all on directory tmp to public;

exit;


#!/bin/bash

sqlplus system/ALpha2018__@pdb1 << EOF

create tablespace alpha_archive datafile '+data';

create user alpha_archive identified by ALpha2018__ default tablespace alpha_archive;

grant dba to alpha_archive;

EOF

impdp alpha_archive/ALpha2018__@pdb1 directory=tmp dumpfile=oci_ws_alpha.dmp remap_schema=alpha:alpha_archive remap_tablespace=users:alpha_archive


pdb1=
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = alpha.subnet1.vcn1.oraclevcn.com)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = pdb1.subnet1.vcn1.oraclevcn.com)
    )
  )
new_pdb=
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = alpha.subnet1.vcn1.oraclevcn.com)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = new_pdb.subnet1.vcn1.oraclevcn.com)
    )
  )

