# TIBCO Platform Workbook

Version 1.0

![](./images/TIBCO_Platform.png)

## Objectives

The objective of this workshop is to give customers a taster of the new TIBCO Platform capabilities available today (platform version 1.4.0)

This workbook provides a use-case for customers to follow using the provided lab environment. The environment consists of:

- Windows Desktop containing development tooling

- Linux Server running a TIBCO Control Plane and two Data Planes (K8S and Bare Metal)

## Section 1 - Build an API using Flogo and deploy to TIBCO Platform

> Dave works for a small telecommunications company as the TIBCO expert. You take the place of Dave who has years of experience in TIBCO and is 'itching' to use the new TIBCO Platform his company has available. He has years of BusinessWorks 5 experience, but is fairly new to TIBCO Flogo.
>
>His manager Steve bursts into his office one morning?
>
>"Dave, look we're up against the clock; the Spring development team is struggling to get the new Customer API built in time for the launch of the new DXP platform. The front-end development squad are blocked waiting for a working API to call and have asked me if you can build something quickly using TIBCO?"
>
>"Sure you reply, I have just the right tools for the job. Exactly what do I need to build? Has the API Product Owner got the specification?"
>
>"Yes, and the DBA has created the database too!" Steve replied anxiously.
>
>What you need to do...
>
>Your first task is to create the new Customer API using TIBCO Flogo and get it deployed to the TIBCO Platform Integration environment.
>
>The database has been created for you and there's some test rows in the customer table ready for you to use.


### Task 1 - Connect the Postgres Database

> Objective: A PostgreSQL database publicly available is used during this workshop.

1. The Postgres Database connection details are:
```
postgresql://neondb_owner:************@ep-mute-fire-a9qqz3hw-pooler.gwc.azure.neon.tech/neondb?sslmode=require
```

Name | Value
--|--   
Host|ep-mute-fire-a9qqz3hw-pooler.gwc.azure.neon.tech
Port|5432
Database Name|neondb
Username|neondb_owner
Password|**********

### Task 2 - Implement the getCustomerById operation

> [!NOTE]  
> Objective: The getCustomerById operation should retrieve a row from the Customer Table using the {id} path parameter and return a Customer JSON object.

#### Step 1 - Create project repository folder and launch Visual Studio Code

In this section, we will perform the following:

- Open a command prompt
- Create a repository folder
- Launch Visual Studio Code.

1. Open a Command Prompt, and run the following commands:

```
mkdir src
cd src
mkdir flogo-customer-api
cd flogo-customer-api
code .
```


*Leave the window open, we will come back to this shortly.*

![](./images/Image_6.png)

3. Your VSC workspace should look something like this:

![](./images/Image_7.png)

#### Step 2- Import the Open API Specifications (OAS) Files from Github Repository

In this section, we will perform the following:

- Create a Folder called **spec**
- Import API Specification files from Github
- From the Explorer View, select **New Folder**

![](./images/Image_8.png)

- Name the new folder **spec**. This is where we will place our OAS resources needed for the API implementation.

![](./images/Image_9.png)

- From your Command Window change directory into the spec folder and run the following command to retrieve the OAS resource from the remote GIT server:

```
wget https://raw.githubusercontent.com/atsfr-tibco-devhub/TIBCO-Platform-Workshop/refs/heads/main/src/flogo-customer-api/spec/openapi3_0.json
```
- If you are using PowerShell - the command to retrieve the OAS resource is slightly different:
```
wget https://raw.githubusercontent.com/atsfr-tibco-devhub/TIBCO-Platform-Workshop/refs/heads/main/src/flogo-customer-api/spec/openapi3_0.json -OutFile openapi3_0.json
```

- In Visual Studio Code Explorer, use the Explorer Refresh action to refresh.


#### Step 3 - Review the Open API Specification

1. Open the newly imported openapi3_0.json specification from the Explorer View. From within the editor window, press the **SHIFT+ALT+P** key combination to bring up Swagger Preview window.

