# Create and Configure a Developer Cloud Service Instance

## Before You Begin

In this lab you will provision an Oracle Developer Cloud Service instance, gather data from your Oracle Cloud Tenancy and use the data to configure your Developer Cloud Service instance

## **Step 1**: Provision a Developer Cloud Service instance

1. Click the hamburger icon on the top left side and select **Platform Services** (under More Oracle Cloud Services Area), then select **Developer**.

  ![](./images/image13.png " ")

2. There you will be taken to Developer Cloud Service Welcome Page. Let’s start creating a DevCS instance. Click **Create Instance**.

  ![](./images/image14.png " ")

3. On next screen provide an Instance Name and fill in also Region you want to create your instance, then click **Next**:

  ![](./images/image15.png " ")

4. Check the selections in previous screen and click **Create**:

  ![](./images/image16.png " ")

5. Instance creation starts creating the service as you can see on the Status screen:

  ![](./images/image17.png " ")

This process will take some time. Proceed to the next step to gather data you'll need to configure the Developer Cloud Service Instance when it is ready.

## **Step 2**: Gather key config data from the Oracle Cloud Tenancy

Before we are able to configure a Developer Cloud Service Instance, let’s gather some key info about our OCI tenancy that will be required throughout the whole lab. So we recommend you to create a `txt` file where you store this basic info you will be required to use several times during this lab:

  - Tenancy OCID
  - User OCID
  - Private Key
  - Public Key
  - Fingerprint
  - Auth Token
  - Compartment OCID
  - Object Storage Namespace

1. From the Oracle Cloud Infrastructure interface menu, click **Administration \> Tenancy Details**:

  ![](./images/image18.png " ")

2. In Tenancy information area, select the **Copy** link to copy the OCID for tenancy and don’t forget to make a note in a txt file. Also copy the Object Storage Namespace under the Object Storage Setting area and don’t forget to make a note in a text file.

  ![](./images/image19.png " ")

3. From the Menu click **Identity \> Users**:

  ![](./images/image20.png " ")

4. In the Users area, click **Copy** for your email address user (remember this user has admin role in OCI tenancy) to copy the user’s OCID. Don’t forget to make a note in a txt file.

  ![](./images/image21.png " ")

5. Now we will create an Auth token for the user by using a public and private key. We will provide you with two already created .pem keys to download in:

  [https://github.com/oraclespainpresales/GigisPizzaHOL/tree/master/microservices/Credentials](https://github.com/oraclespainpresales/GigisPizzaHOL/tree/master/microservices/Credentials)

6. First thing you need to do is view the content of Private Key and copying private key, making a note in a txt file. Then do the same with public key and copy content into clipboard.

  ![](./images/image22.png " ")

7. Now click on your email user and you will be directed to a details screen, where you click **Api Keys** and then click **Add Public Key**.

  ![](./images/image23.png " ")

8. Now paste in popup window the Public Key previously copied in clipboard. Make sure you have copied public.pem content and not private.pem content. Click **Add**.

  ![](./images/image24.png " ")

9. Now copy Fingerprint generated as it will be used later. Don’t forget to make a note in a txt file.

  ![](./images/image25.png " ")

10. Now create parameter required (AuthToken) by clicking in Auth Tokens under Resources area, click **Generate Token** and  provide a description:

  *IMPORTANT REMINDER: AFTER YOU CLICK THE Generate Token Button, COPY THIS AUTHTOKEN AND KEEP SAFE AS IT CANNOT BE FOUND LATER*

  ![](./images/image26.png " ")

  *IMPORTANT: Copy the Generated Token in a txt file and keep safe as we will require it later:*

  ![](./images/image27.png " ")

11. Now we have to create a new Compartment as currently we only have the root one in tenancy by default. From the Menu click **Identity \> Compartments**:

  ![](./images/image28.png " ")

12. Click **Create Compartment** to open the Create Compartment dialog, and fill the Name field (for example
HandsOnLab), Description and Parent Compartment (it must be root referred with Tenancy name) and click **Create Compartment**:

  ![](./images/image29.png " ")

13. Click the Compartment name you have just created (HandsOnLab):

  ![](./images/image30.png " ")

14. And click **Copy** link to copy the Compartment OCID. Don’t forget to make a note in a txt file.

  ![](./images/image31.png " ")

This concludes the list of OCI tenancy parameters you will require to run next section.

## **Step 3**: Configure a Developer Cloud Service Instance

Now let’s check that Developer Cloud Service has been created so that we can configure it.

1. Check updated status by clicking on the refresh (![](./images/image32.png)) icon:

  ![](./images/image33.png " ")

2. Once the Developer Cloud Service instance has been provisioned, click on the right side menu and select: “Access Service Instance”:

  ![](./images/image34.png " ")

3. You will see next screen where you are requested to run some extra configurations related with Compute & Storage. Click **OCI Credentials** link in Message and have close to you the txt file with OCI information previously gathered:

  ![](./images/image35.png " ")

4. Select OCI for Account type and fill in the rest of the fields. Leave passphrase blank and also check the box below. Then click **Validate** and if you compute and storage connections are correct, click **Save**.

  ![](./images/image36.png " ")

You can proceed to the next lab.

## Want to Learn More?

* [Oracle Developer Cloud Service Documentation](https://docs.oracle.com/en/cloud/paas/developer-cloud/index.html)

## Acknowledgements
* **Authors** -  Iván Postigo, Jesus Guerra, Carlos Olivares - Oracle Spain SE Team
* **Last Updated By/Date** - Tom McGinn, April 2020

See an issue?  Please open up a request [here](https://github.com/oracle/learning-library/issues). Please include the workshop name and lab in your request.
