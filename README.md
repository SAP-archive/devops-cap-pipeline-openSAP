# openSAP "Efficient DevOps with SAP" sample - Project "Piper" pipeline

[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/devops-cap-pipeline-openSAP)](https://api.reuse.software/info/github.com/SAP-samples/devops-cap-pipeline-openSAP)

Find here the sample for the openSAP course [Efficient DevOps with SAP](https://open.sap.com/courses/devops1), week 3, unit 4 'Demo of Delivery/Deployment Stages of Project "Piper" Pipelines'.

In this unit it is shown how to set up the Project "Piper" general purpose pipeline for an multi-target application (MTA) that follows SAP's Cloud Application Programming (CAP) model. Furthermore, the following configurations are performed for the pipeline:
- Build of the MTA
- Deployment of the MTA on SAP BTP, Cloud Foundry environment
- Pipeline extension to run UiVeri5 tests and publish the test results in Jenkins.

The pipeline documentation can be found [here](https://www.project-piper.io/stages/introduction/).

## Project Setup

In SAP Business Application Studio or Visual Studio Code, open a terminal.
Then clone the repo:

```sh
git clone https://github.com/sap-samples/devops-cap-pipeline-openSAP
cd devops-cap-pipeline-openSAP
```

In the `devops-cap-pipeline-openSAP` folder run:
```sh
npm install
```

To start the app on your local machine run:
```sh
cds watch
```

## UIVeri5 Test Configuration

This repository includes a standalone approuter module which provides a single point-of-entry. For the sake of simplicity, no authentication is enabled. Deploy the application to SAP BTP, Cloud Foundry environment and note the URL of the deployed application.<br>

The configuration of the UIVeri5 test is found in `app/admin/webapp/test/uiveri5/conf.js`. By default, the `baseUrl` is set to `localhost`, where the application can be accessed when run locally.
```sh
const baseUrl = "http://localhost:4004/fiori.html#manage-books";
```

You can run the UIVeri5 test locally by executing the following:
```sh
cd app/admin/webapp/test/uiveri5
uiveri5
```

Please adopt the `baseUrl` variable to your deployed application URL so that the deployed application is used during the test execution.
```sh
const baseUrl = "https://<YOUR_DEPLOYED_APPROUTER_URL>.cfapps.eu10.hana.ondemand.com/app/fiori.html#manage-books";
```

## Jenkins Setup and Pipeline Configuration

To add all pipeline specific files to your project, run the following command:

```sh
cds add pipeline
```

Details on how to start your Jenkins in your own environment for development purposes can be found in the [Operations Guide](https://github.com/SAP/devops-docker-cx-server/blob/master/docs/operations/cx-server-operations-guide.md).

Please note that other than shown in the video Jenkins now is secured by default with an admin user and password.
After you have started Jenkins with the command `cx-server start`, you can get the initial password by running `./cx-server initial-credentials`.

In Jenkins, create new credentials `cfCredentialsId` (Cloud Foundry user credentials) and `githubCredentialsId` (SSH key-pair: public key in [github](https://github.com/), private key in Jenkins credentials).

In `.pipeline/config.yaml`, fill the placeholders `<YOUR_ORG>` and `<YOUR_SPACE>` to configure your Cloud Foundry deployment target.

## Known Issues

Please look into GitHub issues for any issues reported.

## How to obtain support

[Create an issue](https://github.com/SAP-samples/<repository-name>/issues) in this repository if you find a bug.

The samples are provided "as-is". There is no guarantee that raised issues will be answered or addressed in future releases. For more information, visit the [pinboard](https://open.sap.com/courses/devops1/pinboard) section of the openSAP course and ask a question to get support.

For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html).

## License

Copyright (c) 2021 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