![](./images/Image_1.png)

2. Review the ‘Retrieve a customer object’ API. 
   
* It uses the HTTP GET method with a path of /customer/{id} and returns two HTTP response codes of 200 or 404.  
* A response code 200 should return a JSON object of the customer that matches the id parameter. 
* If no customer object exists then the API must return a 404 response code.
   
![](./images/Image_2.png)

1. Once you have familiarised yourself with the specification then go ahead and close the Swagger Preview and the Editor windows.

#### Step 4 - Create the Flogo Application

In this section, we will perform the following:

- Create a Flogo Application

1. Hover over the **FLOGO-CUSTOMER-API** in the Explorer view. Click the **Create New Flogo App** action

![](./images/Image_10.png)

2. A dialog box will be displayed for you to enter the name of the new Flogo application. Enter **customer-api** and hit return.

![](./images/Image_11.png)

3. We will skip creating Unit Tests for this application, go ahead and select **Create App Only.**

![](./images/Image_12.png)

4. The Flogo Plugin will launch to show the following viewport.

![](./images/Image_13.png)

#### Step 5 - Create the Postgres Database Connection

In this section, we will perform the following:

- create a connection to the PostgreSQL database. The connection will be used by the Flogo Flows in order to interact with the database.

1. Click **CONNECTIONS** option on the screen to create a new connection, then click **Create connection**

![](./images/Image_14.png)

2. Select a Connection Type of **PostgreSQL Connector**

![](./images/Image_15.png)

3. Configure the PostgreSQL connector with the following:

| Database Type | PostgreSQL |
|---|---|
| Connection Name | postgres |
| Description | postgres |
| Host | ep-mute-fire-a9qqz3hw-pooler.gwc.azure.neon.tech |
| Port | 5432 |
| Database Name | neondb |
| User | neondb_owner |
| Password | ************ |
| Secure Connection | true |
| TLS | VerifyCA |
| CA Certificate | ISRG_Root_X1.pem |

4. Click **Connect**

![](./images/Image_16.png)

#### Step 6 - Create Flogo App Trigger

In this section, we will perform the following:

- Create a Trigger to receive a HTTP Message
- Use the API specification to configure the trigger

1. Hover over the **No trigger**, a context pop-up will appear showing **+ Add trigger**. Click to add a trigger to the Flogo Application

![](./images/Image_17.png)

2. From the Triggers bar, locate the **Receive HTTP Message** Trigger and drag it over to the Triggers section.

![](./images/Image_18.gif)

The following dialog will be shown:

![](./images/Image_19.png)

3. Change the **Configure Using API Specs** from False to True.

4. Click the **Browse...** button now highlighted

![](./images/Image_20.png)

5. An Open dialog box will appear, now navigate to your API specification file saved earlier under the **spec** folder. Select the file **openapi3_0.json** and click **Open**

![](./images/Image_21.png)

6. Configure **Path** by selecting the drop-down menu, select the **/customer/{id}** option:

![](./images/Image_22.png)

7. Configure **Method** by selecting the drop-down menu, select **GET** option:

![](./images/Image_23.png)

8. Click **Continue**.

9. A dialog box will appear asking **Do you want to copy this triggers Output Schema into the Flows Inputs?**. Click the **Copy schema** button.
![](./images/Image_136.png)
![](./images/Image_24.png)

11. Nice work so far, you're well on your way to finishing your first API in Flogo. The Trigger has now been configured for the **GET /customer/{id}** operation ready for you to implement the API logic.

#### Step 7 - Develop the getCustomerById Flow

In this section, we will perform the following:

- Implement logic to retrieve a row from the PostgreSQL database and return the Customer JSON reply with a 200 response code.
- Handle logic if no row is returned from the PostgreSQL database and return a 404 response code.
  
The complete flow will look like this:

![](./images/Image_25.png)

