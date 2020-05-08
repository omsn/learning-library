<!-- Updated March 24, 2020 -->


# Query Data in External Files


## Introduction

In this lab, you will query files on the Oracle Cloud Infrastructure Object Storage (OCI) directly without loading them to your database.

*Note: Make sure you have completed the previous lab in the menu on the right, [Load Data into ADB] (?lab=lab-4-load-data-into-adb), before you proceed with this lab. In that lab, you created data files on the OCI Object Storage and you created the credential object, all of which you will use in this lab.*

## Objectives

-   Learn how to create external tables on top of files residing on the object store

-   Learn how to query external data by the external tables


## Required Artifacts

-   The following lab requires an <a href="https://www.oracle.com/cloud/free/" target="\_blank">Oracle Cloud account</a>. You may use your own cloud account, a cloud account that you obtained through a trial, or a training account whose details were given to you by an Oracle instructor.

## STEP 1: Create External Tables with DBMS_CLOUD

1. While connected as your user in SQL Developer Web, copy and paste <a href="./files/create_external_tables_without_base_url.txt" target="\_blank">this code snippet</a> to SQL Developer worksheet.  

    Use the **create\_external\_table** procedure of the **DBMS\_CLOUD** package to create external tables on the files staged in your object store. Note that you are still using the same credential and the URLs of files on OCI Object Storage you used when loading data in the previous lab.

<!--    -   At the top of the script, specify the Object Store base URL in the definition of the **base\_URL** variable. -->

2. For each **file\_uri\_list** statement, specify the Object Store base URL that you copied and saved in the step "Copy the URLs of the Files on Your OCI Object Storage" above.

    **Note:** In SQL Developer Web, you will soon be able to define the Object Store base URL once, to use as a variable in file\_uri\_list statements. This capability is already supported in the full Oracle SQL Developer client tool.

3. Run the script.

    ![](./images/run_script_create_ext_tables_without_base_url.jpg " ")

    Now you have **external tables** for the sample data pointing to files in the object store. Any query against the external tables will return the same result as against the original tables.

## STEP 2: Querying External Data

1. Copy and paste <a href="./files/query_external_data.txt" target="\_blank">this code snippet</a> to a SQL Developer Web worksheet. Compared to the query in the previous lab, we only replaced the original table names **TABLE\_NAME** with **TABLE\_NAME\_EXT** in the sample query.  

2. **Run the script**. You will now see the same query result as in the previous lab, but from data pulled directly from the Object Store.

    ![](images/external_table_query_results.jpg " ")

    Please proceed to the next lab.

## Want to Learn More?

Click [here](https://docs.oracle.com/en/cloud/paas/autonomous-data-warehouse-cloud/user/query-external.html#GUID-ABF95242-3E04-42FF-9361-52707D14E833) for documentation on querying external data with Autonomous Data Warehouse.

## Acknowledgements

- **Author** - Nilay Panchal, ADB Product Management
- **Adapted for Cloud by** - Richard Green, Principal Developer, Database User Assistance
- **Last Updated By/Date** - Richard Green, March 2020

See an issue?  Please open up a request [here](https://github.com/oracle/learning-library/issues).   Please include the workshop name and lab in your request.