| Activity Name | Type | Purpose |
|---|---|---|
|  |  |  |
| LogMessage | Log | Log a message containing the customer identifier passed into the operation |
| FetchCustomerRow | PostgreSQL Query | Retrieve a row from the customer table that matches its primary key |
| MapperCustomer | Mapper | Create a JSON Customer object and populate with values returned from the database |
| Return200 | Return | Return a 200 HTTP response code with a Customer JSON response body |
| LogMessageWarnNotFound | Log | Log a warning message if the record is not found in the database |
| Return404 | Return | Return a 404 HTTP response code and an empty response body when no customer record exists in the database |

**LogMessage Activity**

> [!NOTE]  
> Objective: Log a message containing the customer identifier passed into the operation.

1. Drag a **Log Message** from the Activity Bar -> General onto the canvas.

![](./images/Image_26.gif)

2. Configure the LogMessage activity, set the Activity inputs->message field to the following expression:

| Field | Expression |
|---|---|
| message | string.concat('Retrieving customer object for id: ',coerce.toString($flow.pathParams.id)) |

![](./images/Image_27.gif)

The LogMessage activity Input should look like this:

![](./images/Image_28.png)

**FetchCustomerRow Activity**

> [!NOTE]  
> Objective: Retrieve a row from the customer table that matches its primary key.

1. Drag a **PostgreSQL Query** activity from the Activity Bar -> PostgreSQL onto the canvas and connect to LogMessage activity. Rename the activity to **FetchCustomerRow**.

![](./images/Image_29.gif)

2. Configure the PostgreSQLQuery activity Settings to use the connector **postgres** and the schema **public**:

![](./images/Image_30.gif)

The PostgreSQLQuery activity Settings should look like this:

![](./images/Image_31.png)

3. Configure the PostgreSQLQuery activity Input Settings. Set the Query Statement to retrieve a row from the customer table where the id attribute equals the bounded parameter value of ?id:

| Query Statement |
|---|
| SELECT * FROM customer WHERE id=?id; |

![](./images/Image_32.gif)

The PostgreSQLQuery activity Input Settings should look like this:

![](./images/Image_33.png)

4. Configure the PostgreSQLQuery activity Input. Map the flow path parameter value (passed from the Trigger URL Path /customer/{id} to the Flow) to the bounded parameter ?id:

![](./images/Image_34.gif)

5. Modify the expression to coerce the id field from a String to an Integer using the coerce.toInt() function

The PostgreSQLQuery activity Input should look like this:

![](./images/Image_35.png)

**MapperCustomer Activity**

> [!NOTE]  
> Objective: Create a JSON Customer object and populate with values returned from the database.

1. Drag a **Mapper** activity from the Activity Bar -> General -> Mapper onto the canvas and connect to FetchCustomerRow activity. Rename the activity to **MapperCustomer**.

![](./images/Image_36.gif)

2. Add the following JSON representation to the **MapperCustomers** Input Settings. This will form the response object we reply back with. Click Save.

```
{
  "id":1,
  "name": "John Doe",
  "email": "john.doe@example.com",
  "age": 30,
  "city": "New York"
}
```

![](./images/Image_37.gif)


3. Map the Input of the MapperCustomer activity from the Output of the FetchCustomerRow activity.

| Field | Expression |
|---|---|
| id | $activity[FetchCustomerRow].Output.records[0].id |
| name | $activity[FetchCustomerRow].Output.records[0].name |
| email | $activity[FetchCustomerRow].Output.records[0].email |
| age | $activity[FetchCustomerRow].Output.records[0].age |
| city | $activity[FetchCustomerRow].Output.records[0].city |


![](./images/Image_38.gif)

**Return200 Activity**

> [!NOTE]  
> Objective: Return a 200 HTTP response code with a Customer JSON response body.

1. Drag a **Return** activity from the Activity Bar -> Default-> Return onto the canvas and connect to MapperCustomer activity. Rename the activity to **Return200**.

![](./images/Image_39.gif)

2. Map the Outputs of the Return200 activity. Set the **code** field to 200 and responseBody->body to the MapperCustomer->output. Click Save.

| Field | Expression |
|---|---|
| code | 200 |
| responseBody/body | $activity[MapperCustomer].output |


![](./images/Image_40.gif)

**LogMessageWarnNotFound Activity**

> [!NOTE]  
Objective: Log a warning message if the record is not found in the database.

1. Drag a **Log** activity from the Activity Bar -> General-> Log onto the canvas and connect to FetchCustomerRow activity. Rename the activity to **LogMessageWarnNotFound**.

![](./images/Image_41.gif)

2. On the activity settings panel change the Log Level to Warn.

3. On the activity Input panel set Activity input -> message to the following expression:

| Field | Expression |
|---|---|
| message | string.concat('No records returned for customer id: ',coerce.toString($flow.pathParams.id))
 |

![](./images/Image_42.gif)

**Return404 Activity**

> [!NOTE]  
> Objective: Return a 404 HTTP response code and an empty response body when no customer record exists in the database.

1. Drag a **Return** activity from the Activity Bar -> Default-> Return onto the canvas and connect to LogMessageWarnNotFound activity. Rename the activity to **Return404**.

![](./images/Image_43.gif)

3. Map the Outputs of the Return404 activity. Set the **code** field to 404. Set the responseBody->body to **''**. Click Save.

| Field | Expression |
|---|---|
| code | 404 |
| responseBody/body | '' |

![](./images/Image_44.gif)

**FetchCustomerRow to MapperCustomer Branch**

> [!NOTE]  
> Objective: Conditional branch logic is required from FetchCustomerRow and MapperCustomer activities so that when a row is found the flow executes our 200-OK response scenario.

![](./images/Image_45.png)

1. Click the **Green** condition between FetchCustomerRow and MapperCustomer to open the dialog box for Branch Mapping Settings. Change the branch type to **Success with condition**. Set the conditional expression. Click Save.

| Expression |
|---|
| array.count($activity[FetchCustomerRow].Output.records) > 0 |

![](./images/Image_46.gif)

**FetchCustomerRow to LogMessageWarnNotFound Branch**

> [!NOTE]  
> Objective: Conditional branch logic is required from FetchCustomerRow to LogMessageWarnNotFound activities so that when no row is found the flow executes our 404-NotFound response scenario.

1. Click the **Green** condition between FetchCustomerRow and LogMessageWarnNotFound to open the dialog box for Branch Mapping Settings. Change the branch type to **Success with no matching Condition**. Click **Save**.

![](./images/Image_47.gif)

##### Step 7 - Rename the Flow to getCustomerById

Finally, now we have finished implementing the flow, let's give it a proper name to match the API specification operationID.

1. Click the **New_flow** label and change it to **getCustomerById**.

![](./images/Image_48.gif)

2. Click the description label and change it to **Returns a customer object by Id**.

3. Now, Use File -> Save to make sure all your changes are saved to disk.





### Task 3 - Build the Application Locally

> [!NOTE]  
> Objective: Now you have implemented your Customer API let's go ahead and build an executable that we can then use to test it locally through curl.

1. At the bottom-left of Visual Studio Code, you will see the Flogo App panel. Click the expand arrow

![](./images/Image_55.png)

The Flogo plugin for Visual Studio Code can target builds for either Local or TIBCO Platform. With local build it is no longer necessary to compile your flogo application via TIBCO Cloud Integration platform, everything is done on the developer machine.

2. Select a runtime

![](./images/Image_56.png)

3. Select local runtime and click build

![](./images/Image_57.gif)

4. After a few minutes you will see a pop-up dialog message declaring **File built successfully**.

![](./images/Image_58.png)

5. Expand the bin folder in your explorer panel to reveal the generated executable for your customer api.

![](./images/Image_59.png)

6. Right click on the customer-api.exe, select Reveal in File Explorer. Launch the customer-api.exe

![](./images/Image_60.png)

7. Launch a new command prompt and run the following command:

```
curl -i http://localhost:9999/customer/1
```

![](./images/Image_61.png)

8. Now try and use an Id value that does not exist in the database (e.g. 9), the Customer API should return a 404 response.

![](./images/Image_62.png)

9. As we have now tested our application, you can go back to running application and press "ctrl-c" to exit the application, before we move onto creating Unit Tests below.

### Task 4 - Create Unit Tests

> [!NOTE]  
> Objective: Flogo supports the ability to create unit tests that can be used to verify the functionality of your applications flow logic through a test case/suite model. We will write a test case to verify that the getCustomerById flow correctly returns the correct customer for Id=1.

![](./images/Image_63.png)

![](./images/Image_64.png)

![](./images/Image_65.png)

4. Click **Flow Input** and assign Flow Inputs Path Parameter Id to 1. Click Save and Close.

![](./images/Image_66.gif)

5. Click **Flow Output**. Select **Assert On Outputs** from the dropdown menu. Select **+** to add a new assertion. Name the assertion **Return 200 success**.  

6. Select **Outputs/output/code** from the Available Data pane and drag-and-drop onto the assertion expression. 

7. Set the assertion logic to **$flow.code == 200**. Click Save and Close.

![](./images/Image_67.gif)

![](./images/Image_68.png)

8. Click **MapperCustomer**. Select **Assert on Outputs** from the dropdown menu. Select **+** to add a new assertion. Name the assertion **CheckMapperOutput**. 

9. Select **Outputs/output/id** from the Available Data pane and drag-and-drop onto the assertion expression.

10. Set the assertion logic to **$activity[MapperCustomer].output.id==1**.  

11. Append the expression with a Boolean-And **&&**.  Similarly the same with **name** field but add equality **==** to the term and check that the name field equals **John Doe**.

The complete expression should be: 

```
$activity[MapperCustomer].output.id==1 && $activity[MapperCustomer].output.name=="John Doe"
```

Click Save and Close.

![](./images/Image_69.gif)

![](./images/Image_70.png)

![](./images/Image_71.png)

The Flogo Application will be compiled and the unit test will be executed. The terminal window will show the results of running the unit test suite:

![](./images/Image_72.png)

![](./images/Image_73.gif)

> Please Note: If the test suite above did not start - please make sure that the application is not already running, if it is running - just exit the application using "ctrl-c" and try re-running the unit test.


### Task 5 - OPTIONAL - Implement the createCustomer operation

> [!WARNING]
> If you have enough time, you can implement another operation to create additional customers. Otherwise, please continue to 
[Build and Deploy to TIBCO Platform](#task-6---build--deploy-to-tibco-platform)


> [!NOTE]  
> Objective: The createCustomer operation should insert a row in the customer table using the JSON request body provided. The response should contain the newly created customer identifier for the customer record.


#### Step 1 - Add the createCustomer flow to the Trigger

In this section, we will perform the following:

- Add a new Flow to the Customer.

1. To add the createCustomer Flow to the existing Trigger, use the top-left hand navigation link to the customer-api.

![](./images/Image_49.png)

2. Hover on the Customer Trigger until you see the '+ New flow** pop-up dialog appear. Click on it.

3. On the Path drop-down choose the **/customer** path option.

4. On the Method drop-down choose the **POST** option. Click Continue.

5. Click **Copy schema** on the **Do you want to copy this triggers Output Schema into the Flows Inputs** prompt window.

![](./images/Image_50.gif)

6. Rename the flow **createCustomer** and the description to **Create a customer object**.

![](./images/Image_51.gif)

#### Step 2 - Develop the createCustomer Flow

In this section, we will perform the following:

- Implement logic to insert a row into the PostgreSQL database and return the Customer JSON reply with a 201 response code.

The complete flow will look like this:

![](./images/Image_52.png)

| Activity Name | Type | Purpose |
|---|---|---|
|  |  |  |
| LogDebugRequestBodyMessage | Log | Log a message containing the request Post Body passed into the operation |
| GetNextSeqId | PostgreSQL Query | Retrieve the next value identity sequence from 'customer_id_seq' |
| InsertCustomer | PostgreSQL Insert | Insert a row into the customer table with identity value. |
| LogDebugInsertMessage |  | Log a debug message containing the new record identity used. |
| MapperCustomer | Mapper | Create a JSON Customer object and populate with identity value and post body values. |
| Return201 | Return | Return a 201 HTTP response code with a Customer JSON response body |

**LogDebugRequestBodyMessage Activity**

> [!NOTE]  
> Objective: Log a message containing the HTTP request body passed into the operation..

1. Drag a **Log Message** from the Activity Bar -> General onto the canvas.

2. Rename the activity to **LogDebugRequestBodyMessage**.

3. Configure the LogMessage activity, set the Log Level to **DEBUG**. Set the Activity inputs->message field to the following expression:

| Field | Expression |
|---|---|
| message | utility.renderJSON($flow.body,boolean.true()) |

**GetNextSeqId Activity**

> [!NOTE]  
> Objective: Retrieve the next value from the customer_id_seq sequence that will be used for the customer id.

1. Drag a **PostgreSQL Query** from the Activity Bar -> PostgreSQL and connect to LogDebugRequestBodyMessage activity. Rename the activity to **GetNextSeqId**.

2. Configure the PostgreSQLQuery activity Settings to use the connector **postgres** and the schema **public**:

3. Configure the Input Settings. Set the Query Statement to:

```
SELECT nextval('customer_id_seq');
```
4. Verify that the Fields Table has been automatically populated with the field **nextval**.

**InsertCustomer Activity**

> [!NOTE]  
> Objective: To insert a new row into the customer table with fields mapped from the POST request body and the **nextval** fields.

1. Drag a **PostgreSQL Insert** from the Activity Bar -> PostgreSQL and connect to GetNextValue activity. Rename the activity to **InsertCustomer**.

2. Configure the PostgreSQLQuery activity Settings to use the connector **postgres** and the schema **public**:

3. Configure the Input Settings. Set the Insert Statement to:

```
INSERT INTO public.customer(id, name, email, age, city) VALUES (?id, ?name, ?email, ?age, ?city);
```

4. Verify that the Fields Table has been automatically populated. It should look like this:

![](./images/Image_53.png)

5. Map the Input of the activity from the $flow/body and GetNextSeqId output .

| Field | Expression |
|---|---|
| id | $activity[GetNextSeqId].Output.records[0].nextval |
| name | $flow.body.name |
| email | $flow.body.email |
| age | $flow.body.age |
| city | $flow.body.city |

6. The Activity Inputs for the InsertCustomer activity is expecting an Array. The icon to the left of the field denotes its type. In this case "Arr" for Array:
![](./images/Image_53.1.png)

7. As this is an array field, we need to either "Iterate" through a set of inputs, or create at least 1 entry in the array so that we can map our values. To insert 1 entry, click on the 3 dots next to the "values" field and choose "Add-Item". You will then be able to map the values from the GetNextSeqId activity (remembering to change the Index value to 0 from the placeholder), and the Flow data for the rest of the objects:

![](./images/Image_53.2.gif)

The mapping should look like this:

![](./images/Image_54.png)

**LogDebugInsertMessage Activity**

> [!NOTE]  
> Objective: Log a debug message containing the customer identity information..

1. Drag a **Log** activity from the Activity Bar -> General-> Log onto the canvas and connect to InsertCustomer activity. Rename the activity to **LogDebugInsertMessage**.

2. On the activity settings panel change the Log Level to Debug.

3. On the activity Input panel set Activity input -> message to the following expression:

| Field | Expression |
|---|---|
| message | string.concat("Inserted customer into table with Id: ",coerce.toString($activity[GetNextSeqId].Output.records[0].nextval))
 |

**MapperCustomer Activity**

> [!NOTE]  
> Objective: Create a JSON Customer object and populate with values to be returned.

1. Drag a **Mapper** activity from the Activity Bar -> General -> Mapper onto the canvas and connect to LogDebugInsertMessage activity. Rename the activity to **MapperCustomer**.

2. Add the following JSON representation to the MapperCustomers' Input Settings. This will form the response object we reply back with. Click Save.

```
{
  "id":1,
  "name":"John Doe",
  "email":"john.doe@example.com",
  "age": 30,
  "city":"New York"
}
```

3. Map the Input of the MapperCustomer activity from the Output of the FetchCustomerRow activity.

| Field | Expression |
|---|---|
| id | $activity[GetNextSeqId].Output.records[0].nextval |
| name | $flow.body.name |
| email | $flow.body.email |
| age | $flow.body.age |
| city | $flow.body.city |


**Return201 Activity**

> [!NOTE]  
> Objective: Return a 201 HTTP response code with a Customer JSON response body.

1. Drag a **Return** activity from the Activity Bar -> Default-> Return onto the canvas and connect to MapperCustomer activity. Rename the activity to **Return201**.

2. Map the Outputs of the Return201 activity. Set the **code** field to 201 and responseBody->body to the MapperCustomer->output. Click Save.

| Field | Expression |
|---|---|
| code | 201 |
| responseBody/body | $activity[MapperCustomer].output |


## Task 6 - Build & Deploy to TIBCO Platform

> [!NOTE]  
> Objective: To deploy the Customer API to a Dataplane on the TIBCO Platform from Visual Studio Code.

Before we start deploying to the TIBCO Platform, we first need to make sure that Visual Studio Code and the Flogo plugin is authenticated against the platform, otherwise our deploy steps will fail.

#### Re-Authenticate against the TIBCO Control Plane

1. Find the Flogo icon in the project explorer on the left hand side of Visual Studio Code and click on it:

![](./images/Image_73.1.png)

2. If you expand the "Platform" tree followed by "Apps", you will see an error similar to the following:

![](./images/Image_73.2.png)

3. This tells us that we are not logged into the platform and we will need to re-authenticate. To do that, if you hover over the "Platform" tree, you can choose the "Pencil" icon to edit the connection:

![](./images/Image_73.3.png)

4. Follow the steps to re-authenticate against the TIBCO Platform. Use all the defaults. DO NOT FORGET TO PRESS SAVE!

![](./images/Image_73.4.gif)

5. We can now go back to our Flogo Application to continue the steps below to deploy it to the Data Plane. To return to our application - click on the Folder button in the left hand toolbar:


#### Task 6 - Build & Deploy to TIBCO Platform

1. Configure Flogo to use Platform Runtime Profile by clicking on the configuration icon:

![](./images/Image_74.png)

2. A dialog box will appear at the top of Visual Studio Code to select runtime. Choose **platform**.

![](./images/Image_75.png)

3. The Flogo Actions will now show a further option **Deploy** to allow you to deploy your Flogo Application to TIBCO Platform. Click the triangle next to the **Deploy Action** to run the action

![](./images/Image_76.png)

A pop-up box will be shown during the deployment run action.

![](./images/Image_77.png)

Once the pop-up disappears your Customer API will be deployed to your TIBCO Platform Dataplane. Let's now login to TIBCO Control Plane to see your newly deployed Customer API.

## Section 2 - Managing your Applications using TIBCO Platform

### Task 7 - Login to TIBCO Control Plane

> [!NOTE]  
> Objective: To familiarise users of the TIBCO Control Plane

1. Login to TIBCO Control Plane via the desktop shortcut provided **Control Plane**.

![](./images/Image_78.png)

2. On the Home landing page you can see your newly deployed application **customer-api** has been deployed to a Kubernetes-based Data Plane **atspa-dp-ec2mk** and that its Status is **Running**.

![](./images/Image_79.png)

4. By default your application has been deployed with a private endpoint, so in order for the API to be consumed externally it must have its endpoint visibility set to public.

### Task 8 - Expose Customer API endpoint to public traffic

> [!NOTE]  
> Objective: Any newly deployed application is configured with a private endpoint on a designated TIBCO Data Plane. To expose the Customer API endpoint we must make it public.


![](./images/Image_80.png)

2. Click **Set Endpoint Visibility**

![](./images/Image_81.png)

3. Update Endpoint visibility to Public by selecting the **Flogo Ingress** and setting the Service Path Prefix to /customer-api/v1. Click **Update Endpoint visibility to Public**.

![](./images/Image_82.png)

4. Your API will now be exposed publicly at the following endpoint of:

```
https://flogoapps.localhost.dataplanes.pro/customer-api/
```
5. Paste the following URL into a browser window to check your API is running correctly. This will invoke the Get Customer By ID operation you have just implemented.

```
https://flogoapps.localhost.dataplanes.pro/customer-api/v1/customer/1
```

![](./images/Image_83.png)


### Task 9 - Observability

> [!NOTE]  
> Objective: TIBCO Platform provides comprehensive observability data for applications deployed. A health dashboard of each Dataplane provides 'at-a-glance' information. Flows/Activities measurements, Machine Resource for CPU & Memory utilisation, and Success/Failure Counters of Applications deployed to the Platform.

### Task 10 - View Application Logs

> [!NOTE]  
> Objective: The TIBCO Platform integrates log forwarding to internal logging services provided to the TIBCO Platform via Elastic Stack. 
> The TIBCO Platforms Control Plane allows you to quickly access your TIBCO Application logs to quickly find any log records written by any Log Activities added to your application logic.

1. Open the Logs view for the customer-api application

![](./images/Image_84.png)

2. The default is provide historical log view, let's stream logs in Realtime by selecting **Realtime option**. You will observe that the last log entry shows our log message **Retrieving customer object for id: 1**.

![](./images/Image_85.png)

![](./images/Image_86.png)

![](./images/Image_87.png)

### Task 11 - View Application Traces 

> [!NOTE]  
> Objective: To observe application telemetry information for distributed traces in order to identify performance issues.

1. TIBCO Platform uses Open Telemetry tooling built in to provide observability of any TIBCO applications deployed to your TIBCO Dataplanes. By default this is disabled on newly deployed applications so we will need to enable it using the Environmental Controls settings.

2. Open the Environmental Controls page. Click Engine Variables. Set the **FLOGO_OTEL_TRACE** value to **true**. Click 'Push Updates'

![](./images/Image_88.gif)

3. The TIBCO Platform will re-configure the deployed application and now Open Telemetry Tracing for this application will be configured.

4. Using your browser, fire some more requests to the API E.g. Customer 1,2 and 5.

5. Click Traces page to view the captured Open Telemetry Span Metrics:

![](./images/Image_89.png)

6. Click one of the spans to drill down into.

![](./images/Image_90.gif)

7. In this trace we can see that the FetchCustomerRow activity took a proportionally long time of 3.16ms to execute compared to the overall execution time of 3.26ms for the entire API call.

![](./images/Image_91.png)

8. Expand the top-level Span **Tags** section to reveal the attributes captured. The attribute value for **flogo.flow.id** can be used to find log entries relating to this particular flow.

![](./images/Image_92.gif)

![](./images/Image_93.png)

### Task 12 - Scaling Applications

> [!NOTE]  
> Objective: TIBCO Platform utilises Kubernetes for FT/HA thus ensuring your applications remain running at all times. When demand requires, any application can be scaled up or down through the TIBCO Control Plane.

1. Scaling the Customer application to 2 by toggling the up-arrow above the [1]. Click the **Scale** button.

![](./images/Image_95.png)

![](./images/Image_96.png)

2. Now scale your app to zero. Your application is stopped.

---


